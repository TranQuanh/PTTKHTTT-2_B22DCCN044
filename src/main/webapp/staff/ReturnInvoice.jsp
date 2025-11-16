<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Return Invoice</title>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* === CSS ĐỒNG BỘ VÀ TỐI ƯU HÓA === */
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
            width: 900px;
            max-width: 94vw;
            padding: 20px 24px;
            border-radius: 14px;
            box-shadow: 0 10px 28px rgba(0,0,0,0.12);
            margin-bottom: 24px;
        }

        .container h3 {
            text-align: center;
            color: #005b96;
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: 600;
            padding-bottom: 8px;
            border-bottom: 2px solid #e6f7ff;
        }

        /* READER INFO - Đồng bộ */
        .reader-card {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-size: 14px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .reader-inline {
            display: flex;
            align-items: center;
            flex-wrap: nowrap;
        }

        .reader-inline .label {
            font-weight: 600;
            color: #333;
            margin-left: 12px;
            margin-right: 8px;
        }

        .reader-inline .value {
            color: #555;
            margin-right: 36px;
        }

        /* --- Bảng chi tiết (Tinh gọn) --- */
        .fine-table {
            border-collapse: collapse;
            width: 100%;
            font-size: 13px;
            margin-bottom: 15px;
        }
        .fine-table th, .fine-table td {
            border: 1px solid #dee2e6;
            padding: 8px 6px;
            text-align: center;
        }
        .fine-table th {
            background-color: #0099cc;
            color: white;
            font-weight: 600;
            font-size: 13px;
        }
        .fine-table tr:nth-child(even) {
            background-color: #f7fbfd;
        }
        .fine-table td.text-left { text-align: left; }
        .fine-table td.total { font-weight: bold; color: #dc3545; }

        /* TỔNG TIỀN MỤC RIÊNG */
        .item-total-summary {
            text-align: right;
            font-weight: 600;
            margin: 4px 0 15px;
            padding-top: 5px;
            font-size: 15px;
            color: #005b96;
            border-top: 1px solid #e9ecef;
        }

        /* TỔNG TIỀN CHUNG (Đồng bộ) */
        .grand-total-box {
            background-color: #d1ecf1;
            padding: 14px;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            font-size: 1.2em;
            font-weight: bold;
            text-align: right;
            margin: 20px 0;
            color: #dc3545;
        }

        .confirm-container {
            text-align: center;
            margin-top: 30px;
        }
        .confirm-btn {
            padding: 12px 28px;
            border: none;
            border-radius: 8px;
            background-color: #28a745;
            color: white;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .confirm-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<jsp:include page="/common/header-staff-login.jsp" />

<div style="text-align: center;">
    <div class="page-banner">
        Reader Return Documents
    </div>
</div>

<div class="main-content">
    <div class="container">

        <h3>Return Invoice</h3>

        <c:set var="reader" value="${sessionScope.reader}" />
        <c:set var="returnItems" value="${sessionScope.returnItems}" />

        <c:if test="${empty returnItems}">
            <p style="text-align: center; color: #666; margin: 30px 0;">
                No return Item
            </p>
        </c:if>

        <%-- READER INFO – CÙNG 1 HÀNG --%>
        <c:if test="${not empty reader}">
            <div class="reader-card">
                <div class="reader-inline">
                    <span class="label">Reader ID:</span>
                    <span class="value">${reader.readerId}</span>
                    <span class="label">Tên:</span>
                    <span class="value">${reader.fullName}</span>
                </div>
            </div>
        </c:if>

        <c:set var="grandTotalFine" value="0" />

        <c:if test="${not empty returnItems}">

            <%-- Vòng lặp hiển thị từng ReturnItem --%>
            <c:forEach var="item" items="${returnItems}">
                <c:set var="itemTotalFine" value="0" />
                <c:set var="lateFineAmount" value="0" />
                <c:set var="damageFineAmount" value="0" />

                <%--
                  **SỬA CHỮA LOGIC TÍNH TOÁN TỔNG TIỀN PHẠT CHO MỖI ITEM**
                  Late fine: Phí/Ngày * Số ngày (quantity)
                  Damage fine: Cộng dồn tiền phạt (fd.fine.amount) cho mỗi lần hư hỏng
                --%>
                <c:forEach var="fd" items="${item.fineDetails}">
                    <c:choose>
                        <c:when test="${fd.fine.type eq 'late'}">
                            <c:set var="lateFineAmount" value="${fd.fine.amount * fd.quantity}" />
                        </c:when>
                        <c:when test="${fd.fine.type eq 'damage'}">
                            <c:set var="damageFineAmount" value="${damageFineAmount + fd.fine.amount}" />
                        </c:when>
                    </c:choose>
                </c:forEach>

                <c:set var="itemTotalFine" value="${lateFineAmount + damageFineAmount}" />
                <c:set var="grandTotalFine" value="${grandTotalFine + itemTotalFine}" />

                <h4 style="color: #005b96; margin: 20px 0 10px; border-bottom: 2px solid #e6f7ff; padding-bottom: 5px;">
                    <i class="fas fa-book-reader"></i> Document: ${item.loanItem.copy.document.title}
                    <span style="font-weight: 400; font-size: 0.9em; color: #6c757d;">(Return Item Id: ${item.loanItem.id})</span>
                </h4>

                <%-- =================================== --%>
                <%-- 1. BẢNG PHẠT TRỄ HẠN (LATE FINE) --%>
                <%-- =================================== --%>
                <h5 style="color: #dc3545; margin-bottom: 8px;"><i class="fas fa-clock"></i> Late Fine</h5>

                <c:set var="hasLateFine" value="false"/>
                <table class="fine-table">
                    <thead>
                    <tr>
                        <th style="width: 40%;" class="text-left">Reason</th>
                        <th style="width: 15%;">Late Day</th>
                        <th style="width: 20%;">Amount/day</th>
                        <th style="width: 25%;">Total amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="fd" items="${item.fineDetails}">
                        <c:if test="${fd.fine.type eq 'late'}">
                            <c:set var="hasLateFine" value="true"/>
                            <tr>
                                <td class="text-left">${fd.note}</td>
                                <td>${fd.quantity}</td>
                                <td><fmt:formatNumber value="${fd.fine.amount}" type="number" maxFractionDigits="0" /></td>
                                <td class="total">
                                        <%-- Hiển thị tính toán Late Fine đúng: Phí/Ngày * Số ngày --%>
                                    <fmt:formatNumber value="${fd.fine.amount * fd.quantity}" type="number" maxFractionDigits="0" />
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <c:if test="${not hasLateFine}">
                        <tr><td colspan="4" style="color: #28a745;">Không áp dụng phạt trễ hạn.</td></tr>
                    </c:if>
                    </tbody>
                </table>

                <%-- =================================== --%>
                <%-- 2. BẢNG PHẠT HƯ HỎNG (DAMAGE FINE) --%>
                <%-- =================================== --%>
                <h5 style="color: #dc3545; margin-bottom: 8px;"><i class="fas fa-exclamation-triangle"></i> Damage Fine</h5>

                <c:set var="hasDamageFine" value="false"/>
                <table class="fine-table">
                    <thead>
                    <tr>
                        <th style="width: 60%;" class="text-left">Reason</th>
                        <th style="width: 40%;">Amount</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="fd" items="${item.fineDetails}">
                        <c:if test="${fd.fine.type eq 'damage'}">
                            <c:set var="hasDamageFine" value="true"/>
                            <tr>
                                <td class="text-left">${fd.note}</td>
                                <td class="total">
                                        <%-- Hiển thị Damage Fine (đã giả định fd.fine.amount là tổng tiền phạt cho hư hỏng đó) --%>
                                    <fmt:formatNumber value="${fd.fine.amount}" type="number" maxFractionDigits="0" />
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <c:if test="${not hasDamageFine}">
                        <tr><td colspan="2" style="color: #28a745;">No damage fine</td></tr>
                    </c:if>
                    </tbody>
                </table>


                <%-- TỔNG TIỀN CHO TỪNG ITEM --%>
                <div class="item-total-summary">
                    Total amount this return item:
                    <fmt:formatNumber value="${itemTotalFine}" type="number" maxFractionDigits="0" /> VND
                </div>

            </c:forEach>

            <hr style="border-top: 2px solid #005b96; margin: 30px 0 10px;"/>

            <%-- TỔNG CỘNG CHUNG CUỘC --%>
            <div class="grand-total-box">
               Total Amount:
                <fmt:formatNumber value="${grandTotalFine}" type="number" maxFractionDigits="0" /> VND
            </div>
        </c:if>

        <div class="confirm-container">
            <c:if test="${not empty returnItems}">
                <button id="confirmBtn" class="confirm-btn" onclick="confirmReturn()">
                    <i class="fas fa-check-circle"></i> Confirm
                </button>
            </c:if>
            <c:if test="${empty returnItems}">
                <button class="confirm-btn" onclick="window.location.href='${pageContext.request.contextPath}/loanItem?action=listByReader'">
                    <i class="fas fa-arrow-left"></i> Back
                </button>
            </c:if>
        </div>

    </div>
</div>

<script>
    function confirmReturn() {
        const btn = document.getElementById('confirmBtn');
        btn.disabled = true;
        btn.textContent = 'processing...';

        // Gửi yêu cầu POST về Controller để tạo hóa đơn
        fetch('${pageContext.request.contextPath}/returnInvoice?action=createReturnInvoice', {
            method: 'POST'
        })
            .then(response => {
                if (response.ok) {
                    // Chuyển hướng đến trang PaymentSlip sau khi Controller xác nhận tạo hóa đơn thành công
                    window.location.href = '${pageContext.request.contextPath}/staff/PaymentSlip.jsp';
                } else {
                    // Nếu có lỗi, xử lý thông báo lỗi
                    return response.text().then(text => {
                        let errorMsg = "Lỗi Server không xác định.";
                        try {
                            const json = JSON.parse(text);
                            errorMsg = json.message || errorMsg;
                        } catch (e) {
                            // ignore parsing error
                        }
                        throw new Error(errorMsg);
                    });
                }
            })
            .catch(error => {
                console.error('Error during confirmation:', error);
                alert('Confirm error: ' + error.message);
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-check-circle"></i> Confirm';
            });
    }
</script>

</body>
</html>