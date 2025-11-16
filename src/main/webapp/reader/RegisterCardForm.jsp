<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.librarysystem.model.Reader" %>
<%@ page import="java.util.Map" %>
<%
  Reader infoReader = (Reader) request.getAttribute("infoReader");
  Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register Reader Card</title>
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
      padding: 22px 32px;
      border-radius: 14px;
      box-shadow: 0 10px 28px rgba(0,0,0,0.12);
      margin-top: 8px;
    }

    .container h2 {
      margin: 0 0 18px;
      color: #005b96;
      font-size: 23px;
      font-weight: 600;
      text-align: center;
    }

    /* HÀNG 2 CỘT */
    .row {
      display: flex;
      gap: 16px;
      margin-bottom: 10px;
    }

    .col {
      flex: 1;
    }

    .form-group {
      margin-bottom: 0; /* Đã có margin ở .row */
      text-align: left;
    }

    .form-group label {
      display: block;
      margin-bottom: 4px;
      color: #333;
      font-weight: 500;
      font-size: 14px;
    }

    .form-group input {
      width: 100%;
      padding: 10px 12px;
      border: 1.4px solid #c6c6c6;
      border-radius: 7px;
      font-size: 15px;
      transition: all 0.2s;
    }

    .form-group input:focus {
      outline: none;
      border-color: #0099cc;
      box-shadow: 0 0 0 3px rgba(0, 153, 204, 0.18);
    }

    .error-msg {
      color: #e74c3c;
      font-size: 12.5px;
      margin-top: 3px;
      min-height: 16px;
    }

    .buttons {
      display: flex;
      justify-content: space-between;
      margin-top: 18px;
      gap: 12px;
    }

    .btn {
      flex: 1;
      padding: 11px 0;
      border: none;
      border-radius: 7px;
      font-size: 15px;
      font-weight: 500;
      cursor: pointer;
      transition: 0.2s;
    }

    .submit-btn {
      background-color: #0099cc;
      color: white;
    }

    .submit-btn:hover {
      background-color: #0077aa;
    }

    .back-btn {
      background-color: #6c757d;
      color: white;
    }

    .back-btn:hover {
      background-color: #5a6268;
    }

    /* ĐẢM BẢO KHÔNG SCROLL */
    @media (max-height: 800px) {
      .container {
        padding: 18px 28px;
      }
      .row {
        margin-bottom: 8px;
      }
    }
  </style>
</head>
<body>

<!-- HEADER CHUNG -->
<jsp:include page="/common/header.jsp" />

<!-- NỘI DUNG CHÍNH -->
<div class="main-content">
  <div class="container">
    <h2>Register Reader Card</h2>

    <form action="<%=request.getContextPath()%>/reader?action=validate" method="post">

      <!-- HÀNG 1: Name + DOB -->
      <div class="row">
        <div class="col">
          <div class="form-group">
            <label>Name</label>
            <input type="text" name="inFullName"
                   value="<%= infoReader != null ? infoReader.getFullName() : "" %>">
            <div class="error-msg"><%= errors != null ? errors.getOrDefault("fullName", "") : "" %></div>
          </div>
        </div>
        <div class="col">
          <div class="form-group">
            <label>Date of Birth</label>
            <input type="date" name="inDOB"
                   value="<%= infoReader != null ? infoReader.getDateOfBirth() : "" %>">
            <div class="error-msg"><%= errors != null ? errors.getOrDefault("dob", "") : "" %></div>
          </div>
        </div>
      </div>

      <!-- HÀNG 2: Address -->
      <div class="form-group">
        <label>Address</label>
        <input type="text" name="inAdress"
               value="<%= infoReader != null ? infoReader.getAddress() : "" %>">
        <div class="error-msg"><%= errors != null ? errors.getOrDefault("address", "") : "" %></div>
      </div>

      <!-- HÀNG 3: Email + Phone -->
      <div class="row">
        <div class="col">
          <div class="form-group">
            <label>Email</label>
            <input type="email" name="inEmail"
                   value="<%= infoReader != null ? infoReader.getEmail() : "" %>">
            <div class="error-msg"><%= errors != null ? errors.getOrDefault("email", "") : "" %></div>
          </div>
        </div>
        <div class="col">
          <div class="form-group">
            <label>Phone Number</label>
            <input type="text" name="inPhoneNumber"
                   value="<%= infoReader != null ? infoReader.getPhoneNumber() : "" %>">
            <div class="error-msg"><%= errors != null ? errors.getOrDefault("phoneNumber", "") : "" %></div>
          </div>
        </div>
      </div>

      <!-- HÀNG 4: Username -->
      <div class="form-group">
        <label>Username</label>
        <input type="text" name="inUsername"
               value="<%= infoReader != null ? infoReader.getUsername() : "" %>">
        <div class="error-msg"><%= errors != null ? errors.getOrDefault("username", "") : "" %></div>
      </div>

      <!-- HÀNG 5: Password -->
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="inPassword"
               value="<%= infoReader != null ? infoReader.getPassword() : "" %>">
        <div class="error-msg"><%= errors != null ? errors.getOrDefault("password", "") : "" %></div>
      </div>

      <!-- NÚT -->
      <div class="buttons">
        <button type="button" class="btn back-btn" onclick="history.back()">Back</button>
        <button type="submit" class="btn submit-btn">Continue</button>
      </div>
    </form>
  </div>
</div>

</body>
</html>