<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Document - Identify Reader</title>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #edf4fa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* === BANNER NHỎ GỌN – CHỈ CHỮ, BO TRÒN === */
        .page-banner {
            background: #0099cc;
            color: white;
            padding: 10px 24px;
            text-align: center;
            border-radius: 30px;
            display: inline-block;
            font-weight: 600;
            font-size: 16px;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(0, 153, 204, 0.25);
            margin: 16px auto 8px;
            max-width: fit-content;
        }

        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 0 16px;
        }

        .container {
            background: #ffffff;
            width: 720px;
            max-width: 92vw;
            padding: 32px 40px;
            border-radius: 14px;
            box-shadow: 0 10px 28px rgba(0,0,0,0.12);
            margin-bottom: 24px;
        }

        .container h2 {
            margin: 0 0 24px;
            color: #005b96;
            font-size: 23px;
            font-weight: 600;
            text-align: center;
        }

        /* === TÌM KIẾM === */
        .search-box {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 14px;
            margin-bottom: 28px;
            flex-wrap: wrap;
        }

        .search-box label {
            font-weight: 500;
            color: #444;
            font-size: 15px;
            white-space: nowrap;
        }

        .search-box input {
            padding: 11px 14px;
            width: 280px;
            max-width: 100%;
            border: 1.5px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            outline: none;
            transition: all 0.2s;
        }

        .search-box input:focus {
            border-color: #0099cc;
            box-shadow: 0 0 0 3px rgba(0,153,204,0.15);
        }

        .search-btn {
            padding: 11px 26px;
            background-color: #0099cc;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .search-btn:hover {
            background-color: #0077aa;
        }

        /* === KẾT QUẢ READER === */
        .reader-result {
            background: #f8f9fa;
            padding: 22px 26px;
            border-radius: 12px;
            border-left: 5px solid #0099cc;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 18px;
            font-size: 15px;
        }

        .info-group {
            display: flex;
            flex-direction: column;
            min-width: 130px;
            flex: 1;
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
        }

        .highlight {
            color: #d63384;
            font-weight: 700;
        }

        .status-active { color: #28a745; font-weight: 600; }
        .status-inactive { color: #dc3545; font-weight: 600; }


        .choose-btn-inline {
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            min-width: 120px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }

        .choose-btn-inline:hover {
            background-color: #218838;
            transform: translateY(-1px);
        }

        /* === NÚT BACK === */
        .back-section {
            display: flex;
            justify-content: flex-start;
            margin-top: 12px;
        }

        .btn-back {
            padding: 12px 24px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            min-width: 120px;
        }

        .btn-back:hover {
            background-color: #5a6268;
        }

        /* === LỖI === */
        .error-msg {
            text-align: center;
            color: #dc3545;
            font-weight: 500;
            margin: 16px 0;
            font-size: 15px;
        }


        @media (max-width: 720px) {
            .page-banner {
                padding: 8px 18px;
                font-size: 15px;
                border-radius: 24px;
            }
            .reader-result {
                flex-direction: column;
                align-items: flex-start;
                text-align: left;
                gap: 14px;
            }
            .info-group { width: 100%; }
            .choose-btn-inline { width: 100%; }
            .container { padding: 24px 28px; }
        }

        @media (max-height: 800px) {
            .page-banner { margin: 12px auto 6px; }
            .container { padding: 20px 28px; }
        }
    </style>
</head>
<body>

<!-- HEADER STAFF -->
<jsp:include page="/common/header-staff-login.jsp" />

<!-- BANNER -->
<div style="text-align: center;">
    <div class="page-banner">
        Return Document Reader
    </div>
</div>

<!-- NỘI DUNG CHÍNH -->
<div class="main-content">
    <div class="container">
        <h2>Identify Reader</h2>

        <!-- TÌM KIẾM -->
        <div class="search-box">
            <form action="${pageContext.request.contextPath}/reader" method="get">
                <input type="hidden" name="action" value="search">
                <label for="readerId">Reader ID:</label>
                <input type="text" id="readerId" name="inReaderId"
                       value="${not empty reader.readerId ? reader.readerId : ''}"
                       placeholder="Nhập mã thẻ đọc" required>
                <button type="submit" class="search-btn">Tìm kiếm</button>
            </form>
        </div>

        <!-- KẾT QUẢ -->
        <c:if test="${not empty reader}">
            <div class="reader-result">
                <div class="info-group">
                    <div class="info-label">Reader ID</div>
                    <div class="info-value highlight">${reader.readerId}</div>
                </div>
                <div class="info-group">
                    <div class="info-label">Name</div>
                    <div class="info-value">${reader.fullName}</div>
                </div>
                <div class="info-group">
                    <div class="info-label">Status</div>
                    <div class="info-value
                            <c:choose>
                                <c:when test="${reader.status == 'active'}">status-active</c:when>
                                <c:otherwise>status-inactive</c:otherwise>
                            </c:choose>">
                            ${reader.status}
                    </div>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/loanItem?action=listByReader"
                       class="choose-btn-inline">
                        Choose
                    </a>
                </div>
            </div>


        </c:if>
        <div class="back-section">
            <button type="button" class="btn-back" onclick="window.location.href='${pageContext.request.contextPath}/staff/StaffHome.jsp'">
                Back
            </button>
        </div>
        <!-- LỖI -->
        <c:if test="${not empty error}">
            <p class="error-msg">${error}</p>
        </c:if>
    </div>
</div>

</body>
</html>