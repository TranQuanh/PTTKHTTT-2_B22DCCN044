package com.example.librarysystem.controller;

import com.example.librarysystem.model.LoanItem;
import com.example.librarysystem.model.ReturnItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/returnItem")
public class ReturnItemController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "choose":
                chooseReturnItem(request, response);
                break;
            default:
                response.sendRedirect("staff/ReturnBasket.jsp");
        }
    }

    private void chooseReturnItem(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        String loanItemId = request.getParameter("loanItemId");

        if (loanItemId == null) {
            response.sendRedirect("staff/BorrowList.jsp");
            return;
        }

        // ✅ BƯỚC SỬA ĐỔI: LẤY DANH SÁCH TỪ SESSION
        List<LoanItem> currentLoanItems =
                (List<LoanItem>) session.getAttribute("currentLoanItems");

        if (currentLoanItems == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Loan item list not in session.\"}");
            return;
        }

        // ✅ BƯỚC SỬA ĐỔI: TÌM KIẾM LOANITEM ĐẦY ĐỦ BẰNG loanItemId
        LoanItem fullLoanItem = currentLoanItems.stream()
                .filter(item -> item.getId() != null && item.getId().equals(loanItemId))
                .findFirst()
                .orElse(null);

        if (fullLoanItem == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Loan Item not found in current session list.\"}");
            return;
        }

        // Lấy danh sách ReturnItem (đã có)
        List<ReturnItem> returnItems =
                (List<ReturnItem>) session.getAttribute("returnItems");

        if (returnItems == null) {
            returnItems = new ArrayList<>();
        }

        // ... (Phần kiểm tra đã tồn tại) ...
        ReturnItem existing = null;
        for (ReturnItem item : returnItems) {
            if (item.getLoanItem() != null &&
                    loanItemId.equals(item.getLoanItem().getId())) {
                existing = item;
                break;
            }
        }


        if (existing != null) {
            returnItems.remove(existing);
        } else {
            // ... (Phần thêm mới) ...
            ReturnItem newReturn = new ReturnItem();
            newReturn.setReturnDate(LocalDateTime.now());

            // 🔑 GÁN LOANITEM ĐẦY ĐỦ 🔑
            newReturn.setLoanItem(fullLoanItem);

            returnItems.add(newReturn);
        }

        session.setAttribute("returnItems", returnItems);

        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"ok\"}");
    }
}