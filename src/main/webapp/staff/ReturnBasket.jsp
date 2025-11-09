<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>Return Basket</title>
  <style>
    /* ... (CSS giữ nguyên) ... */
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
      max-width: 1000px;
      margin: 50px auto;
      box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    }
    .tabs {
      display: flex;
      justify-content: center;
      margin-bottom: 25px;
    }
    .tab {
      padding: 10px 30px;
      font-weight: bold;
      border: 1px solid #aaa;
      background-color: #e6e6e6;
      cursor: pointer;
    }
    .tab.active {
      background-color: #0099cc;
      color: white;
      border-color: #0099cc;
    }
    table {
      border-collapse: collapse;
      width: 100%;
      margin-top: 10px;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: center;
    }
    th {
      background-color: #f2f2f2;
    }
    tr:nth-child(even) {
      background-color: #fafafa;
    }
    .action-btn {
      padding: 5px 12px;
      border: none;
      border-radius: 4px;
      background-color: #0099cc;
      color: white;
      cursor: pointer;
      transition: background-color 0.25s;
    }
    .action-btn:hover {
      background-color: #0077cc;
    }
    .delete-btn {
      padding: 5px 12px;
      border: none;
      border-radius: 4px;
      background-color: #dc3545;
      color: white;
      cursor: pointer;
      transition: background-color 0.25s;
    }
    .delete-btn:hover {
      background-color: #c82333;
    }
    .fine-table {
      margin-top: 8px;
      border-collapse: collapse;
      width: 90%;
      margin-left: auto;
      margin-right: auto;
    }
    .fine-table th, .fine-table td {
      border: 1px solid #ccc;
      padding: 6px;
    }
    .fine-header {
      background-color: #e6f7ff;
      font-weight: bold;
      text-align: center;
    }
    .fine-section {
      margin-top: 20px;
      background-color: #f9f9f9;
      padding: 10px;
      border-radius: 8px;
      border: 1px solid #ddd;
    }
    /* Thêm style cho nút xóa ở cuối */
    .delete-container {
      text-align: right;
      margin-top: 15px;
    }
  </style>
</head>
<body>
<jsp:include page="/common/header.jsp" />

<div class="container">

  <div class="tabs">
    <div class="tab" onclick="window.location.href='${pageContext.request.contextPath}/loanItem?action=listByReader'">
      Borrow List
    </div>
    <div class="tab active">Return Basket</div>
  </div>

  <c:if test="${not empty requestScope.error}">
    <p style="color: red; text-align: center; font-weight: bold;">LỖI: ${requestScope.error}</p>
  </c:if>

  <c:if test="${not empty reader}">
    <table class="reader-info">
      <tr><th>Reader ID:</th><td>${reader.readerId}</td></tr>
      <tr><th>Reader Name:</th><td>${reader.fullName}</td></tr>
    </table>
  </c:if>

  <h3 style="text-align:center;">Danh sách tài liệu được chọn để trả</h3>

  <c:if test="${empty sessionScope.returnItems}">
    <p style="text-align:center;">Không có tài liệu nào được chọn để trả.</p>
  </c:if>

  <c:forEach var="item" items="${sessionScope.returnItems}">
    <div class="fine-section">
      <table>
        <tr>
          <th>Loan ID</th>
          <td>${item.loanItem.id}</td>
          <th>Book Title</th>
          <td>${item.loanItem.copy.document.title}</td>
        </tr>
        <tr>
          <th>Loan Date</th>
          <td>${item.loanItem.formattedLoanDate}</td>
          <th>Due Date</th>
          <td>${item.loanItem.formattedDueDate}</td>
        </tr>
        <tr>
          <th>Return Date</th>
          <td>${item.formattedReturnDate}</td>
        </tr>
      </table>

      <h4 style="text-align:center;margin-top:10px;">Late Fine</h4>
      <table class="fine-table">
        <thead class="fine-header">
        <tr>
          <th>Type</th>
          <th>Reason</th>
          <th>Late Days</th>
          <th>Amount/Day</th>
          <th>Total</th>
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
              <td>${fd.fine.amount}</td>
              <td>${fd.fine.amount * fd.quantity}</td>
            </tr>
          </c:if>
        </c:forEach>
        <c:if test="${not lateExists}">
          <tr><td colspan="5">Không có tiền phạt trễ hạn.</td></tr>
        </c:if>
        </tbody>
      </table>

      <h4 style="display: inline-block; margin-top:15px;">Damage Fine</h4>
      <div style="display: inline-block; margin-left: 20px;">
        <button class="action-btn" onclick="chooseDamage('${item.loanItem.id}')">Chọn Damage</button>
      </div>

      <table class="fine-table">
        <thead class="fine-header">
        <tr>
          <th>Type</th>
          <th>Reason</th>
          <th>Quantity</th>
          <th>Amount</th>
          <th>Total</th>
        </tr>
        </thead>
        <tbody>
        <c:set var="damageExists" value="false"/>
        <c:forEach var="fd" items="${item.fineDetails}">
          <c:if test="${fd.fine.type eq 'damage'}">
            <c:set var="damageExists" value="true"/>
            <tr>
              <td>${fd.fine.type}</td>
              <td>${fd.note}</td>
              <td>${fd.quantity}</td>
              <td>${fd.fine.amount}</td>
              <td>${fd.fine.amount * fd.quantity}</td>
            </tr>
          </c:if>
        </c:forEach>
        <c:if test="${not damageExists}">
          <tr><td colspan="5">Không có tiền phạt hư hỏng.</td></tr>
        </c:if>
        </tbody>
      </table>

      <div class="delete-container">
        <button class="delete-btn" onclick="deleteItem('${item.loanItem.id}')">Xóa Return Item</button>
      </div>

    </div>
  </c:forEach>

  <div style="text-align:center; margin-top: 25px;">
    <button class="action-btn" onclick="calculateFine()">Tính tiền phạt</button>
  </div>
</div>

<script>
  function calculateFine() {
    window.location.href = '${pageContext.request.contextPath}/fine?action=calculateLateFine';
  }

  function deleteItem(loanItemId) {
    fetch('${pageContext.request.contextPath}/returnItem?action=choose&loanItemId=' + loanItemId)
            .then(() => window.location.reload());
  }

  function chooseDamage(loanItemId) {
    window.location.href = '${pageContext.request.contextPath}/fine?action=listDamageFine&loanItemId=' + loanItemId;
  }
</script>

</body>
</html>