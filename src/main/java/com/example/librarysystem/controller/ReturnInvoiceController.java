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
public class ReturnInvoiceController extends HttpServlet {
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
        } else if ("updateStatus".equals(action)) {
            doUpdateStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
        }
    }
    private void createReturnInvoice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<ReturnItem> returnItems = (List<ReturnItem>) session.getAttribute("returnItems");
        Reader reader = (Reader) session.getAttribute("reader");

        Staff staffMember = (Staff) session.getAttribute("staff");
        String staffId = (staffMember != null) ? staffMember.getStaffId() : null;

        if (staffId == null || reader == null || returnItems == null || returnItems.isEmpty()) {
            log.error("Thiếu dữ liệu cần thiết (Staff/Reader/Items) để tạo hóa đơn.");
            // (Phần log lỗi chi tiết giữ nguyên)
            request.setAttribute("error", "Thiếu dữ liệu để tạo hóa đơn. Vui lòng thử lại.");
            request.getRequestDispatcher("staff/ReturnInvoice.jsp").forward(request, response);
            return;
        }

        // 1. TÍNH TOÁN DỮ LIỆU LOGIC
        double grandTotalFine = 0;
        LocalDateTime now = LocalDateTime.now();

        for (ReturnItem item : returnItems) {
            double itemFine = 0;
            if (item.getFineDetails() != null) {
                for (var fd : item.getFineDetails()) {
                    if (fd.getFine() != null) {
                        // Cần giả định logic tính toán (Late/Damage Fine) đúng ở đây
                        // Giả sử fd.getQuantity() có giá trị để tính Late Fine
                        int quantity = (fd.getQuantity() != null) ? fd.getQuantity() : 1;
                        if ("late".equals(fd.getFine().getType())) {
                            itemFine += (fd.getFine().getAmount() * quantity);
                        } else if ("damage".equals(fd.getFine().getType())) {
                            itemFine += fd.getFine().getAmount(); // Giả sử tiền đã là tổng
                        }
                    }
                }
            }
            grandTotalFine += itemFine;
            item.setReturnDate(now);
        }

        ReturnInvoice invoice = new ReturnInvoice();
        invoice.setStaff(staffMember);
        invoice.setReader(reader);
        invoice.setReturnItems(returnItems);

        // 3. GỌI DAO ĐỂ LƯU TOÀN BỘ GIAO DỊCH
        try {
            // DAO sẽ gán ID vào đối tượng 'invoice'
            // Thay đổi gọi DAO theo cấu trúc mới: createReturnInvoice(invoice)
            boolean success = returnInvoiceDAO.createReturnInvoice(invoice);

            if (success) {

                // 🚀 LOG DỮ LIỆU CẦN THIẾT TRƯỚC KHI CHUYỂN HƯỚNG
                log.info("----------------------------------------------------------");
                log.info("📝 LOG DỮ LIỆU CHUYỂN SANG PAYMENTSLIP.JSP");
                log.info("----------------------------------------------------------");

                // Kiểm tra các đối tượng trong Session
                session.setAttribute("returnInvoice", invoice);
                session.setAttribute("grandTotalFine", grandTotalFine);

                log.info("  -> SESSION SET: returnInvoice (ID: {})", invoice.getId());
                log.info("  -> SESSION SET: grandTotalFine ({})", grandTotalFine);

                // Kiểm tra các trường dữ liệu quan trọng mà JSP sử dụng
                log.info("  1. Invoice ID (Mã GD): {}", invoice.getId());
                log.info("  2. Tổng Tiền Phạt: {}", grandTotalFine);
                log.info("  3. Độc Giả ID: {}", (invoice.getReader() != null ? invoice.getReader().getReaderId() : "NULL"));
                log.info("  4. Nhân Viên ID: {}", (invoice.getStaff() != null ? invoice.getStaff().getStaffId() : "NULL"));

                // Kiểm tra ReturnItems và ReturnDate (Dữ liệu chính cho JSP)
                if (invoice.getReturnItems() != null && !invoice.getReturnItems().isEmpty()) {
                    ReturnItem firstItem = invoice.getReturnItems().get(0);
                    log.info("  5. Tổng số Sách Trả: {}", invoice.getReturnItems().size());
                    log.info("  6. ReturnDate của Item 0 (Cần cho Thời Gian GD): {}", firstItem.getReturnDate());
                    log.info("  7. ReturnDate định dạng (getDisplayReturnDateTime): {}", firstItem.getDisplayReturnDateTime());

                    // Kiểm tra chi tiết fine
                    for (ReturnItem item : invoice.getReturnItems()) {
                        if (item.getFineDetails() != null) {
                            for (var fd : item.getFineDetails()) {
                                log.info("    -> Chi tiết Phạt - Loại: {}, Số tiền: {}",
                                        fd.getFine().getType(), fd.getFine().getAmount());
                            }
                        }
                    }
                } else {
                    log.error("LỖI CẢNH BÁO: Không có ReturnItem trong Invoice sau khi tạo!");
                }
                log.info("----------------------------------------------------------");


                // Xóa các session tạm thời sau khi lưu thành công
                session.removeAttribute("returnItems");
                session.removeAttribute("reader");
                session.removeAttribute("currentLoanItems");

                // Chuyển hướng sang trang in phiếu tiền
                request.getRequestDispatcher("staff/PaymentSlip.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Lưu hóa đơn vào CSDL thất bại (Lỗi DAO).");
                request.getRequestDispatcher("staff/ReturnInvoice.jsp").forward(request, response);
            }
        } catch (Exception e) {
            log.error("Lỗi server khi tạo hóa đơn trả sách: ", e);
            request.setAttribute("error", "Lỗi xử lý server khi tạo hóa đơn: " + e.getMessage());
            request.getRequestDispatcher("staff/ReturnInvoice.jsp").forward(request, response);
        }
    }
    private void doUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String returnId = request.getParameter("returnId");


            boolean updated = returnInvoiceDAO.updateStatus(returnId);


            if (updated) {
                response.getWriter().write("UPDATED");
            } else {
                response.getWriter().write("FAILED");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("ERROR");
        }
    }
}
