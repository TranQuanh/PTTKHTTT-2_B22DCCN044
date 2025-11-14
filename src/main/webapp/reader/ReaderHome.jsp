<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reader Home</title>
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
      padding-top: 85px;
      display: flex;
      justify-content: center;
      align-items: flex-start;
    }

    .container {
      background: #ffffff;
      width: 380px;
      padding: 35px 40px;
      border-radius: 14px;
      text-align: center;
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
      margin-top: 40px;
    }

    .container h2 { margin: 0 0 25px; color: #005b96; font-size: 24px; font-weight: 600; }

    .btn {
      width: 100%; padding: 12px 0; margin-top: 12px; border: none;
      background-color: #0099cc; color: white; font-weight: 500;
      font-size: 16px; border-radius: 6px; cursor: pointer;
      transition: 0.2s;
    }
    .btn:hover { background-color: #0077aa; }

    .switch-tabs {
      padding: 20px 0; display: flex; justify-content: center; gap: 12px;
      background-color: #edf4fa;
    }
    .switch-btn {
      padding: 9px 20px; border-radius: 8px; text-decoration: none;
      background-color: #6bbcd6; color: white; font-weight: 500;
      font-size: 14px; transition: 0.2s;
    }
    .switch-btn:hover { background-color: #5cb1cc; }
    .active-tab { background-color: #0099cc; box-shadow: 0 0 6px rgba(0,0,0,0.2); font-weight: 600; }
  </style>
</head>
<body>

<!-- IMPORT HEADER TỪ FILE CHUNG -->
<jsp:include page="/common/header.jsp" />

<!-- NỘI DUNG CHÍNH -->
<div class="main-content">
  <div class="container">
    <h2>Reader Home</h2>

    <form action="reader/RegisterCardForm.jsp">
      <button class="btn" type="submit">Register reader card</button>
    </form>

    <form action="login.jsp">
      <button class="btn" type="submit">Login</button>
    </form>
  </div>
</div>

<!-- SWITCH TABS -->
<div class="switch-tabs">
  <a href="<%=request.getContextPath()%>/reader/ReaderHome.jsp" class="switch-btn active-tab">Reader</a>
  <a href="<%=request.getContextPath()%>/staff/StaffLogin.jsp" class="switch-btn">Staff</a>
</div>

</body>
</html>