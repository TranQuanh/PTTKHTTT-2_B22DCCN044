<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    request.setAttribute("pageTitle", "Staff Login");
    String err = (String) request.getAttribute("err");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Login</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #edf4fa;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        /* Container giữ nội dung chính */
        .container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            padding: 40px 0;
        }

        /* Hộp login */
        .login-box {
            background: #ffffff;
            width: 380px;
            padding: 35px 40px;
            border-radius: 14px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            animation: fadeInUp 0.6s ease;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(25px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-box h2 {
            margin: 0 0 25px 0;
            color: #005b96;
            font-size: 24px;
            font-weight: 600;
        }

        .input-group {
            text-align: left;
            margin-bottom: 18px;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 6px;
            color: #333;
        }

        .input-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #c6c6c6;
            border-radius: 6px;
            font-size: 15px;
            box-sizing: border-box;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .input-group input:focus {
            outline: none;
            border-color: #0077cc;
            box-shadow: 0 0 5px rgba(0,123,255,0.4);
        }

        .btn-login {
            width: 100%;
            padding: 12px 0;
            margin-top: 10px;
            border: none;
            color: #fff;
            background-color: #0099cc;
            cursor: pointer;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.2s, transform 0.1s;
        }

        .btn-login:hover {
            background-color: #0077aa;
        }

        .btn-login:active {
            transform: scale(0.98);
        }

        .error {
            color: red;
            margin-top: 12px;
            font-size: 14px;
            min-height: 18px;
        }
    </style>
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container">
    <div class="login-box">
        <h2>Staff Login</h2>
        <form action="<%=request.getContextPath()%>/staff?action=login" method="post">
            <div class="input-group">
                <label>Username</label>
                <input type="text" name="username" required/>
            </div>

            <div class="input-group">
                <label>Password</label>
                <input type="password" name="password" required/>
            </div>

            <button type="submit" class="btn-login">Login</button>
            <div class="error"><%= err != null ? err : "" %></div>
        </form>
    </div>
</div>

</body>
</html>
