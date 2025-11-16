package com.example.librarysystem.controller;

import com.example.librarysystem.dao.LoanItemDAO;
import com.example.librarysystem.model.LoanItem;
import com.example.librarysystem.model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/loanItem")
public class LoanItemController extends HttpServlet {

    private LoanItemDAO loanItemDAO;

    @Override
    public void init() throws ServletException {
        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
        loanItemDAO = new LoanItemDAO(connection);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Nếu không có action -> mặc định gọi listByReader
        if (action == null || action.isEmpty()) {
            listLoanItemsByReader(request, response);
            return;
        }

        switch (action) {
            case "listByReader":
                listLoanItemsByReader(request, response);
                break;
            default:
                response.sendRedirect("staff/BorrowList.jsp");
                break;
        }
    }


    /**
     * Lấy danh sách LoanItem mà Reader chưa trả
     */
    private void listLoanItemsByReader(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) request.getAttribute("reader");


        if (reader == null) {
            reader = (Reader) session.getAttribute("reader");
        }

        if (reader == null) {
            response.sendRedirect("staff/FindReader.jsp");
            return;
        }

        session.setAttribute("reader", reader);

        String readerId = reader.getReaderId();

        List<LoanItem> loanItems = loanItemDAO.getLoanItemsByReader(readerId);
        session.setAttribute("currentLoanItems", loanItems);
        request.getRequestDispatcher("staff/BorrowList.jsp").forward(request, response);
    }
}
