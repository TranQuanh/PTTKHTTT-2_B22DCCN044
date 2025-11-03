<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>Reader Home</title>
  <style>
    body {
      font-family: Arial, sans-serif;
    }
    .container {
      width: 400px;
      margin: 100px auto;
      text-align: center;
      border: 1px solid #ccc;
      padding: 30px;
      border-radius: 8px;
    }
    .btn {
      display: block;
      margin: 15px auto;
      padding: 10px 20px;
      text-decoration: none;
      border: none;
      background-color: #1e90ff;
      color: white;
      border-radius: 4px;
      cursor: pointer;
    }
    .btn:hover {
      opacity: 0.8;
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Reader Home Page</h2>

  <form action="reader/RegisterCardForm.jsp" method="get">
    <button class="btn" type="submit">Register reader card</button>
  </form>

  <form action="login.jsp" method="get">
    <button class="btn" type="submit">Login</button>
  </form>
</div>
</body>
</html>
