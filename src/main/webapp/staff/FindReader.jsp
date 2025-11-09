<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Identify Reader</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f8fa;
            margin: 0;
            padding: 0;
        }
        .container {
            background-color: white;
            padding: 25px 35px;
            border: 1px solid #ccc;
            border-radius: 10px;
            max-width: 800px;
            margin: 50px auto;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .search-container {
            text-align: center;
            margin-bottom: 20px;
        }
        input[type="text"] {
            padding: 8px;
            width: 250px;
            font-size: 14px;
            margin-right: 10px;
        }
        button {
            padding: 8px 20px;
            background-color: #0099cc;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        button:hover {
            background-color: #0077aa;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 25px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .click-btn {
            color: #007bff;
            cursor: pointer;
            text-decoration: underline;
        }
        .footer-buttons {
            margin-top: 30px;
            display: flex;
            justify-content: flex-start;
        }
        .back-btn {
            background-color: #999;
        }
        .back-btn:hover {
            background-color: #777;
        }
    </style>
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container">
    <h2>Identify Reader</h2>

    <div class="search-container">
        <form action="${pageContext.request.contextPath}/reader" method="get">
            <input type="hidden" name="action" value="search">
            <label for="readerId">reader ID :</label>
            <input type="text" id="readerId" name="readerId"
                   value="${reader.readerId != null ? reader.readerId : ''}" required>
            <button type="submit">Search</button>
        </form>
    </div>

    <c:if test="${not empty reader}">
        <table>
            <thead>
            <tr>
                <th>Reader ID</th>
                <th>Reader Name</th>
                <th>Status</th>
                <th>Choose</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>${reader.readerId}</td>
                <td>${reader.fullName}</td>
                <td>${reader.status}</td>
                <td><span class="click-btn">Click</span></td>
            </tr>
            </tbody>
        </table>
    </c:if>

    <c:if test="${not empty error}">
        <p style="text-align:center; color:red;">${error}</p>
    </c:if>

    <!-- Nút quay lại -->
    <div class="footer-buttons">
        <button class="back-btn" onclick="goBack()">← Back</button>
    </div>
</div>

<script>
    // Khi ấn Click
    const clickBtn = document.querySelector('.click-btn');
    if (clickBtn) {
        clickBtn.addEventListener('click', function() {
            window.location.href = '${pageContext.request.contextPath}/reader?action=choose';
        });
    }

    // Khi ấn nút quay lại
    function goBack() {
        window.history.back();
    }
</script>

</body>
</html>
