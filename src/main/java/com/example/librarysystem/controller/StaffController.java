package com.example.librarysystem.controller;
import com.example.librarysystem.dao.StaffDAO;
import com.example.librarysystem.model.Member;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
@WebServlet("/staff")
public class StaffController extends HttpServlet {
    private StaffDAO staffDAO;
    public void init() throws ServletException {

        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
        staffDAO = new StaffDAO(connection);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null || action.equals("login")) {
            request.getRequestDispatcher("/staff/StaffLogin.jsp").forward(request, response);
        } else if (action.equals("logout")) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/staff?action=login");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff?action=login");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("login".equals(action)) {
            doLogin(request, response);
        }
    }
    private void doLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Member staff = staffDAO.login(username, password);

        if (staff != null) {
            HttpSession session = request.getSession();
            session.setAttribute("staff", staff);
            response.sendRedirect(request.getContextPath() + "/staff/StaffHome.jsp");
        } else {
            request.setAttribute("err", "Sai tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("/staff/StaffLogin.jsp").forward(request, response);
        }
    }
}
