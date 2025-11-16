<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn Phạt Hư Hỏng</title>
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

        /* === BANNER NHỎ GỌN === */
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
            width: 920px;
            max-width: 94vw;
            padding: 16px 20px;
            border-radius: 14px;
            box-shadow: 0 10px 28px rgba(0,0,0,0.12);
            margin-bottom: 24px;
        }

        .container h3 {
            margin: 0 0 12px;
            color: #005b96;
            font-size: 22px;
            font-weight: 600;
            text-align: center;
        }

        /* === READER + LOAN INFO – GIỐNG ReturnBasket === */
        .info-card {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 16px;
            font-size: 14.5px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .info-row {
            display: flex;
            align-items: center;
            flex-wrap: nowrap;
        }

        .info-row .label {
            font-weight: 600;
            color: #333;
            min-width: 70px;
            margin-right: 12px;
        }

        .info-row .value {
            color: #555;
            min-width: 70px;
            margin-right: 36px;
        }


        /* === BẢNG PHẠT HƯ HỎNG === */
        .fine-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
            margin-top: 12px;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            overflow: hidden;
        }

        .fine-table th {
            background-color: #f8f9fa;
            color: #333;
            font-weight: 600;
            padding: 12px 10px;
            text-align: center;
            border-bottom: 2px solid #dee2e6;
        }

        .fine-table td {
            padding: 10px 12px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .fine-table tr:hover {
            background-color: #f8f9fa;
        }

        .fine-table tr:last-child td {
            border-bottom: none;
        }

        /* === NÚT CHỌN === */
        .choose-btn {
            padding: 6px 14px;
            border: none;
            border-radius: 6px;
            font-size: 13.5px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            min-width: 78px;
        }

        .choose-btn:not(.selected) {
            background-color: #0099cc;
            color: white;
        }

        .choose-btn.selected {
            background-color: #dc3545;
            color: white;
        }

        .choose-btn:hover {
            opacity: 0.92;
            transform: translateY(-1px);
        }

        /* === NÚT HÀNH ĐỘNG === */
        .button-group {
            margin-top: 20px;
            text-align: right;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14.5px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .agree-btn {
            background-color: #28a745;
            color: white;
        }

        .back-btn {
            background-color: #6c757d;
            color: white;
        }

        .agree-btn:hover { background-color: #218838; }
        .back-btn:hover { background-color: #5a6268; }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .info-row { flex-direction: column; align-items: flex-start; gap: 4px; }
            .info-row .label { min-width: auto; }

            .container { padding: 12px 14px; }
            .fine-table th, .fine-table td { padding: 8px 6px; font-size: 13px; }
            .button-group { flex-direction: column; }
            .btn { width: 100%; }
        }
    </style>
</head>
<body>

<!-- HEADER STAFF -->
<jsp:include page="/common/header-staff-login.jsp" />

<!-- BANNER NHỎ -->
<div style="text-align: center;">
    <div class="page-banner">
        Reader Return Documents
    </div>
</div>

<!-- NỘI DUNG CHÍNH -->
<div class="main-content">
    <div class="container">
        <h3>Choose Damage Fine</h3>

        <!-- READER + LOAN INFO – GIỐNG ReturnBasket -->
        <div class="info-card">
            <div class="info-row">
                <span class="label">Reader ID:</span>
                <span class="value">${reader.readerId}</span>
                <span class="label">Full Name:</span>
                <span class="value">${reader.fullName}</span>
            </div>
            <div class="info-row">
                <span class="label">Loan ID:</span>
                <span class="value">${targetLoanItemId}</span>
                <span class="separator"></span>
                <span class="label">Book title:</span>
                <span class="value">${bookTitle}</span>
            </div>
        </div>

        <!-- BẢNG PHẠT HƯ HỎNG -->
        <table class="fine-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>reason</th>
                <th>amount</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="fine" items="${damageFines}">
                <c:set var="isSelected" value="${selectedFineIds.contains(fine.id)}"/>
                <tr>
                    <td>${fine.id}</td>
                    <td>${fine.reason}</td>
                    <td><fmt:formatNumber value="${fine.amount}" type="number" maxFractionDigits="0"/> VND</td>
                    <td>
                        <button class="choose-btn ${isSelected ? 'selected' : ''}"
                                onclick="toggleFine('${fine.id}', '${targetLoanItemId}', this)">
                                ${isSelected ? 'Bỏ chọn' : 'Chọn'}
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <!-- NÚT HÀNH ĐỘNG -->
        <div class="button-group">

            <button class="btn agree-btn" onclick="saveAndNext()">Continue</button>
        </div>
    </div>
</div>

<script>
    function toggleFine(fineId, loanItemId, button) {
        const url = '${pageContext.request.contextPath}/fine?action=chooseDamageFine&fineId=' + fineId + '&loanItemId=' + loanItemId;

        fetch(url, { method: 'POST' })
            .then(res => res.json())
            .then(data => {
                if (data.status === 'ok') {
                    button.classList.toggle('selected');
                    button.textContent = button.classList.contains('selected') ? 'Bỏ chọn' : 'Chọn';
                } else {
                    alert('Lỗi: ' + (data.message || 'Không thể cập nhật'));
                }
            })
            .catch(err => {
                console.error('Lỗi kết nối:', err);
                alert('Lỗi kết nối mạng. Vui lòng thử lại.');
            });
    }

    function saveAndNext() {
        window.location.href = '${pageContext.request.contextPath}/staff/ReturnBasket.jsp';
    }
</script>

</body>
</html>