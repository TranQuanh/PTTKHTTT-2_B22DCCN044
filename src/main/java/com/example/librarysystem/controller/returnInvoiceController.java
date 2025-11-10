package com.example.librarysystem.controller;

import com.example.librarysystem.dao.ReturnInvoiceDAO;
import com.example.librarysystem.model.Reader;
import com.example.librarysystem.model.ReturnInvoice;
import com.example.librarysystem.model.ReturnItem;
import com.example.librarysystem.model.Staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/returnInvoice")
public class returnInvoiceController extends HttpServlet {
    private static final Logger log = LoggerFactory.getLogger(ReturnItemController.class);
    private ReturnInvoiceDAO returnInvoiceDAO;

    public void init() throws ServletException {

        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
        returnInvoiceDAO = new ReturnInvoiceDAO(connection);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("createReturnInvoice".equals(action)) {
            createReturnInvoice(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
        }
    }
    private void createReturnInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<ReturnItem> returnItems = (List<ReturnItem>) session.getAttribute("returnItems");
        Reader reader = (Reader) session.getAttribute("reader");

        // ✅ Lấy đối tượng Staff (Member) từ Session
        Staff staffMember = (Staff) session.getAttribute("staff");

        // Lấy Staff ID từ đối tượng Member
        String staffId = (staffMember != null) ? staffMember.getStaffId() : null;

        if (staffId == null || reader == null || returnItems == null || returnItems.isEmpty()) {
            log.error("Thiếu dữ liệu cần thiết (Staff/Reader/Items) để tạo hóa đơn.");
            // Kiểm tra chi tiết để dễ debug
            if (staffId == null) log.error("Lỗi: staffId là NULL");
            if (reader == null) log.error("Lỗi: reader là NULL");
            if (returnItems == null || returnItems.isEmpty()) log.error("Lỗi: returnItems là NULL hoặc EMPTY");

            request.setAttribute("error", "Thiếu dữ liệu để tạo hóa đơn. Vui lòng thử lại.");
            request.getRequestDispatcher("staff/ReturnInvoice.jsp").forward(request, response);
            return;
        }

        // 1. TÍNH TOÁN DỮ LIỆU LOGIC
        double grandTotalFine = 0;
        LocalDateTime now = LocalDateTime.now();

        for (ReturnItem item : returnItems) {
            if (item.getFineDetails() != null) {
                for (var fd : item.getFineDetails()) {
                    if (fd.getFine() != null) {
                        grandTotalFine += (fd.getFine().getAmount() * fd.getQuantity());
                    }
                }
            }
            item.setReturnDate(now);
        }


        ReturnInvoice invoice = new ReturnInvoice();
        invoice.setStaff(staffMember);
        invoice.setReader(reader);

        invoice.setReturnItems(returnItems);

        // 3. GỌI DAO ĐỂ LƯU TOÀN BỘ GIAO DỊCH
        try {
            // DAO phải gán ID được tạo (nếu có) vào đối tượng 'invoice'
            boolean success = returnInvoiceDAO.createReturnInvoice(invoice, staffId);

            if (success) {

                // 🚀 BƯỚC LOGGING QUAN TRỌNG TRƯỚC KHI FORWARD
                log.info("----------------------------------------------------------");
                log.info("📝 LOG DỮ LIỆU TRƯỚC KHI CHUYỂN HƯỚNG TỚI PAYMENTSLIP.JSP");
                log.info("----------------------------------------------------------");

                // Log các thông tin chính của Hóa Đơn
                log.info("Mã Hóa Đơn (ID): {}", invoice.getId());
                log.info("Tổng Tiền Phạt (GrandTotalFine): {}", grandTotalFine);
                log.info("Thời Gian Giao Dịch: {}", LocalDateTime.now());

                // Log thông tin Độc Giả
                if (invoice.getReader() != null) {
                    log.info("Độc Giả ID: {}", invoice.getReader().getReaderId());
                    log.info("Độc Giả Tên: {}", invoice.getReader().getFullName());
                } else {
                    log.error("LỖI: Đối tượng Reader trong Invoice là NULL!");
                }

                // Log thông tin Nhân Viên
                if (invoice.getStaff() != null) {
                    log.info("Nhân Viên ID: {}", invoice.getStaff().getStaffId());
                    log.info("Nhân Viên Tên: {}", invoice.getStaff().getFullName());
                } else {
                    log.error("LỖI: Đối tượng Staff trong Invoice là NULL!");
                }

                // Log chi tiết các sách trả (nếu có)
                if (invoice.getReturnItems() != null && !invoice.getReturnItems().isEmpty()) {
                    log.info("Tổng số Sách Trả: {}", invoice.getReturnItems().size());
                    for (ReturnItem item : invoice.getReturnItems()) {
                        log.info("  -> Mã LoanItem: {}, Tên Sách: {}, Tiền Phạt Item: {}",
                                item.getLoanItem().getId(),
                                item.getLoanItem().getCopy().getDocument().getTitle(),
                                item.getFineDetails().stream()
                                        .mapToDouble(fd -> fd.getFine().getAmount() * fd.getQuantity())
                                        .sum());
                    }
                } else {
                    log.error("LỖI: Không có ReturnItem nào trong Invoice!");
                }
                log.info("----------------------------------------------------------");

                // Xóa các session tạm thời sau khi lưu thành công
                session.removeAttribute("returnItems");
                session.removeAttribute("reader");
                session.removeAttribute("currentLoanItems");

                // ĐẶT ĐỐI TƯỢNG INVOICE VÀ TỔNG TIỀN VÀO REQUEST
                session.setAttribute("returnInvoice", invoice);
                session.setAttribute("grandTotalFine", grandTotalFine);
                // Chuyển hướng sang trang in phiếu tiền
                request.getRequestDispatcher("staff/PaymentSlip.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Lưu hóa đơn vào CSDL thất bại (Lỗi DAO).");
                request.getRequestDispatcher("staff/ReturnInvoice.jsp").forward(request, response);
            }

        } catch (Exception e) {
            log.error("Lỗi khi tạo hóa đơn trả sách", e);
            request.setAttribute("error", "Lỗi hệ thống khi xử lý giao dịch: " + e.getMessage());
            request.getRequestDispatcher("staff/ReturnInvoice.jsp").forward(request, response);
        }
    }
}
