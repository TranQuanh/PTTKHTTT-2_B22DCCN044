<%@ page import="com.example.librarysystem.model.Reader" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Confirm Registration</title>
  <style>
    .container {
      width: 400px;
      margin: 20px auto;
      border: 1px solid #000;
      padding: 20px;
      font-family: Arial;
    }
    .title {
      text-align: center;
      font-weight: bold;
      margin-bottom: 20px;
    }
    .info-line {
      margin: 8px 0;
    }
    .btn-row {
      display: flex;
      justify-content: space-between;
      margin-top: 30px;
    }
    .btn-back {
      background-color: #f4c542;
      padding: 6px 12px;
      border: 1px solid #000;
      cursor: pointer;
    }
    .btn-confirm {
      background-color: #00aaff;
      padding: 6px 12px;
      border: 1px solid #000;
      cursor: pointer;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="title">register reader card information</div>

  <%
    Reader infoReader =
            (Reader) session.getAttribute("infoReader");
  %>

  <div class="info-line">name : <b><%= infoReader.getFullName() %></b></div>
  <div class="info-line">date of birth : <b><%= infoReader.getDate() %></b></div>
  <div class="info-line">address : <b><%= infoReader.getAddress() %></b></div>
  <div class="info-line">email : <b><%= infoReader.getEmail() %></b></div>
  <div class="info-line">phonenumber : <b><%= infoReader.getPhoneNumber() %></b></div>
  <div class="info-line">username : <b><%= infoReader.getUsername() %></b></div>
  <div class="info-line">password : <b><%= infoReader.getPassword() %></b></div>

  <div class="btn-row">
    <button type="button" class="btn-back" onclick="window.location.href='${pageContext.request.contextPath}/reader/RegisterCardForm.jsp'">Back</button>


    <form action="${pageContext.request.contextPath}/reader" method="post">
      <input type="hidden" name="action" value="create_reader">
      <button type="submit" class="btn-confirm">Confirm</button>
    </form>
  </div>
</div>
</body>
</html>
