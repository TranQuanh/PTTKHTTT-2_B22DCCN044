package com.example.librarysystem.controller;

import com.example.librarysystem.dao.FineDAO;
import com.example.librarysystem.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.Connection;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/fine")
public class FineController extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(FineController.class);
    private FineDAO fineDAO;

    private static final String DAMAGE_FINES_SESSION_KEY = "damageFinesList";
    // ✅ KHÓA SESSION MỚI để lưu FineDetails đang hoạt động
    private static final String CURRENT_FINE_DETAILS_KEY = "currentDamageFineDetailsMap";

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
        fineDAO = new FineDAO(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "calculateLateFine";

        switch (action) {
            case "calculateLateFine" -> calculateLateFine(request, response);
            case "listDamageFine" -> doGetListDamageFine(request, response);
            default -> response.sendRedirect("staff/ReturnBasket.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter.");
            return;
        }

        switch (action) {
            case "chooseDamageFine" -> chooseDamageFine(request, response);
            default -> response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
        }
    }

    private void calculateLateFine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ... (Logic tính phạt trễ hạn giữ nguyên) ...
        HttpSession session = request.getSession();
        List<ReturnItem> returnItems = (List<ReturnItem>) session.getAttribute("returnItems");

        if (returnItems == null || returnItems.isEmpty()) {
            log.warn("Không có returnItems trong session! Chuyển hướng về ReturnBasket.");
            response.sendRedirect("staff/ReturnBasket.jsp");
            return;
        }

        try {
            Fine lateFine = fineDAO.getLateFine();
            if (lateFine == null) {
                log.error("Không tìm thấy Fine có type='late' trong DB!");
                request.setAttribute("error", "Cấu hình phạt trễ hạn chưa được thiết lập!");
                request.getRequestDispatcher("staff/ReturnBasket.jsp").forward(request, response);
                return;
            }

            LocalDateTime now = LocalDateTime.now();
            log.info("Bắt đầu tính phạt trễ hạn cho {} bản trả sách.", returnItems.size());

            for (ReturnItem returnItem : returnItems) {
                log.debug("=== Xử lý ReturnItem ID: {} ===", returnItem.getId());

                // Loại bỏ phạt trễ hạn cũ trước khi tính toán lại
                returnItem.setFineDetails(
                        returnItem.getFineDetails().stream()
                                .filter(fd -> fd.getFine() == null || !"late".equals(fd.getFine().getType()))
                                .collect(Collectors.toList())
                );

                LoanItem loanItem = returnItem.getLoanItem();
                if (loanItem == null) {
                    log.warn("ReturnItem {} không có LoanItem → bỏ qua", returnItem.getId());
                    continue;
                }

                if (loanItem.getDueDate() == null) {
                    log.warn("LoanItem {} có dueDate = null → bỏ qua", loanItem.getId());
                    continue;
                }

                if (now.isAfter(loanItem.getDueDate())) {
                    long daysLate = Duration.between(loanItem.getDueDate(), now).toDays();
                    log.info("Trễ hạn {} ngày → tính phạt", daysLate);

                    if (daysLate > 0) {
                        FineDetail fineDetail = new FineDetail();
                        fineDetail.setId("FD-" + UUID.randomUUID().toString().substring(0, 8));
                        fineDetail.setFine(lateFine);
                        fineDetail.setQuantity((int) daysLate);
                        fineDetail.setNote("Trễ hạn " + daysLate + " ngày");
                        returnItem.getFineDetails().add(fineDetail);

                        log.info("Đã thêm FineDetail [late] | Days: {}", daysLate);
                    }
                } else {
                    log.debug("Đúng hạn hoặc trả sớm → không phạt");
                }
            }

            session.setAttribute("returnItems", returnItems);
            log.info("Tính phạt hoàn tất. Chuyển hướng về ReturnBasket.");
            request.getRequestDispatcher("staff/ReturnBasket.jsp").forward(request, response);

        } catch (Exception e) {
            log.error("Lỗi khi tính tiền phạt", e);
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi tính phạt!");
            request.getRequestDispatcher("staff/ReturnBasket.jsp").forward(request, response);
        }
    }

    private void doGetListDamageFine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String loanItemId = request.getParameter("loanItemId");

        if (loanItemId == null) {
            log.warn("Thiếu LoanItemId khi chọn Damage.");
            response.sendRedirect("staff/ReturnBasket.jsp");
            return;
        }

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("reader");
        List<ReturnItem> returnItems = (List<ReturnItem>) session.getAttribute("returnItems");

        String bookTitle = "";

        // 1. TÌM ReturnItem MỤC TIÊU và TẠO MAP TRUNG GIAN
        ReturnItem targetReturn = null;
        Map<String, FineDetail> fineDetailsMap = new HashMap<>(); // ✅ MAP TRUNG GIAN

        if (returnItems != null) {
            targetReturn = returnItems.stream()
                    .filter(item -> item.getLoanItem() != null && loanItemId.equals(item.getLoanItem().getId()))
                    .findFirst()
                    .orElse(null);

            if (targetReturn != null) {
                if (targetReturn.getLoanItem().getCopy() != null &&
                        targetReturn.getLoanItem().getCopy().getDocument() != null) {
                    bookTitle = targetReturn.getLoanItem().getCopy().getDocument().getTitle();
                }

                // ✅ Đổ dữ liệu FineDetails hiện có vào Map (Key: FineID, Value: FineDetail)
                if (targetReturn.getFineDetails() != null) {
                    targetReturn.getFineDetails().stream()
                            .filter(fd -> fd.getFine() != null && !"late".equals(fd.getFine().getType())) // Chỉ lấy Fine Damage
                            .forEach(fd -> fineDetailsMap.put(fd.getFine().getId(), fd));
                }
            }
        }

        // 2. LƯU MAP TRUNG GIAN VÀO SESSION và REQUEST
        session.setAttribute(CURRENT_FINE_DETAILS_KEY, fineDetailsMap);
        request.setAttribute("currentFineDetailsMap", fineDetailsMap); // Dùng cho JSP

        try {
            List<Fine> damageFines = fineDAO.getListDamageFine();
            session.setAttribute(DAMAGE_FINES_SESSION_KEY, damageFines);

            request.setAttribute("damageFines", damageFines);
            request.setAttribute("targetLoanItemId", loanItemId);
            request.setAttribute("reader", reader);
            request.setAttribute("bookTitle", bookTitle);

            log.info("Lấy {} loại phạt Damage cho LoanItem {}. FineDetail Map size: {}", damageFines.size(), loanItemId, fineDetailsMap.size());

            request.getRequestDispatcher("staff/DamageFine.jsp").forward(request, response);
        } catch (Exception e) {
            log.error("Lỗi khi lấy danh sách phạt Damage", e);
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi lấy danh sách phạt hư hỏng!");
            request.getRequestDispatcher("staff/ReturnBasket.jsp").forward(request, response);
        }
    }

    private void chooseDamageFine(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        String loanItemId = request.getParameter("loanItemId");
        String fineId = request.getParameter("fineId");
        String quantityStr = request.getParameter("quantity");

        // ... (Kiểm tra Quantity và Tham số giữ nguyên) ...
        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) throw new NumberFormatException();
        } catch (Exception e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Quantity phải là số nguyên dương.\" }");
            log.warn("Lỗi Quantity (fineId: {}, qty: {})", fineId, quantityStr);
            return;
        }

        if (loanItemId == null || fineId == null) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Thiếu tham số (loanItemId hoặc fineId).\"}");
            return;
        }

        // 1. Lấy dữ liệu từ SESSION
        List<Fine> damageFines = (List<Fine>) session.getAttribute(DAMAGE_FINES_SESSION_KEY);
        Map<String, FineDetail> fineDetailsMap = (Map<String, FineDetail>) session.getAttribute(CURRENT_FINE_DETAILS_KEY); // ✅ Lấy Map
        List<ReturnItem> returnItems = (List<ReturnItem>) session.getAttribute("returnItems");

        if (fineDetailsMap == null || returnItems == null || damageFines == null) {
            log.error("Thiếu dữ liệu Fine/ReturnItem/Map trong Session.");
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Thiếu dữ liệu phiên. Vui lòng tải lại trang.\" }");
            return;
        }

        // 2. Tìm Fine object từ Session
        Optional<Fine> optFine = damageFines.stream()
                .filter(f -> Objects.equals(f.getId(), fineId))
                .findFirst();

        if (!optFine.isPresent()) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Không tìm thấy Fine ID trong danh sách session.\" }");
            return;
        }
        Fine fine = optFine.get();

        // 3. Xử lý Thêm/Xóa trong Map
        if (fineDetailsMap.containsKey(fineId)) {
            // HÀNH ĐỘNG 1: BỎ CHỌN (Xóa khỏi Map)
            fineDetailsMap.remove(fineId);
            log.info("Đã BỎ CHỌN Fine: {} khỏi Map.", fineId);
        } else {
            // HÀNH ĐỘNG 2: CHỌN (Thêm vào Map)
            FineDetail newFineDetail = new FineDetail();
            newFineDetail.setId("FD-" + UUID.randomUUID().toString().substring(0, 8)); // Tạo ID mới
            newFineDetail.setFine(fine);
            newFineDetail.setQuantity(quantity);
            newFineDetail.setNote("Phạt hư hỏng sách: " + fine.getReason() + " (x" + quantity + ")");

            fineDetailsMap.put(fineId, newFineDetail);
            log.info("Đã CHỌN Fine: {} vào Map với Qty: {}", fineId, quantity);
        }

        // 4. ĐỒNG BỘ NGƯỢC LẠI vào ReturnItem chính (RẤT QUAN TRỌNG)
        Optional<ReturnItem> optReturnItem = returnItems.stream()
                .filter(item -> item.getLoanItem() != null && Objects.equals(item.getLoanItem().getId(), loanItemId))
                .findFirst();

        if (optReturnItem.isPresent()) {
            ReturnItem returnItem = optReturnItem.get();

            // Lấy các FineDetails không phải Damage (ví dụ: late fine)
            List<FineDetail> nonDamageFines = returnItem.getFineDetails().stream()
                    .filter(fd -> fd.getFine() != null && "late".equals(fd.getFine().getType()))
                    .collect(Collectors.toList());

            // Thêm tất cả các FineDetails Damage mới từ Map vào
            nonDamageFines.addAll(fineDetailsMap.values());

            returnItem.setFineDetails(nonDamageFines); // Ghi đè danh sách chi tiết phạt
        }

        // 5. Cập nhật Session và Phản hồi
        session.setAttribute(CURRENT_FINE_DETAILS_KEY, fineDetailsMap); // Cập nhật Map trong session
        session.setAttribute("returnItems", returnItems); // Cập nhật ReturnItems chính

        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"ok\"}");
    }
}