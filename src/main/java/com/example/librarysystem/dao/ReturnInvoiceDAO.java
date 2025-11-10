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

    /**
     * Tạo và lưu trữ toàn bộ Hóa đơn trả sách, bao gồm ReturnItems và FineDetails liên quan.
     * Transaction đảm bảo tính toàn vẹn dữ liệu.
     *
     * @param invoice Đối tượng ReturnInvoice đã được đóng gói đầy đủ dữ liệu.
     * @param staffId ID của nhân viên thực hiện giao dịch (dùng cho bảng ReturnInvoice).
     * @return true nếu giao dịch thành công, ngược lại false.
     * @throws SQLException Nếu có lỗi SQL.
     */
    public boolean createReturnInvoice(ReturnInvoice invoice, String staffId) throws SQLException {

        // SQL Dựa trên Schema chỉ có 3 cột: id, Readerid, Staffid
        String INSERT_INVOICE = "INSERT INTO ReturnInvoice (id, Readerid, Staffid) VALUES (?, ?, ?)";

        // Các bảng khác giữ nguyên:
        String INSERT_RETURN_ITEM = "INSERT INTO ReturnItem (id, ReturnInvoiceid, LoanItemid, returnDate) VALUES (?, ?, ?, ?)";
        String INSERT_FINE_DETAIL = "INSERT INTO FineDetail (id, Fineid, ReturnItemid, note, quantity) VALUES (?, ?, ?, ?, ?)";

        boolean success = false;
        String invoiceId = "RI-" + UUID.randomUUID().toString().substring(0, 8);

        try {
            connection.setAutoCommit(false);

            // --- 2. INSERT VÀO BẢNG ReturnInvoice (Chỉ 3 cột) ---
            try (PreparedStatement psInvoice = connection.prepareStatement(INSERT_INVOICE)) {

                psInvoice.setString(1, invoiceId);
                psInvoice.setString(2, invoice.getReader().getReaderId()); // Readerid
                psInvoice.setString(3, staffId); // Staffid

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
                    psReturnItem.setString(2, invoiceId); // ReturnInvoiceid
                    psReturnItem.setString(3, item.getLoanItem().getId()); // LoanItemid
                    psReturnItem.setTimestamp(4, Timestamp.valueOf(item.getReturnDate())); // returnDate

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
                            psFineDetail.setInt(5, fd.getQuantity()); // quantity

                            if (psFineDetail.executeUpdate() == 0) {
                                throw new SQLException("Thêm FineDetail thất bại: " + fd.getFine().getId());
                            }
                            log.debug("Đã thêm FineDetail: {}", fd.getFine().getId());
                        }
                    }
                }
            }

            // 4. CAM KẾT VÀ HOÀN TẤT TRANSACTION
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
}