<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.librarysystem.model.Reader" %>
<%@ page import="java.util.Map" %>
<%
  Reader infoReader = (Reader) request.getAttribute("infoReader");
  Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
%>
<!DOCTYPE html>
<html>
<head>
  <title>Register Reader Card</title>
  <style>
    body { font-family: Arial, sans-serif; }
    .container {
      width: 400px;
      margin: 50px auto;
      text-align: left;
      border: 1px solid #000;
      padding: 30px;
      border-radius: 8px;
    }
    .container h2 { text-align: center; }
    .form-input {
      width: 100%;
      height: 28px;
      margin-bottom: 3px;
      padding-left: 5px;
    }
    .error-msg {
      font-size: 12px;
      color: red;
      margin-bottom: 6px;
    }
    .buttons {
      display: flex;
      justify-content: space-between;
      margin-top: 15px;
    }
    .submit-btn, .back-btn {
      width: 120px;
      height: 32px;
      border: none;
      border-radius: 3px;
      cursor: pointer;
    }
    .submit-btn { background-color: #1e90ff; color: white; }
    .back-btn { background-color: #777; color: white; }
    .submit-btn:hover, .back-btn:hover { opacity: 0.8; }
  </style>
</head>
<body>

<div class="container">
  <h2>Register Form</h2>

  <form action="<%=request.getContextPath()%>/reader?action=validate" method="post">

    <label>Name :</label>
    <input type="text" class="form-input" name="fullName"
           value="<%= infoReader != null ? infoReader.getFullName() : "" %>">
    <div class="error-msg"><%= errors != null ? errors.getOrDefault("fullName", "") : "" %></div>

    <label>Date of birth :</label>
    <input type="date" class="form-input" name="dob"
           value="<%= infoReader != null ? infoReader.getDate() : "" %>">
    <div class="error-msg"><%= errors != null ? errors.getOrDefault("dob", "") : "" %></div>

    <label>Address :</label>
    <input type="text" class="form-input" name="address"
           value="<%= infoReader != null ? infoReader.getAddress() : "" %>">
    <div class="error-msg"><%= errors != null ? errors.getOrDefault("address", "") : "" %></div>

    <label>Email :</label>
    <input type="email" class="form-input" name="email"
           value="<%= infoReader != null ? infoReader.getEmail() : "" %>">
    <div class="error-msg"><%= errors != null ? errors.getOrDefault("email", "") : "" %></div>

    <label>Phone number :</label>
    <input type="text" class="form-input" name="phoneNumber"
           value="<%= infoReader != null ? infoReader.getPhoneNumber() : "" %>">
    <div class="error-msg"><%= errors != null ? errors.getOrDefault("phoneNumber", "") : "" %></div>

    <label>Username :</label>
    <input type="text" class="form-input" name="username"
           value="<%= infoReader != null ? infoReader.getUsername() : "" %>">
    <div class="error-msg"><%= errors != null ? errors.getOrDefault("username", "") : "" %></div>

    <label>Password :</label>
    <input type="password" class="form-input" name="password"
           value="<%= infoReader != null ? infoReader.getPassword() : "" %>">
    <div class="error-msg"><%= errors != null ? errors.getOrDefault("password", "") : "" %></div>

    <div class="buttons">
      <button type="button" class="back-btn" onclick="history.back()">Back</button>
      <button type="submit" class="submit-btn">SUBMIT</button>
    </div>
  </form>

</div>

</body>
</html>
