<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Return Invoice</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f8fa;
            margin: 0;
            padding: 0;
        }
        .container {
            background-color: white;
            padding: 40px 50px;
            border: 1px solid #ccc;
            border-radius: 10px;
            max-width: 850px;
            margin: 50px auto;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        h3 {
            text-align: center;
            color: #0099cc;
            margin-bottom: 30px;
            font-size: 28px;
            border-bottom: 2px solid #0099cc;
            padding-bottom: 10px;
        }

        /* --- Thông tin độc giả và Tổng tiền --- */
        .summary-info {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .summary-info th, .summary-info td {
            padding: 8px 15px;
            text-align: left;
            border: none;
        }
        .summary-info th {
            width: 150px;
            font-weight: bold;
            color: #555;
        }
        .total-row {
            border-top: 2px solid #0099cc;
            font-size: 1.1em;
            font-weight: bold;
        }
        .total-row td:last-child {
            color: #dc3545; /* Màu đỏ cho tổng tiền */
        }

        /* --- Bảng chi tiết trả sách --- */
        .invoice-table {
            border-collapse: collapse;
            width: 100%;
        }
        .invoice-table th, .invoice-table td {
            border: 1px solid #ccc;
            padding: 12px 8px;
            text-align: center;
            font-size: 0.95em;
        }
        .invoice-table th {
            background-color: #0099cc;
            color: white;
            font-weight: normal;
        }
        .invoice-table tr:nth-child(even) {
            background-color: #f7f7f7;
        }

        .col-book-title { text-align: left; }
        .col-loan-id { width: 15%; }
        .col-date { width: 10%; }
        .col-fine { width: 8%; }
        .col-days { width: 5%; }
        .col-total-fine { width: 10%; font-weight: bold; color: #333; }


        /* --- Nút Xác nhận --- */
        .confirm-container {
            text-align: right;
            margin-top: 30px;
        }
        .confirm-btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            background-color: #28a745; /* Xanh lá */
            color: white;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .confirm-btn:hover {
            background-color: #1e7e34;
        }
    </style>
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container">

    <h3><i class="fas fa-file-invoice"></i> RETURN INVOICE</h3>

    <c:set var="reader" value="${sessionScope.reader}" />
    <c:set var="returnItems" value="${sessionScope.returnItems}" />

    <c:if test="${empty returnItems}">
        <p style="text-align: center; color: red;">Không có tài liệu nào trong giỏ trả sách.</p>
    </c:if>

    <c:if test="${not empty reader}">
        <table class="summary-info">
            <tr>
                <th>Reader ID:</th>
                <td>${reader.readerId}</td>
            </tr>
            <tr>
                <th>Reader Name:</th>
                <td>${reader.fullName}</td>
            </tr>
        </table>
    </c:if>

    <c:set var="grandTotalFine" value="0" />

    <table class="invoice-table">
        <thead>
        <tr>
            <th class="col-loan-id">Loan ID</th>
            <th class="col-book-title">Book Title</th>
            <th class="col-date">Loan Date</th>
            <th class="col-date">Due Date</th>
            <th class="col-days">Overdue Days</th>
            <th class="col-fine">Late Fine</th>
            <th class="col-fine">Damage Fine</th>
            <th class="col-total-fine">Total Fine</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${returnItems}">
            <c:set var="lateFineAmount" value="0" />
            <c:set var="damageFineAmount" value="0" />
            <c:set var="overdueDays" value="0" />

            <%-- Tính toán tiền phạt chi tiết --%>
            <c:forEach var="fd" items="${item.fineDetails}">
                <c:choose>
                    <c:when test="${fd.fine.type eq 'late'}">
                        <c:set var="lateFineAmount" value="${fd.fine.amount * fd.quantity}" />
                        <c:set var="overdueDays" value="${fd.quantity}" />
                    </c:when>
                    <c:when test="${fd.fine.type eq 'damage'}">
                        <c:set var="damageFineAmount" value="${damageFineAmount + (fd.fine.amount * fd.quantity)}" />
                    </c:when>
                </c:choose>
            </c:forEach>

            <c:set var="itemTotalFine" value="${lateFineAmount + damageFineAmount}" />
            <c:set var="grandTotalFine" value="${grandTotalFine + itemTotalFine}" />

            <tr>
                <td class="col-loan-id">${item.loanItem.id}</td>
                <td class="col-book-title">${item.loanItem.copy.document.title}</td>
                <td class="col-date">${item.loanItem.formattedLoanDate}</td>
                <td class="col-date">${item.loanItem.formattedDueDate}</td>
                <td class="col-days">${overdueDays}</td>
                <td class="col-fine">
                    <fmt:formatNumber value="${lateFineAmount}" type="number" maxFractionDigits="0" />
                </td>
                <td class="col-fine">
                    <fmt:formatNumber value="${damageFineAmount}" type="number" maxFractionDigits="0" />
                </td>
                <td class="col-total-fine">
                    <fmt:formatNumber value="${itemTotalFine}" type="number" maxFractionDigits="0" />
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <table class="summary-info" style="margin-top: 25px;">
        <tr class="total-row">
            <th style="width: 70%; text-align: right;">GRAND TOTAL FINE:</th>
            <td style="width: 30%; text-align: right;">
                <fmt:formatNumber value="${grandTotalFine}" type="number" maxFractionDigits="0" /> VND
            </td>
        </tr>
    </table>

    <div class="confirm-container">
        <button id="confirmBtn" class="confirm-btn" onclick="confirmReturn()">Confirm</button>
    </div>

</div>

<script>
    function confirmReturn() {
        const btn = document.getElementById('confirmBtn');
        btn.disabled = true;
        btn.textContent = 'Đang xử lý...';

        // Gửi yêu cầu POST về ReturnItemController để tạo hóa đơn
        fetch('${pageContext.request.contextPath}/returnInvoice?action=createReturnInvoice', {
            method: 'POST'
        })
            .then(response => {
                if (response.ok) {
                    // Nếu thành công, chuyển hướng đến trang thông báo thành công (Controller đã forward)
                    // Tuy nhiên, vì Controller đã forward, ta cần xử lý chuyển hướng nếu fetch thành công
                    // hoặc để Controller gửi lại URL chuyển hướng
                    window.location.href = '${pageContext.request.contextPath}/staff/PaymentSlip.jsp';

                } else {
                    return response.text().then(text => {
                        throw new Error("Lỗi Server: " + text);
                    });
                }
            })
            .catch(error => {
                console.error('Error during confirmation:', error);
                alert('Xác nhận thất bại: ' + error.message);
                btn.disabled = false;
                btn.textContent = 'Confirm';
            });
    }
</script>

</body>
</html>