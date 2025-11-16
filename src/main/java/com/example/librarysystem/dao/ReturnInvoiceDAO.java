package com.example.librarysystem.dao;
import com.example.librarysystem.model.ReturnInvoice;
import com.example.librarysystem.model.ReturnItem;
import com.example.librarysystem.model.FineDetail;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ReturnInvoiceDAO {

    private static final Logger log = LoggerFactory.getLogger(ReturnInvoiceDAO.class);
    private final Connection connection;

    public ReturnInvoiceDAO(Connection connection) {
        this.connection = connection;
    }


    public boolean createReturnInvoice(ReturnInvoice invoice) throws SQLException {

        // Lấy StaffId từ đối tượng Invoice
        String staffId = null;
        if (invoice.getStaff() != null) {
            staffId = invoice.getStaff().getStaffId();
        }

        if (staffId == null) {
            log.error("Lỗi: Không thể lấy StaffId từ đối tượng ReturnInvoice.");
            // Giả định bạn muốn trả về false nếu thiếu dữ liệu quan trọng
            return false;
        }

        String INSERT_INVOICE = "INSERT INTO tblReturnInvoice (id, readerid, staffid, status) VALUES (?, ?, ?, 'UNPAID')";
        String INSERT_RETURN_ITEM = "INSERT INTO tblReturnItem (id, returninvoiceid, loanitemid, returndate) VALUES (?, ?, ?, ?)";
        // ✅ ĐÃ SỬA: BỎ CỘT 'quantity' KHỎI CÂU LỆNH INSERT
        String INSERT_FINE_DETAIL = "INSERT INTO tblFineDetail (id, fineid, returnitemid, note) VALUES (?, ?, ?, ?)";

        boolean success = false;
        String invoiceId = "RI-" + UUID.randomUUID().toString().substring(0, 8);
        invoice.setId(invoiceId);

        try {
            connection.setAutoCommit(false);

            // --- 2. INSERT VÀO BẢNG ReturnInvoice ---
            try (PreparedStatement psInvoice = connection.prepareStatement(INSERT_INVOICE)) {
                psInvoice.setString(1, invoiceId);
                psInvoice.setString(2, invoice.getReader().getReaderId());
                psInvoice.setString(3, staffId);

                if (psInvoice.executeUpdate() == 0) {
                    throw new SQLException("Thêm ReturnInvoice thất bại.");
                }
                log.info("Đã tạo ReturnInvoice ID: {}", invoiceId);
            }

            // --- 3. LẶP VÀ INSERT ReturnItems và FineDetails ---
            for (ReturnItem item : invoice.getReturnItems()) {
                String returnItemId = "RT-" + UUID.randomUUID().toString().substring(0, 8);

                // a. INSERT vào BẢNG ReturnItem
                try (PreparedStatement psReturnItem = connection.prepareStatement(INSERT_RETURN_ITEM)) {
                    psReturnItem.setString(1, returnItemId);
                    psReturnItem.setString(2, invoiceId);
                    psReturnItem.setString(3, item.getLoanItem().getId());
                    psReturnItem.setTimestamp(4, Timestamp.valueOf(item.getReturnDate()));

                    if (psReturnItem.executeUpdate() == 0) {
                        throw new SQLException("Thêm ReturnItem thất bại: " + item.getLoanItem().getId());
                    }
                    log.debug("Đã thêm ReturnItem: {}", returnItemId);
                }

                // b. INSERT vào BẢNG FineDetail
                if (item.getFineDetails() != null) {
                    for (FineDetail fd : item.getFineDetails()) {

                        try (PreparedStatement psFineDetail = connection.prepareStatement(INSERT_FINE_DETAIL)) {
                            psFineDetail.setString(1, "FD-" + UUID.randomUUID().toString().substring(0, 8)); // ID
                            psFineDetail.setString(2, fd.getFine().getId()); // Fineid
                            psFineDetail.setString(3, returnItemId); // ReturnItemid
                            psFineDetail.setString(4, fd.getNote()); // note
                            // ✅ ĐÃ BỎ: psFineDetail.setInt(5, fd.getQuantity());

                            if (psFineDetail.executeUpdate() == 0) {
                                throw new SQLException("Thêm FineDetail thất bại: " + fd.getFine().getId());
                            }
                            log.debug("Đã thêm FineDetail: {}", fd.getFine().getId());
                        }
                    }
                }
            }

            connection.commit();
            success = true;
            log.info("Transaction tạo hóa đơn {} hoàn tất thành công.", invoiceId);

        } catch (SQLException e) {
            log.error("Transaction tạo hóa đơn thất bại. Thực hiện Rollback.", e);
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                log.error("Lỗi khi Rollback.", rollbackEx);
            }
            throw e;

        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                log.error("Không thể khôi phục AutoCommit.", ex);
            }
        }

        return success;
    }
    public boolean updateStatus(String invoiceId) {
        String SQL = "UPDATE tblReturnInvoice SET status = 'PAID' WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(SQL)) {
            ps.setString(1, invoiceId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            log.error("Lỗi cập nhật status cho invoice {} -> {}", invoiceId, e);
            return false;
        }
    }
}