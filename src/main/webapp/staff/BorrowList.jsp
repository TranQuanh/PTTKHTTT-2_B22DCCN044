<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    if (session.getAttribute("currentLoanItems") == null || session.getAttribute("reader") == null) {
        response.sendRedirect(request.getContextPath() + "/loanItem");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Document - Borrow List</title>
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
            margin: 18px auto 8px;
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
            width: 980px;
            max-width: 94vw;
            padding: 18px 22px;
            border-radius: 14px;
            box-shadow: 0 10px 28px rgba(0,0,0,0.12);
            margin-bottom: 24px;
        }

        .container h2 {
            margin: 0 0 14px;
            color: #005b96;
            font-size: 23px;
            font-weight: 600;
            text-align: center;
        }

        .tabs {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 8px;
            flex-wrap: wrap;
        }

        .tab {
            padding: 9px 18px;
            text-align: center;
            font-weight: 600;
            font-size: 14.8px;
            background-color: #ffffff;
            color: #495057;
            border: 1.6px solid #dee2e6;
            border-radius: 22px;
            cursor: pointer;
            transition: all 0.2s;
            min-width: 150px;
        }

        .tab.active {
            background-color: #0099cc;
            color: white;
            border-color: #0099cc;
        }

        .tab:hover:not(.active) {
            background-color: #f8f9fa;
            border-color: #ccc;
        }

        /* READER CARD */
        .reader-card {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 8px;
            font-size: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .reader-inline {
            display: flex;
            align-items: center;
            flex-wrap: nowrap;
            gap: 20px;
        }

        .reader-inline .label {
            font-weight: 600;
            color: #333;
            min-width: 80px;
        }

        .reader-inline .value {
            color: #444;
            font-weight: 500;
        }

        /* BẢNG CUỘN */
        .table-container {
            max-height: 620px;
            overflow-y: auto;
            overflow-x: hidden;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
            border: 1px solid #dee2e6;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14.2px;
            background-color: #ffffff;
        }

        th {
            background-color: #f1f8ff;
            color: #2c3e50;
            font-weight: 600;
            padding: 14px 12px;
            text-align: center;
            position: sticky;
            top: 0;
            z-index: 10;
            border-bottom: 2.2px solid #dee2e6;
        }

        td {
            padding: 12px 14px;
            border-bottom: 1px solid #f0f0f0;
            background-color: #ffffff;
        }

        td:nth-child(1), td:nth-child(2), td:nth-child(3), td:nth-child(4), td:nth-child(5) {
            text-align: left;
        }

        td:nth-child(6) { text-align: center; }

        tr:hover {
            background-color: #f9fbfc;
        }

        .choose-btn {
            padding: 7px 16px;
            border: none;
            border-radius: 7px;
            font-size: 13.8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.22s;
            min-width: 84px;
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
            opacity: 0.94;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.15);
        }

        /* SCROLLBAR ĐẸP */
        .table-container::-webkit-scrollbar {
            width: 11px;
        }

        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 12px;
        }

        .table-container::-webkit-scrollbar-thumb {
            background: #b0bec5;
            border-radius: 12px;
        }

        .table-container::-webkit-scrollbar-thumb:hover {
            background: #90a4ae;
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .container { padding: 14px 16px; width: 100%; }
            .reader-inline { flex-direction: column; align-items: flex-start; gap: 10px; }
            .tab { padding: 7px 14px; font-size: 14px; min-width: 120px; }
            .table-container { max-height: 480px; }
            th, td { padding: 9px 7px; font-size: 13.2px; }
            .choose-btn { padding: 6px 12px; font-size: 12.8px; min-width: 76px; }
        }

        @media (max-height: 800px) {
            .table-container { max-height: 420px; }
        }
    </style>
</head>
<body>

<jsp:include page="/common/header-staff-login.jsp" />

<div style="text-align: center;">
    <div class="page-banner">
        Return Document Reader
    </div>
</div>

<div class="main-content">
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">

            <button onclick="window.location.href='${pageContext.request.contextPath}/staff/FindReader.jsp'"
                    style="
              background:#6c757d;
              color:white;
              border:none;
              padding:8px 16px;
              border-radius:8px;
              font-weight:600;
              cursor:pointer;
              font-size:14.5px;
              display:flex;
              align-items:center;
              gap:6px;
              box-shadow:0 2px 6px rgba(0,0,0,0.15);
            ">
                <svg width="16" height="16" fill="white" viewBox="0 0 16 16">
                    <path d="M8 0C3.58 0 0 3.58 0 8s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm0 14c-3.31 0-6-2.69-6-6s2.69-6 6-6 6 2.69 6 6-2.69 6-6 6zm1-10H7v3H4l4 4 4-4h-3V4z"/>
                </svg>
                Back
            </button>
            <h2 style="margin:0; color:#005b96; text-align:center; flex:1;">Borrow List</h2>
            <div style="width:120px;"></div>
        </div>


        <div class="tabs">
            <div class="tab active">Borrow List</div>
            <div class="tab" onclick="window.location.href='${pageContext.request.contextPath}/fine?action=calculateLateFine'">
                Return Basket
            </div>
        </div>

        <!-- READER CARD -->
        <c:if test="${not empty sessionScope.reader}">
            <div class="reader-card">
                <div class="reader-inline">
                    <span class="label">Reader ID:</span>
                    <span class="value">${sessionScope.reader.readerId}</span>
                    <span class="label">Full name:</span>
                    <span class="value">${sessionScope.reader.fullName}</span>
                </div>
            </div>
        </c:if>

        <!-- BẢNG CUỘN -->
        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>LoanItemID</th>
                    <th>Document Title</th>
                    <th>Loan Date</th>
                    <th>Due Date</th>
                    <th>Barcode</th>
                    <th>Choose</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${sessionScope.currentLoanItems}">
                    <c:set var="isSelected" value="false" />
                    <c:forEach var="ret" items="${sessionScope.returnItems}">
                        <c:if test="${ret.loanItem.id == item.id}">
                            <c:set var="isSelected" value="true" />
                        </c:if>
                    </c:forEach>

                    <tr>
                        <td>${item.id}</td>
                        <td>${item.copy.document.title}</td>
                        <td>${item.getFormattedLoanDate()}</td>
                        <td>${item.getFormattedDueDate()}</td>
                        <td>${item.copy.barCode}</td>
                        <td>
                            <button class="choose-btn ${isSelected ? 'selected' : ''}"
                                    onclick="toggleItem(this, '${item.id}')">
                                    ${isSelected ? 'Cancle' : 'Choose'}
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    function toggleItem(button, loanItemId) {
        fetch('${pageContext.request.contextPath}/returnItem?action=choose&loanItemId=' + loanItemId)
            .then(res => res.json())
            .then(() => {
                button.classList.toggle('selected');
                button.textContent = button.classList.contains('selected') ? 'Cancle' : 'Choose';
            })
            .catch(err => {
                console.error('Toggle error:', err);
                alert('Lỗi khi chọn tài liệu. Vui lòng thử lại.');
            });
    }
</script>

</body>
</html>