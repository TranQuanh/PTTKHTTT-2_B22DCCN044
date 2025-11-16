<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String readerId = (String) request.getAttribute("readerId");
    String fullName = (String) request.getAttribute("fullName");
    String username = (String) request.getAttribute("username");
    String password = (String) request.getAttribute("password");
    String qrCode = (String) request.getAttribute("qrCode");

    if (readerId == null) {
        response.sendRedirect("RegisterCardForm.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Success</title>
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
            text-align: center;
        }

        .container h2 {
            margin: 0 0 22px;
            color: #005b96;
            font-size: 23px;
            font-weight: 600;
        }

        .success-icon {
            font-size: 48px;
            color: #28a745;
            margin-bottom: 16px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin: 20px 0;
            background: #f8f9fa;
            padding: 18px;
            border-radius: 10px;
            text-align: left;
            font-size: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            color: #555;
            font-weight: 500;
            font-size: 13.5px;
            margin-bottom: 4px;
        }

        .info-value {
            color: #222;
            font-weight: 600;
            font-size: 16px;
            word-break: break-all;
        }

        .highlight {
            color: #d63384;
            font-weight: 700;
        }

        .btn {
            display: inline-block;
            margin-top: 24px;
            padding: 12px 32px;
            background-color: #0099cc;
            color: white;
            text-decoration: none;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15.5px;
            transition: 0.2s;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #0077aa;
        }

        /* ĐẢM BẢO KHÔNG SCROLL TRÊN MÀN HÌNH NHỎ */
        @media (max-height: 800px) {
            .container {
                padding: 22px 30px;
                margin-top: 4px;
            }
            .info-grid {
                padding: 14px;
                gap: 10px;
            }
            .btn {
                padding: 10px 28px;
                font-size: 15px;
            }
            .success-icon {
                font-size: 42px;
            }
            h2 {
                font-size: 22px;
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

        <h2>Register Reader Card Successfully</h2>

        <div class="info-grid">
            <div class="info-item">
                <div class="info-label">Reader ID</div>
                <div class="info-value highlight"><%= readerId %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Full Name</div>
                <div class="info-value"><%= fullName %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Username</div>
                <div class="info-value"><%= username %></div>
            </div>
            <div class="info-item">
                <div class="info-label">Password</div>
                <div class="info-value"><%= password %></div>
            </div>
            <div class="info-item">
                <div class="info-label">QR Code</div>
                <div class="info-value highlight"><%= qrCode %></div>
            </div>
        </div>

        <p style="margin-top: 16px; color: #666; font-size: 14px;">
            Please save your <strong>username</strong> and <strong>password</strong> for login.
        </p>

        <!-- NÚT BACK TO MENU -->
        <form action="<%= request.getContextPath() %>/reader/ReaderHome.jsp" method="get" style="display: inline;">
            <button type="submit" class="btn">Back to Main</button>
        </form>
    </div>
</div>

</body>
</html>