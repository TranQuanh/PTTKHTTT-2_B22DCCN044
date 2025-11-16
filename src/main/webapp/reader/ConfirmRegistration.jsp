<%@ page import="com.example.librarysystem.model.Reader" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Reader infoReader = (Reader) session.getAttribute("infoReader");
  if (infoReader == null) {
    response.sendRedirect(request.getContextPath() + "/reader/RegisterCardForm.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Confirm Registration</title>
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
      width: 560px;
      max-width: 92vw;
      padding: 28px 36px;
      border-radius: 14px;
      box-shadow: 0 10px 28px rgba(0,0,0,0.12);
      margin-top: 8px;
    }
    .container h2 {
      margin: 0 0 22px;
      color: #005b96;
      font-size: 23px;
      font-weight: 600;
      text-align: center;
    }
    .info-row {
      display: flex;
      justify-content: space-between;
      padding: 11px 0;
      border-bottom: 1px solid #e9ecef;
      font-size: 15px;
    }
    .info-row:last-child {
      border-bottom: none;
      padding-bottom: 0;
    }
    .info-label {
      color: #555;
      font-weight: 500;
    }
    .info-value {
      color: #222;
      font-weight: 600;
      text-align: right;
      flex: 1;
      margin-left: 16px;
    }


    .buttons {
      display: flex;
      justify-content: space-between;
      gap: 14px;
      margin-top: 28px;
    }


    .back-btn {
      flex: 1;
      padding: 13px 0;
      background-color: #6c757d;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 15.5px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      text-align: center;
    }
    .back-btn:hover {
      background-color: #5a6268;
    }


    .confirm-form {
      flex: 1;
      margin: 0;
      padding: 0;
      display: flex;
    }


    .confirm-btn {
      width: 100%;
      padding: 13px 0;
      background-color: #0099cc;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 15.5px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s;
      text-align: center;
    }
    .confirm-btn:hover {
      background-color: #0077aa;
    }

    @media (max-height: 800px) {
      .container { padding: 22px 30px; }
      .info-row { padding: 9px 0; }
      .back-btn, .confirm-btn { padding: 11px 0; font-size: 15px; }
    }
  </style>
</head>
<body>

<!-- HEADER CHUNG -->
<jsp:include page="/common/header.jsp" />

<!-- NỘI DUNG CHÍNH -->
<div class="main-content">
  <div class="container">
    <h2>Confirm Registration</h2>

    <div class="info-row">
      <span class="info-label">Name</span>
      <span class="info-value"><%= infoReader.getFullName() %></span>
    </div>
    <div class="info-row">
      <span class="info-label">Date of Birth</span>
      <span class="info-value"><%= infoReader.getDateOfBirth() %></span>
    </div>
    <div class="info-row">
      <span class="info-label">Address</span>
      <span class="info-value"><%= infoReader.getAddress() %></span>
    </div>
    <div class="info-row">
      <span class="info-label">Email</span>
      <span class="info-value"><%= infoReader.getEmail() %></span>
    </div>
    <div class="info-row">
      <span class="info-label">Phone Number</span>
      <span class="info-value"><%= infoReader.getPhoneNumber() %></span>
    </div>
    <div class="info-row">
      <span class="info-label">Username</span>
      <span class="info-value"><%= infoReader.getUsername() %></span>
    </div>
    <div class="info-row">
      <span class="info-label">Password</span>
      <span class="info-value"><%= infoReader.getPassword() %></span>
    </div>

    <!-- NÚT ĐÃ SỬA: TO ĐỀU, KHÔNG BỊ FORM ẢNH HƯỞNG -->
    <div class="buttons">
      <button type="button" class="back-btn"
              onclick="window.location.href='${pageContext.request.contextPath}/reader/RegisterCardForm.jsp'">
        Back
      </button>

      <form action="${pageContext.request.contextPath}/reader" method="post" class="confirm-form">
        <input type="hidden" name="action" value="create_reader">
        <button type="submit" class="confirm-btn">Submit</button>
      </form>
    </div>
  </div>
</div>

</body>
</html>