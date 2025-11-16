<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Receipt (#${sessionScope.returnInvoice.id})</title>
    <style>
        /* === OPTIMIZED FOR THERMAL/RECEIPT PRINTING === */
        body {
            font-family: 'Times New Roman', Times, serif;
            font-size: 11pt;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            height: 100vh;
            flex-direction: column;
        }

        /* ==== SCROLLABLE SLIP ==== */
        #slipWrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            overflow: hidden;
            padding-top: 10px;
        }

        .slip-container {
            width: 80mm;
            padding: 10px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            border: 1px solid #ccc;

            /* NEW: allow scroll when too long */
            max-height: 85vh;
            overflow-y: auto;
            overscroll-behavior: contain;
        }

        .header { text-align: center; margin-bottom: 15px; }
        .header h4, .header p { margin: 2px 0; font-size: 11pt; }
        .header h5 { margin: 5px 0 10px; font-size: 14pt; font-weight: bold; }
        .divider { border: 1px dashed #000; margin: 8px 0; }

        .info-table { width: 100%; font-size: 10pt; }
        .info-table td { padding: 3px 0; }
        .info-table td:first-child { font-weight: bold; width: 40%; }
        .info-table td:last-child { text-align: right; }
        .status-paid { color: green; font-weight: bold; }
        .status-unpaid { color: orange; font-weight: bold; }

        .details-section h5 {
            font-size: 10pt;
            font-weight: bold;
            margin-top: 10px;
            color: #333;
        }
        .item-title {
            font-weight: bold;
            font-size: 11pt;
            display: block;
            padding-bottom: 3px;
        }
        .fine-reason {
            color: #666;
            font-size: 9pt;
            display: block;
            padding-left: 5px;
        }

        .fine-table { width: 100%; border-collapse: collapse; margin-bottom: 10px; font-size: 10pt; }
        .fine-table th, .fine-table td { padding: 3px 0; text-align: right; border-bottom: 1px dashed #eee; }
        .fine-table th { text-align: left; font-weight: bold; border-bottom: 2px solid #000; }
        .fine-table td:first-child { text-align: left; }
        .fine-table .sub-total { font-weight: bold; color: #dc3545; }
        .no-fine { font-style: italic; color: green; font-size: 9pt; text-align: left !important; }

        .total-summary { width: 100%; margin-top: 10px; font-size: 12pt; }
        .total-summary td { padding: 5px 0; }
        .total-row-label { font-weight: bold; text-align: left; }
        .total-row-amount {
            font-weight: bold;
            text-align: right;
            color: #d9534f;
            border-top: 2px solid #000;
            padding-top: 8px;
            font-size: 14pt;
        }

        .footer { text-align: center; margin-top: 20px; font-size: 10pt; }
        .footer .signature-area {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        .footer .signature-area div {
            width: 45%;
            text-align: center;
        }
        .footer .signature-area .role { font-weight: bold; margin-bottom: 5px; }
        .footer .signature-area .note { margin-top: 5px; font-style: italic; font-size: 9pt; }

        /* === FIXED ACTION BUTTON AREA === */
        .action-area {
            text-align: center;
            padding: 12px;
            border-top: 1px solid #ccc;
            background: #fff;
            position: sticky;
            bottom: 0;
        }
        .action-area button {
            padding: 8px 15px;
            cursor: pointer;
            border: none;
            border-radius: 4px;
            margin: 0 5px;
            font-weight: 500;
            font-size: 14px;
        }
        .print-btn { background-color: #007bff; color: white; }
        .home-btn { background-color: #6c757d; color: white; }
        .confirm-payment-btn { background-color: #28a745; color: white; }

        @media print {
            body {
                background: none;
                font-size: 9pt;
            }
            #slipWrapper {
                height: auto;
                overflow: visible;
            }
            .slip-container {
                width: 78mm;
                max-height: none;
                box-shadow: none;
                border: none;
                padding: 0;
                overflow: visible;
            }
            .action-area { display: none !important; }
        }
    </style>
</head>
<body>

<div id="slipWrapper">
    <div class="slip-container" id="printArea">

        <c:set var="invoice" value="${sessionScope.returnInvoice}" />
        <c:set var="grandTotalFine" value="${sessionScope.grandTotalFine}" />

        <c:if test="${not empty invoice}">
            <div class="header">
                <h4>LibMan</h4>
                <p>PTIT</p>
                <div class="divider"></div>
                <h5>Payment Slip</h5>
                <p style="font-size: 10pt;">Invoice ID: **#${invoice.id}**</p>
            </div>

            <table class="info-table">
                <tr>
                    <td>Status:</td>
                    <td>
                        <span class="${invoice.status eq 'UNPAID' ? 'status-unpaid' : 'status-paid'}">
                                ${invoice.status}
                        </span>
                    </td>
                </tr>
                <tr>
                    <td>Time:</td>
                    <td>${invoice.returnItems[0].displayReturnDateTime}</td>
                </tr>
                <tr>
                    <td>Reader:</td>
                    <td>${invoice.reader.fullName}</td>
                </tr>
                <tr>
                    <td>Staff:</td>
                    <td>${invoice.staff.fullName}</td>
                </tr>
            </table>

            <div class="divider"></div>

            <div class="details-section">
                <h5>FINE DETAILS:</h5>

                <c:forEach var="item" items="${invoice.returnItems}">
                    <c:set var="itemTotalFine" value="0" />
                    <c:set var="lateFineAmount" value="0" />
                    <c:set var="damageFineAmount" value="0" />

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

                    <span class="item-title">
                        <i class="fas fa-book-open" style="font-size: 9pt;"></i>
                        ${item.loanItem.copy.document.title}
                    </span>

                    <table class="fine-table">
                        <tr>
                            <th style="width: 50%;">Reason/Details</th>
                            <th style="width: 50%;">Fine Amount (VND)</th>
                        </tr>

                        <c:set var="fineFound" value="false" />
                        <c:forEach var="fd" items="${item.fineDetails}">
                            <c:if test="${fd.fine.type eq 'late'}">
                                <c:set var="fineFound" value="true" />
                                <tr>
                                    <td>
                                        Late Return (${fd.quantity} days)
                                        <span class="fine-reason">${fd.note}</span>
                                    </td>
                                    <td class="sub-total">
                                        <fmt:formatNumber value="${fd.fine.amount * fd.quantity}" type="number" maxFractionDigits="0" />
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>

                        <c:forEach var="fd" items="${item.fineDetails}">
                            <c:if test="${fd.fine.type eq 'damage'}">
                                <c:set var="fineFound" value="true" />
                                <tr>
                                    <td>
                                        Damage
                                        <span class="fine-reason">${fd.note}</span>
                                    </td>
                                    <td class="sub-total">
                                        <fmt:formatNumber value="${fd.fine.amount}" type="number" maxFractionDigits="0" />
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>

                        <c:if test="${not fineFound}">
                            <tr><td colspan="2" class="no-fine">No fine applied.</td></tr>
                        </c:if>

                        <c:if test="${itemTotalFine > 0}">
                            <tr>
                                <td style="font-weight: bold; padding-top: 5px;">Subtotal:</td>
                                <td class="sub-total" style="padding-top: 5px; border-top: 1px dashed #000;">
                                    <fmt:formatNumber value="${itemTotalFine}" type="number" maxFractionDigits="0" />
                                </td>
                            </tr>
                        </c:if>
                    </table>
                </c:forEach>
            </div>

            <div class="divider"></div>

            <table class="total-summary">
                <tr>
                    <td class="total-row-label">TOTAL AMOUNT:</td>
                    <td class="total-row-amount">
                        <fmt:formatNumber value="${grandTotalFine}" type="number" maxFractionDigits="0" /> VND
                    </td>
                </tr>
            </table>

            <div class="footer">
                <p style="font-style: italic; color: #777;">(Thank you for your cooperation)</p>

                <div class="signature-area">
                    <div>
                        <p class="role">Reader</p>
                        <p class="note">(${invoice.reader.fullName})</p>
                    </div>
                    <div>
                        <p class="role">Librarian</p>
                        <p class="note">(${invoice.staff.fullName})</p>
                    </div>
                </div>
                <p style="margin-top: 25px;">Issued on: ${invoice.returnItems[0].displayReturnDate}</p>
            </div>
        </c:if>

    </div>
</div>

<c:if test="${not empty invoice}">
    <div class="action-area">
        <button onclick="window.print()" class="print-btn">
            <i class="fas fa-print"></i> Print Receipt
        </button>

            <button onclick="confirmPayment()" class="confirm-payment-btn" id="confirmPaymentBtn">
                <i class="fas fa-check-double"></i> CONFIRM PAID
            </button>

        <button onclick="window.location.href='${pageContext.request.contextPath}/staff/StaffHome.jsp';" class="home-btn">
            <i class="fas fa-home"></i> Back to Main
        </button>
    </div>
</c:if>

<script>
    function confirmPayment() {
        const btn = document.getElementById('confirmPaymentBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';

        const invoiceId = '${invoice.id}';
        const contextPath = '${pageContext.request.contextPath}';

        fetch(contextPath + '/returnInvoice?action=updateStatus&invoiceId=' + invoiceId, {
            method: 'POST'
        })
            .then(response => {
                if (response.ok) {
                    alert("Payment confirmed successfully! Please print the receipt.");

                    const statusSpan = document.querySelector('.status-unpaid');
                    if (statusSpan) {
                        statusSpan.textContent = 'PAID';
                        statusSpan.classList.remove('status-unpaid');
                        statusSpan.classList.add('status-paid');
                    }

                    btn.style.display = 'none';

                } else {
                    alert("Error confirming payment. Please check server logs.");
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-check-double"></i> CONFIRM PAID';
                }
            })
            .catch(error => {
                console.error('Fetch Error:', error);
                alert("Connection or server error.");
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-check-double"></i> CONFIRM PAID';
            });
    }
</script>

</body>
</html>
