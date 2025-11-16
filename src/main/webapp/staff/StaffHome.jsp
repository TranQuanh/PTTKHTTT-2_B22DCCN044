<%@ page import="com.example.librarysystem.model.Member" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  request.setAttribute("pageTitle", "Staff Home");
  Member staff = (Member) session.getAttribute("staff");
  String staffName = (staff != null && staff.getFullName() != null)
          ? staff.getFullName()
          : "Staff";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Staff Home</title>
  <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', Arial, sans-serif;
      background-color: #edf4fa;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    .main-content {
      flex: 1;
      padding-top: 60px;
      display: flex;
      justify-content: center;
      align-items: flex-start;
    }

    .container {
      background: #ffffff;
      width: 420px;
      max-width: 92vw;
      padding: 36px 44px;
      border-radius: 14px;
      box-shadow: 0 10px 28px rgba(0, 0, 0, 0.12);
      text-align: center;
      margin-top: 20px;
    }

    .container h2 {
      margin: 0 0 28px;
      color: #005b96;
      font-size: 23px;
      font-weight: 600;
    }

    .btn {
      display: block;
      width: 100%;
      padding: 14px;
      margin: 10px 0;
      border: none;
      border-radius: 8px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      text-decoration: none;
      color: white;
    }

    .btn-blue {
      background-color: #0099cc;
    }

    .btn-blue:hover {
      background-color: #0077aa;
      transform: translateY(-1px);
      box-shadow: 0 4px 8px rgba(0, 153, 204, 0.3);
    }

    .btn:active {
      transform: translateY(0);
    }

    /* Responsive nhỏ */
    @media (max-height: 800px) {
      .container {
        padding: 28px 36px;
        margin-top: 10px;
      }
      .btn {
        padding: 12px;
        font-size: 15px;
      }
    }

    @media (max-width: 480px) {
      .container {
        width: 92vw;
        padding: 24px 28px;
      }
    }
  </style>
</head>
<body>

<!-- DÙNG HEADER MỚI CÓ STAFF + LOGOUT -->
<jsp:include page="/common/header-staff-login.jsp" />

<!-- NỘI DUNG CHÍNH -->
<div class="main-content">
  <div class="container">
    <h2>Staff Home Page</h2>
    <a href="<%= request.getContextPath() %>/staff/FindReader.jsp" class="btn btn-blue">
      Return Documents
    </a>
  </div>
</div>

</body>
</html>