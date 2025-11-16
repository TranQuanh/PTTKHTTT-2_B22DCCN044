<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Return Basket</title>
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
      margin: 8px auto 8px;
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
      display: flex;
      flex-direction: column;
      height: calc(100vh - 140px);
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

    /* CỐ ĐỊNH HEADER */
    .fixed-header {
      position: sticky;
      top: 0;
      background: white;
      z-index: 10;
      margin-bottom: 8px;
    }

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

    /* PHẦN CUỘN */
    .scrollable-content {
      flex: 1;
      overflow-y: auto;
      padding-right: 6px;
      margin-bottom: 2px;
    }

    .scrollable-content::-webkit-scrollbar {
      width: 11px;
    }

    .scrollable-content::-webkit-scrollbar-track {
      background: #f1f1f1;
      border-radius: 12px;
    }

    .scrollable-content::-webkit-scrollbar-thumb {
      background: #b0bec5;
      border-radius: 12px;
    }

    .scrollable-content::-webkit-scrollbar-thumb:hover {
      background: #90a4ae;
    }

    .item-card {
      background: #f8f9fa;
      border: 1px solid #dee2e6;
      border-radius: 12px;
      padding: 16px;
      margin-bottom: 18px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }

    .item-info {
      display: grid;
      grid-template-columns: 1fr 2fr;
      gap: 14px;
      margin-bottom: 12px;
      font-size: 14.5px;
    }

    .item-info .label { font-weight: 600; color: #333; }
    .item-info .value { color: #444; }

    .dates-row {
      display: flex;
      gap: 22px;
      font-size: 14px;
      color: #555;
      margin-top: 8px;
    }

    .dates-row div { flex: 1; }
    .dates-row strong { color: #333; }

    .fine-section {
      margin-top: 16px;
    }

    .fine-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13.8px;
      margin-top: 10px;
    }

    .fine-table th {
      background-color: #e3f2fd;
      padding: 7px 9px;
      font-weight: 600;
      text-align: center;
      font-size: 13.2px;
    }

    .fine-table td {
      padding: 7px 9px;
      text-align: center;
      border-bottom: 1px solid #eee;
    }

    .fine-table tr:last-child td { border-bottom: none; }

    .action-btn, .delete-btn {
      padding: 6px 12px;
      border: none;
      border-radius: 7px;
      font-size: 13.5px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.22s;
    }

    .action-btn {
      background-color: #0099cc;
      color: white;
    }

    .delete-btn {
      background-color: #dc3545;
      color: white;
    }

    .action-btn:hover { background-color: #0077aa; }
    .delete-btn:hover { background-color: #c82333; }

    .total-summary {
      text-align: right;
      font-weight: bold;
      margin-top: 12px;
      font-size: 14.5px;
      color: #dc3545;
    }

    .grand-total-box {
      background-color: #d1ecf1;
      padding: 8px;
      border: 1.6px solid #bee5eb;
      border-radius: 10px;
      font-size: 0.98em;
      font-weight: bold;
      text-align: right;
      margin: 8px 0;
      color: #dc3545;
      position: sticky;
      bottom: 0;
      background: white;
      z-index: 5;
      box-shadow: 0 -2px 8px rgba(0,0,0,0.05);
    }

    .confirm-btn {
      display: block;
      margin: 8px auto 0;
      padding: 11px 26px;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 9px;
      font-weight: 600;
      font-size: 15.5px;
      cursor: pointer;
      transition: 0.2s;
    }

    .confirm-btn:hover { background-color: #218838; }

    @media (max-width: 768px) {
      .container { padding: 14px 16px; height: auto; }
      .reader-inline { flex-direction: column; align-items: flex-start; gap: 10px; }
      .item-info { grid-template-columns: 1fr; }
      .dates-row { flex-direction: column; gap: 8px; }
      .scrollable-content { max-height: 1200px; }
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

    <div class="fixed-header">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
        <button onclick="window.location.href='${pageContext.request.contextPath}/staff/ReaderFind.jsp'"
                style="background:#6c757d; color:white; border:none; padding:8px 16px; border-radius:8px; font-weight:600; cursor:pointer; font-size:14.5px; display:flex; align-items:center; gap:6px; box-shadow:0 2px 6px rgba(0,0,0,0.15);">
          <svg width="16" height="16" fill="white" viewBox="0 0 16 16">
            <path d="M8 0C3.58 0 0 3.58 0 8s3.58 8 8 8 8-3.58 8-8-3.58-8-8-8zm0 14c-3.31 0-6-2.69-6-6s2.69-6 6-6 6 2.69 6 6-2.69 6-6 6zm1-10H7v3H4l4 4 4-4h-3V4z"/>
          </svg>
          Back
        </button>

        <h2 style="margin:0; color:#005b96; text-align:center; flex:1;">Return Basket</h2>
        <div style="width:120px;"></div>
      </div>

      <div class="tabs">
        <div class="tab" onclick="window.location.href='${pageContext.request.contextPath}/loanItem?action=listByReader'">
          Borrow List
        </div>
        <div class="tab active">Return Basket</div>
      </div>

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
    </div>

    <!-- PHẦN CUỘN -->
    <div class="scrollable-content">
      <c:set var="grandTotalFine" value="0" />

      <c:if test="${empty sessionScope.returnItems}">
        <p style="text-align:center; color: #666; margin: 40px 0; font-size: 15px;">
          No LoanItem to return
        </p>
      </c:if>

      <c:forEach var="item" items="${sessionScope.returnItems}">
        <c:set var="itemTotalFine" value="0" />
        <c:set var="lateFineAmount" value="0" />
        <c:set var="damageFineAmount" value="0" />

        <c:forEach var="fd" items="${item.fineDetails}">
          <c:set var="currentFine" value="${fd.fine.amount * fd.quantity}" />
          <c:set var="itemTotalFine" value="${itemTotalFine + currentFine}" />
          <c:if test="${fd.fine.type eq 'late'}">
            <c:set var="lateFineAmount" value="${lateFineAmount + currentFine}" />
          </c:if>
          <c:if test="${fd.fine.type eq 'damage'}">
            <c:set var="damageFineAmount" value="${damageFineAmount + currentFine}" />
          </c:if>
        </c:forEach>

        <c:set var="grandTotalFine" value="${grandTotalFine + itemTotalFine}" />

        <div class="item-card">
          <div class="item-info">
            <div><span class="label">Loan ID:</span> <span class="value">${item.loanItem.id}</span></div>
            <div><span class="label">Book Title:</span> <span class="value">${item.loanItem.copy.document.title}</span></div>
          </div>

          <div class="dates-row">
            <div><strong>Loan date:</strong> ${item.loanItem.formattedLoanDate}</div>
            <div><strong>Due date:</strong> ${item.loanItem.formattedDueDate}</div>
            <div><strong>return Date:</strong> ${item.formattedReturnDate}</div>
          </div>

          <!-- LATE FINE -->
          <div class="fine-section">
            <h4 style="margin: 14px 0 8px; color: #005b96; font-size: 15px;">Late Fine</h4>
            <table class="fine-table">
              <thead>
              <tr>
                <th>Type</th><th>Reason</th><th>Late Days</th><th>Amount/Day</th><th>Total</th>
              </tr>
              </thead>
              <tbody>
              <c:set var="lateExists" value="false"/>
              <c:forEach var="fd" items="${item.fineDetails}">
                <c:if test="${fd.fine.type eq 'late'}">
                  <c:set var="lateExists" value="true"/>
                  <tr>
                    <td>${fd.fine.type}</td>
                    <td>${fd.note}</td>
                    <td>${fd.quantity}</td>
                    <td><fmt:formatNumber value="${fd.fine.amount}" type="number" maxFractionDigits="0"/></td>
                    <td><fmt:formatNumber value="${fd.fine.amount * fd.quantity}" type="number" maxFractionDigits="0"/></td>
                  </tr>
                </c:if>
              </c:forEach>
              <c:if test="${not lateExists}">
                <tr><td colspan="5" style="color: #28a745; font-weight: 500;">No Late Fine</td></tr>
              </c:if>
              </tbody>
            </table>
          </div>

          <!-- DAMAGE FINE -->
          <div class="fine-section" style="margin-top: 18px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
              <h4 style="margin: 0; color: #dc3545; font-size: 15px;">Damage Fine</h4>
              <button class="action-btn" onclick="chooseDamage('${item.loanItem.id}')">Choose Damage</button>
            </div>
            <table class="fine-table">
              <thead>
              <tr>
                <th>Type</th><th>Reason</th><th>Amount</th>
              </tr>
              </thead>
              <tbody>
              <c:set var="damageExists" value="false"/>
              <c:forEach var="fd" items="${item.fineDetails}">
                <c:if test="${fd.fine.type eq 'damage'}">
                  <c:set var="damageExists" value="true"/>
                  <tr>
                    <td>${fd.fine.type}</td>
                    <td>${fd.fine.reason}</td>
                    <td><fmt:formatNumber value="${fd.fine.amount}" type="number" maxFractionDigits="0"/></td>
                  </tr>
                </c:if>
              </c:forEach>
              <c:if test="${not damageExists}">
                <tr><td colspan="3" style="color: #28a745; font-weight: 500;">Choose Damage Fine</td></tr>
              </c:if>
              </tbody>
            </table>
          </div>

          <div class="total-summary">
            Total amount return item: <fmt:formatNumber value="${itemTotalFine}" type="number" maxFractionDigits="0"/> VND
          </div>

          <div style="text-align: right; margin-top: 12px;">
            <button class="delete-btn" onclick="deleteItem('${item.loanItem.id}')">Delete</button>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- TỔNG CỘNG CỐ ĐỊNH -->
    <c:if test="${not empty sessionScope.returnItems}">
      <div class="grand-total-box">
        Total Amount:
        <fmt:formatNumber value="${grandTotalFine}" type="number" maxFractionDigits="0"/> VND
      </div>
    </c:if>

    <button class="confirm-btn" onclick="confirmReturnToInvoice()">
      Continue
    </button>
  </div>
</div>

<script>
  function confirmReturnToInvoice() {
    window.location.href = '${pageContext.request.contextPath}/staff/ReturnInvoice.jsp';
  }

  function deleteItem(loanItemId) {
    fetch('${pageContext.request.contextPath}/returnItem?action=choose&loanItemId=' + loanItemId)
            .then(() => location.reload());
  }

  function chooseDamage(loanItemId) {
    window.location.href = '${pageContext.request.contextPath}/fine?action=listDamageFine&loanItemId=' + loanItemId;
  }
</script>

</body>
</html>