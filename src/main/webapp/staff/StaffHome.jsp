<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  request.setAttribute("pageTitle", "Staff Home");
  com.example.librarysystem.model.Member staff =
          (com.example.librarysystem.model.Member) session.getAttribute("staff");
  String staffName = (staff != null && staff.getFullName() != null)
          ? staff.getFullName()
          : "Staff";
%>
<!DOCTYPE html>
<html>
<head>
  <title>Staff Home</title>
  <style>
    .container {
      background-color: #fff;
      border: 2px solid #000;
      border-radius: 10px;
      padding: 40px 50px;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
      text-align: center;
      width: 320px;
      margin: 120px auto;
    }

    h2 {
      margin-bottom: 25px;
      font-size: 20px;
      font-weight: 600;
      color: #111;
    }

    .btn {
      display: block;
      width: 100%;
      padding: 12px;
      margin: 8px 0;
      border: none;
      border-radius: 6px;
      font-size: 15px;
      font-weight: 500;
      cursor: pointer;
      transition: background-color 0.25s, transform 0.1s;
      color: #fff;
    }

    .btn-blue {
      background-color: #0097db;
    }

    .btn-blue:hover {
      background-color: #007bb8;
    }

    .btn-red {
      background-color: #dc3545;
    }

    .btn-red:hover {
      background-color: #b52d39;
    }

    .btn:active {
      transform: scale(0.97);
    }

    .welcome {
      margin-top: 15px;
      font-size: 15px;
      font-weight: 500;
      color: #333;
    }
  </style>
</head>
<body>
<jsp:include page="/common/header.jsp" />

<div class="container">
  <h2>Staff home page</h2>

  <a href="<%=request.getContextPath()%>/staff/FindReader.jsp" class="btn btn-blue">
    Receive & return documents
  </a>

  <a href="<%=request.getContextPath()%>/staff?action=logout" class="btn btn-red">
    Logout
  </a>

  <div class="welcome">Welcome, <%= staffName %>!</div>
</div>

</body>
</html>
