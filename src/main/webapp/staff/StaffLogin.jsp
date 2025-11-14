<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String err = (String) request.getAttribute("err");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login</title>
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
            padding-top: 85px; /* 65px header + 20px */
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

        .input-group { text-align: left; margin-bottom: 18px; }
        .input-group label { display: block; margin-bottom: 6px; color: #444; font-weight: 500; }
        .input-group input {
            width: 100%; padding: 10px 12px; border: 1px solid #c6c6c6;
            border-radius: 6px; font-size: 15px;
        }

        .btn-login {
            width: 100%; padding: 12px 0; border: none; background-color: #0099cc;
            color: white; border-radius: 6px; font-size: 16px; font-weight: 500;
            cursor: pointer; margin-top: 10px; transition: 0.2s;
        }
        .btn-login:hover { background-color: #0077aa; }

        .error { color: #e74c3c; margin-top: 10px; font-size: 14px; }

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
        <h2>Staff Login</h2>

        <form action="<%=request.getContextPath()%>/staff?action=login" method="post">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" required />
            </div>
            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" required />
            </div>
            <button type="submit" class="btn-login">Login</button>
            <div class="error"><%= err != null ? err : "" %></div>
        </form>
    </div>
</div>

<!-- SWITCH TABS -->
<div class="switch-tabs">
    <a href="<%=request.getContextPath()%>/reader/ReaderHome.jsp" class="switch-btn">Reader</a>
    <a href="<%=request.getContextPath()%>/staff/StaffLogin.jsp" class="switch-btn active-tab">Staff</a>
</div>

</body>
</html>