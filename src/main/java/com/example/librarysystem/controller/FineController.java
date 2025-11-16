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
            for (ReturnItem returnItem : returnItems) {
                returnItem.setFineDetails(
                        returnItem.getFineDetails().stream()
                                .filter(fd -> fd.getFine() == null || !"late".equals(fd.getFine().getType()))
                                .collect(Collectors.toList())
                );

                LoanItem loanItem = returnItem.getLoanItem();


                if (now.isAfter(loanItem.getDueDate())) {
                    long daysLate = Duration.between(loanItem.getDueDate(), now).toDays();
                    log.info("Trễ hạn {} ngày → tính phạt", daysLate);

                    if (daysLate > 0) {
                        FineDetail fineDetail = new FineDetail();
                        fineDetail.setId("FD-" + UUID.randomUUID().toString().substring(0, 8));
                        fineDetail.setFine(lateFine);
                        fineDetail.setQuantity((int) daysLate);
                        fineDetail.setNote("Late " + daysLate + " days");
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
            response.sendRedirect("staff/ReturnBasket.jsp");
            return;
        }

        HttpSession session = request.getSession();
        List<ReturnItem> returnItems = (List<ReturnItem>) session.getAttribute("returnItems");

        ReturnItem targetReturn = null;
        String bookTitle = "";
        if (returnItems != null) {
            targetReturn = returnItems.stream()
                    .filter(item -> loanItemId.equals(item.getLoanItem().getId()))
                    .findFirst().orElse(null);
            if (targetReturn != null && targetReturn.getLoanItem().getCopy() != null) {
                bookTitle = targetReturn.getLoanItem().getCopy().getDocument().getTitle();
            }
        }


        Set<String> selectedFineIds = new HashSet<>();
        if (targetReturn != null && targetReturn.getFineDetails() != null) {
            targetReturn.getFineDetails().stream()
                    .filter(fd -> fd.getFine() != null && "damage".equals(fd.getFine().getType()))
                    .forEach(fd -> selectedFineIds.add(fd.getFine().getId()));
        }

        try {
            List<Fine> damageFines = fineDAO.getListDamageFine();

            // LƯU VÀO SESSION (QUAN TRỌNG!)
            session.setAttribute("damageFines", damageFines);
            session.setAttribute("selectedDamageFineIds", selectedFineIds);

            // VẪN LƯU VÀO REQUEST ĐỂ JSP DÙNG
            request.setAttribute("damageFines", damageFines);
            request.setAttribute("selectedFineIds", selectedFineIds);
            request.setAttribute("targetLoanItemId", loanItemId);
            request.setAttribute("bookTitle", bookTitle);
            request.setAttribute("reader", session.getAttribute("reader"));

            request.getRequestDispatcher("staff/DamageFine.jsp").forward(request, response);
        } catch (Exception e) {
            log.error("Lỗi lấy danh sách phạt hư hỏng", e);
            request.setAttribute("error", "Lỗi hệ thống!");
            request.getRequestDispatcher("staff/ReturnBasket.jsp").forward(request, response);
        }
    }

    private void chooseDamageFine(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String loanItemId = request.getParameter("loanItemId");
        String fineId = request.getParameter("fineId");

        if (loanItemId == null || fineId == null) {
            log.error("Thiếu tham số: loanItemId={}, fineId={}", loanItemId, fineId);
            sendJsonError(response, "Thiếu tham số!");
            return;
        }

        HttpSession session = request.getSession();
        List<ReturnItem> returnItems = (List<ReturnItem>) session.getAttribute("returnItems");
        Set<String> selectedFineIds = (Set<String>) session.getAttribute("selectedDamageFineIds");
        List<Fine> damageFines = (List<Fine>) session.getAttribute("damageFines");




        log.info("Tìm ReturnItem với loanItemId={}", loanItemId);
        ReturnItem targetReturn = returnItems.stream()
                .filter(item -> item.getLoanItem() != null && loanItemId.equals(item.getLoanItem().getId()))
                .findFirst()
                .orElse(null);

        if (targetReturn == null) {
            log.error("Không tìm thấy ReturnItem với loanItemId={}", loanItemId);
            sendJsonError(response, "Không tìm thấy sách trả!");
            return;
        }

        log.info("Tìm Fine với fineId={}", fineId);
        Fine fine = damageFines.stream()
                .filter(f -> fineId.equals(f.getId()))
                .findFirst()
                .orElse(null);

        if (fine == null) {
            log.error("Không tìm thấy Fine với fineId={}", fineId);
            sendJsonError(response, "Phạt không tồn tại!");
            return;
        }


        List<FineDetail> currentDetails = targetReturn.getFineDetails();
        if (currentDetails == null) {
            currentDetails = new ArrayList<>();
            log.info("Khởi tạo FineDetail list mới cho ReturnItem");
        }


        boolean isSelected = currentDetails.stream()
                .anyMatch(fd -> fd.getFine() != null && fineId.equals(fd.getFine().getId()));

        if (isSelected) {
            log.info("BỎ CHỌN fineId: {}", fineId);
            currentDetails.removeIf(fd -> fineId.equals(fd.getFine().getId()));
            selectedFineIds.remove(fineId);
        } else {
            log.info("CHỌN fineId: {}", fineId);
            FineDetail newDetail = new FineDetail();
            newDetail.setFine(fine);
            newDetail.setNote("Damage Fine: " + fine.getReason());
            currentDetails.add(newDetail);
            selectedFineIds.add(fineId);
        }

        targetReturn.setFineDetails(currentDetails);
        session.setAttribute("returnItems", returnItems);
        session.setAttribute("selectedDamageFineIds", selectedFineIds);


        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"ok\"}");

        log.info("=== chooseDamageFine HOÀN TẤT ===");
    }
    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write("{\"status\":\"error\", \"message\":\"" + message + "\"}");
    }
}