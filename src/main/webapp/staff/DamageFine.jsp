<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Damage Option</title>
    <style>
        /* CSS giữ nguyên từ file gốc */
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
            max-width: 950px;
            margin: 50px auto;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
        h3 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .info-table { width: 100%; margin-bottom: 20px; font-size: 14px; }
        .info-table th { width: 15%; text-align: right; padding-right: 10px; font-weight: bold; white-space: nowrap; }
        .info-table td { width: 35%; padding-left: 10px; }
        table { border-collapse: collapse; width: 100%; margin-top: 15px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #f2f2f2; }

        .col-fine-id { width: 8%; }
        .col-type { width: 12%; }
        .col-reason { width: 35%; }
        .col-amount { width: 10%; }
        .col-quantity { width: 10%; }
        .col-actions { width: 15%; }

        .choose-fine-btn {
            padding: 5px 12px; border: none; border-radius: 4px;
            background-color: #0099cc; color: white; cursor: pointer;
            transition: background-color 0.25s;
        }
        .choose-fine-btn.selected { background-color: #dc3545; }

        .quantity-input-data {
            width: 40px;
            text-align: center;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        /* ✅ CSS MỚI: Dùng cho Quantity input bị khóa */
        .quantity-input-data:disabled {
            background-color: #eee;
            cursor: not-allowed;
        }

        .button-group { margin-top: 25px; overflow: auto; }
        .agree-btn {
            padding: 10px 20px; border: none; border-radius: 5px;
            background-color: #28a745; color: white; cursor: pointer;
            float: right; margin-left: 10px;
        }
        .back-btn {
            padding: 10px 20px; border: none; border-radius: 5px;
            background-color: #6c757d; color: white; cursor: pointer;
            float: right;
        }
    </style>
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container">
    <h3>Damage Option</h3>

    <c:if test="${not empty requestScope.error}">
        <p style="color: red; text-align: center; font-weight: bold;">LỖI: ${requestScope.error}</p>
    </c:if>

    <table class="info-table">
        <tr>
            <th>readerID:</th>
            <td>${reader.readerId}</td>
            <th>Reader Name:</th>
            <td>${reader.fullName}</td>
        </tr>
        <tr>
            <th>LoanId:</th>
            <td>${targetLoanItemId}</td>
            <th>BookTitle:</th>
            <td>${bookTitle}</td>
        </tr>
    </table>

    <table id="damage-fines-table">
        <thead>
        <tr>
            <th class="col-fine-id">Fine ID</th>
            <th class="col-type">Type</th>
            <th class="col-reason">Reason</th>
            <th class="col-amount">Amount</th>
            <th class="col-quantity">Quantity</th>
            <th class="col-actions">Actions</th>
        </tr>
        </thead>
        <tbody>
    <c:if test="${empty damageFines}">
        <tr>
            <td colspan="6">Không có loại phạt hư hỏng nào được cấu hình.</td>
        </tr>
    </c:if>

    <c:forEach var="fine" items="${damageFines}">
        <%-- ✅ KIỂM TRA ĐIỀU KIỆN: Chỉ render nếu Fine ID KHÔNG RỖNG --%>
        <c:if test="${not empty fine.id}">

            <c:set var="fineDetailObj" value="${currentFineDetailsMap[fine.id]}"/>
            <c:set var="isChosen" value="${not empty fineDetailObj}"/>
            <c:set var="currentQuantity" value="${isChosen ? fineDetailObj.quantity : 1}"/>

            <c:set var="safeFineId">
                <c:out value="${fine.id}" escapeXml="true" />
            </c:set>

            <tr id="row-${safeFineId}"
                data-fine-id="${safeFineId}"
                data-chosen="${isChosen}">
                <td class="col-fine-id">${safeFineId}</td>
                <td class="col-type">Damage Option</td>
                <td class="col-reason">${fine.reason}</td>
                <td class="col-amount">${fine.amount}</td>

                <td class="col-quantity">
                    <input type="number"
                           id="qty-input-${safeFineId}"
                           value="${currentQuantity}"
                           min="1"
                           class="quantity-input-data"
                           required
                        ${isChosen ? 'disabled' : ''}>
                </td>

                <td class="col-actions">
                    <button class="choose-fine-btn ${isChosen ? 'selected' : ''}"
                            onclick="toggleFine(this, '${safeFineId}', '${targetLoanItemId}')">
                            ${isChosen ? 'Bỏ chọn' : 'Chọn'}
                    </button>
                </td>
            </tr>
        </c:if>
        <%-- Kết thúc thẻ c:if cho kiểm tra ID --%>
    </c:forEach>
    </tbody>
    </table>

    <div class="button-group">
        <button class="agree-btn" onclick="redirectToLateFine()">
            Đồng ý
        </button>
        <button class="back-btn" onclick="window.location.href='${pageContext.request.contextPath}/fine?action=calculateLateFine'">
            Back
        </button>
    </div>
</div>

<script>
    function toggleFine(button, fineId, loanItemId) {

        // ✅ Sửa lỗi: Chỉ dùng phép nối chuỗi (+) cho biến JS cục bộ
        const qtyInput = document.getElementById('qty-input-' + fineId);
        if (!qtyInput) {
            alert("LỖI: Không tìm thấy input Quantity với ID: qty-input-" + fineId + ". Vui lòng kiểm tra dữ liệu Fine ID.");
            return;
        }

        // Đọc quantity (chỉ đọc được nếu không bị disabled)
        const quantity = parseInt(qtyInput.value);
        if (isNaN(quantity) || quantity <= 0) {
            alert("Số lượng phải là số nguyên dương (> 0).");
            return;
        }

        // ✅ Sửa lỗi: Chỉ dùng phép nối chuỗi (+) cho URL
        let url = '${pageContext.request.contextPath}/fine?action=chooseDamageFine'
            + '&fineId=' + fineId
            + '&loanItemId=' + loanItemId
            + '&quantity=' + quantity;

        fetch(url, { method: 'POST' })
            .then(res => {
                if (!res.ok) {
                    return res.json().then(data => {
                        throw new Error(data.message || res.statusText);
                    });
                }
                return res.json();
            })
            .then(data => {

                // 1. Toggle class và text
                button.classList.toggle('selected');
                const isSelected = button.classList.contains('selected');
                button.textContent = isSelected ? 'Bỏ chọn' : 'Chọn';

                // 2. KHÓA HOẶC MỞ KHÓA INPUT QUANTITY
                // isSelected = true (Vừa CHỌN) => disabled = true (Khóa)
                // isSelected = false (Vừa BỎ CHỌN) => disabled = false (Mở khóa)
                qtyInput.disabled = isSelected;

                // 3. Reset Quantity về 1 khi hủy (Chỉ thực hiện khi bỏ chọn)
                if (!isSelected) {
                    qtyInput.value = '1';
                }

                // 4. Cập nhật data-chosen
                const row = button.closest('tr');
                row.setAttribute('data-chosen', isSelected ? 'true' : 'false');
                console.log('Damage Fine ID ' + fineId + ' đã được ' + (isSelected ? 'CHỌN' : 'BỎ CHỌN') + '.');

            })
            .catch(err => {
                console.error('Toggle Fine error:', err);
                alert('Lỗi khi cập nhật phạt: ' + err.message);
            });
    }

    function redirectToLateFine() {
        window.location.href = '${pageContext.request.contextPath}/fine?action=calculateLateFine';
    }
</script>

</body>
</html>