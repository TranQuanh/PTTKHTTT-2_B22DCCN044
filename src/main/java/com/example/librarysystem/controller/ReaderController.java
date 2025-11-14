package com.example.librarysystem.controller;
import com.example.librarysystem.dao.ReaderDAO;
import com.example.librarysystem.model.Reader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;
import java.io.IOException;

@WebServlet("/reader")
public class ReaderController extends HttpServlet {
    private ReaderDAO readerDAO;
    public void init() throws ServletException {
        // Lấy connection từ ServletContext (được tạo ở Listener/Init)
        Connection connection = (Connection) getServletContext().getAttribute("DBConnection");
        readerDAO = new ReaderDAO(connection);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "search":
                doFindReader(request, response);
                break;
            case "choose":
                doChooseReader(request, response);
                break;
            default:
                response.sendRedirect("staff/FindReader.jsp");
        }
    }

    private void doFindReader(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String readerId = request.getParameter("readerId");
        Reader reader = readerDAO.findReaderById(readerId);

        if (reader != null) {
            HttpSession session = request.getSession();
            session.setAttribute("reader", reader);
        } else {
            request.setAttribute("error", "Reader not found");
        }

        request.getRequestDispatcher("staff/FindReader.jsp").forward(request, response);
    }
    private void doChooseReader(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Lấy reader đã tìm được từ attribute request (hoặc session cũ)
        Object reader = request.getAttribute("reader");
        if (reader == null) {
            reader = session.getAttribute("reader");
        }

        if (reader != null) {
            session.setAttribute("reader", reader); // lưu vào session

            // ✅ Gọi servlet LoanItemController để hiển thị danh sách Borrow List
            response.sendRedirect(request.getContextPath() + "/loanItem?action=listByReader");
        } else {
            response.sendRedirect("staff/FindReader.jsp");
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("validate".equals(action)) {
            doValidate(request, response);
        }else if("create_reader".equals(action)){
            doCreateReader(request,response);
        }
        // sau này thêm action khác như "create", "login" ...
    }



    private void doValidate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String fullName     = request.getParameter("fullName");
        String username     = request.getParameter("username");
        String password     = request.getParameter("password");
        String email        = request.getParameter("email");
        String address      = request.getParameter("address");
        String phoneNumber  = request.getParameter("phoneNumber");
        String dobStr       = request.getParameter("dob");

        Reader reader = new Reader();
        reader.setFullName(fullName);
        reader.setUsername(username);
        reader.setPassword(password);
        reader.setEmail(email);
        reader.setAddress(address);
        reader.setPhoneNumber(phoneNumber);

        // parse dob (LocalDate)
        if (dobStr != null && !dobStr.isEmpty()) {
            reader.setDateOfBirth(LocalDate.parse(dobStr));
        }

        // Kiểm tra validate
        Map<String, String> errors = readerDAO.checkValidate(reader);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("infoReader", reader);
            request.getRequestDispatcher("/reader/RegisterCardForm.jsp")
                    .forward(request, response);
            return;
        }

        // không lỗi => confirm
        HttpSession session = request.getSession();
        session.setAttribute("infoReader", reader);

        request.getRequestDispatcher("/reader/ConfirmRegistration.jsp")
                .forward(request, response);
    }


    private void doCreateReader(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader reader = (Reader) session.getAttribute("infoReader");

        if (reader == null) {

            response.sendRedirect(request.getContextPath() + "/reader/RegisterCardForm.jsp");
            return;
        }

        // Gọi DAO để insert
        boolean success = readerDAO.createReader(reader);

        if (success) {
            session.removeAttribute("infoReader");
            // chuyển đến trang kết quả
            request.setAttribute("fullName", reader.getFullName());
            request.setAttribute("phone", reader.getPhoneNumber());
            request.getRequestDispatcher("/reader/ResultRegistration.jsp")
                    .forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Đăng ký thất bại (Lỗi hệ thống)!");
            request.setAttribute("infoReader", reader);
            request.getRequestDispatcher("/reader/ConfirmRegistration.jsp")
                    .forward(request, response);
        }
    }
}
