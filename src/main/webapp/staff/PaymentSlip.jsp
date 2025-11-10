<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Phiếu Xác Nhận Giao Dịch</title>
    <style>
        /* CSS Giữ Nguyên */
        body { font-family: 'Times New Roman', Times, serif; font-size: 11pt; margin: 0; padding: 0; }
        .slip-container {
            width: 80mm;
            margin: 15px auto;
            border: 1px solid #000;
            padding: 15px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
        }
        .header { text-align: center; margin-bottom: 10px; }
        .header h4, .header h5 { margin: 2px 0; }
        .header h4 { font-size: 14pt; }
        .header h5 { font-size: 11pt; }

        .info-table { width: 100%; margin-bottom: 10px; font-size: 10pt; }
        .info-table td:first-child { width: 35%; font-weight: bold; }
        .info-table td:last-child { text-align: right; }

        .details-table { width: 100%; border-collapse: collapse; margin-top: 5px; font-size: 10pt; }
        .details-table th, .details-table td { padding: 4px 0; text-align: left; }
        .details-table th { border-bottom: 1px solid #000; }
        .details-table td { border-bottom: 1px dashed #ccc; vertical-align: top; }

        .item-title { font-weight: bold; font-size: 10.5pt; }
        .fine-reason { color: #666; font-size: 9.5pt; display: block; }

        .total-summary { width: 100%; margin-top: 10px; font-size: 12pt; }
        .total-summary td { padding: 5px 0; }
        .total-row-label { font-weight: bold; text-align: right; }
        .total-row-amount { font-weight: bold; text-align: right; color: #d9534f; border-top: 2px solid #000; }

        .footer { text-align: right; margin-top: 20px; font-size: 10pt; }
        .signature { margin-top: 30px; }

        .print-btn-area {
            text-align: center;
            margin-top: 20px;
        }
        .print-btn-area button {
            padding: 10px 20px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            margin: 0 5px;
            font-weight: bold;
        }
        .print-btn-area .print-btn {
            background-color: #007bff;
            color: white;
        }
        .print-btn-area .home-btn {
            background-color: #6c757d;
            color: white;
        }

        @media print {
            .print-btn-area { display: none; }
        }
    </style>
</head>
<body>

<div class="slip-container" id="printArea">

    <c:set var="invoice" value="${sessionScope.returnInvoice}" />
    <c:set var="totalFine" value="${sessionScope.grandTotalFine}" />
    <%-- Lấy ReturnItem đầu tiên để hiển thị ngày tháng --%>
    <c:set var="firstItem" value="${not empty invoice.returnItems ? invoice.returnItems[0] : null}" />

    <div class="header">
        <h4>THƯ VIỆN ĐẠI HỌC CÔNG NGHIỆP</h4>
        <p style="font-size: 10pt; margin: 5px 0;">Địa chỉ: 12 Nguyễn Văn Bảo, Phường 4, Gò Vấp, TPHCM</p>
        <hr style="border: 1px dashed #000; margin: 8px 0;">
        <h5>PHIẾU XÁC NHẬN GIAO DỊCH TRẢ SÁCH</h5>
    </div>

    <table class="info-table">
        <tr>
            <td>**Mã Giao Dịch:**</td>
            <td>**${invoice.id != null ? invoice.id : '---'}**</td>
        </tr>
        <tr>
            <td>Thời Gian Giao Dịch:</td>
            <td>${firstItem != null ? firstItem.displayReturnDateTime : '---'}</td>
        </tr>
        <tr>
            <td>Độc Giả:</td>
            <td>${invoice.reader != null ? invoice.reader.fullName : '---'}</td>
        </tr>
        <tr>
            <td>Nhân Viên:</td>
            <td>${invoice.staff != null ? invoice.staff.fullName : '---'}</td>
        </tr>
    </table>

    <hr style="border: 1px dashed #000; margin: 5px 0;">

    <p style="font-weight: bold; margin-bottom: 5px;">CHI TIẾT PHÍ PHẠT (Nếu có):</p>
    <table class="details-table">
        <thead>
        <tr>
            <th style="width: 70%;">Tài liệu</th>
            <th>Thành tiền (VND)</th>
        </tr>
        </thead>
        <tbody>
        <c:set var="hasFine" value="false" />
        <c:forEach var="item" items="${invoice.returnItems}">
            <c:set var="itemTotalFine" value="0" />
            <c:set var="fineDetailsString" value="" />

            <%-- Tính toán tổng phạt và lý do --%>
            <c:forEach var="fd" items="${item.fineDetails}">
                <c:set var="currentFineAmount" value="${fd.fine.amount * fd.quantity}" />
                <c:set var="itemTotalFine" value="${itemTotalFine + currentFineAmount}" />

                <c:if test="${currentFineAmount > 0}">
                    <c:set var="hasFine" value="true" />
                    <c:set var="fineDetailsString" value="${fineDetailsString}${fd.fine.reason} (${fd.quantity}), " />
                </c:if>
            </c:forEach>

            <tr class="item-row">
                <td>
                    <span class="item-title">${item.loanItem.copy.document.title}</span>
                    <c:if test="${!empty fineDetailsString}">
                            <span class="fine-reason">
                                Lý do: <c:out value="${fineDetailsString.substring(0, fineDetailsString.length() - 2)}" />
                            </span>
                    </c:if>
                    <c:if test="${empty fineDetailsString && itemTotalFine == 0}">
                        <span class="fine-reason" style="color: green;">Đã trả đúng hạn/Không hư hỏng.</span>
                    </c:if>
                </td>
                <td style="text-align: right;">
                    <fmt:formatNumber value="${itemTotalFine}" type="number" maxFractionDigits="0" />
                </td>
            </tr>
        </c:forEach>

        <c:if test="${!hasFine}">
            <tr><td colspan="2" style="text-align: center; color: green; border-bottom: none; padding: 10px 0;">
                Không có khoản phạt nào được áp dụng.
            </td></tr>
        </c:if>
        </tbody>
    </table>

    <hr style="border: 1px dashed #000; margin: 10px 0;">
    <table class="total-summary" style="border: none;">
        <tr>
            <td class="total-row-label">TỔNG TIỀN PHẠT PHẢI THU:</td>
            <td class="total-row-amount">
                <fmt:formatNumber value="${totalFine}" type="number" maxFractionDigits="0" /> VND
            </td>
        </tr>
    </table>

    <div class="footer">
        <p style="margin-bottom: 50px;">
            Ngày lập: ${firstItem != null ? firstItem.displayReturnDate : '---'}
        </p>

        <p style="margin: 0; font-weight: bold;">Nhân viên xác nhận</p>
        <p style="margin-top: 5px;">(Ký và ghi rõ họ tên)</p>
    </div>
</div>

<div class="print-btn-area">
    <button onclick="window.print()" class="print-btn">
        🖨️ In Phiếu Xác Nhận Giao Dịch
    </button>

    <button onclick="window.location.href='${pageContext.request.contextPath}/staff/index.jsp';" class="home-btn">
        🏠 Về Trang Chủ
    </button>
</div>

<%-- ✅ DỌN DẸP SESSION SAU KHI DỮ LIỆU ĐƯỢC HIỂN THỊ --%>
<c:remove var="returnInvoice" scope="session" />
<c:remove var="grandTotalFine" scope="session" />

</body>
</html>