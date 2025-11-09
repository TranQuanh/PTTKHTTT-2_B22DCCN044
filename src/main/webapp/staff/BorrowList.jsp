<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Nếu servlet chưa gán loanItems, thì redirect đến /loanItem
    if (request.getAttribute("loanItems") == null) {
        response.sendRedirect(request.getContextPath() + "/loanItem");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Borrow List</title>
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
            max-width: 900px;
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

        .choose-btn {
            padding: 5px 12px;
            border: none;
            border-radius: 4px;
            background-color: #0099cc;
            color: white;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .choose-btn.selected {
            background-color: #dc3545;
        }

        .choose-btn:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container">

    <div class="tabs">
        <div class="tab active">Borrow List</div>
        <div class="tab" onclick="window.location.href = '${pageContext.request.contextPath}/fine?action=calculateLateFine'">
            Return Basket
        </div>
    </div>

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
        <c:forEach var="item" items="${loanItems}">
            <c:set var="isSelected" value="false" />
            <c:forEach var="ret" items="${sessionScope.returnItems}">
                <c:if test="${ret.loanItem.id == item.id}">
                    <c:set var="isSelected" value="true" />
                </c:if>
            </c:forEach>

            <tr>
                <td>${item.id}</td>
                <td>${item.copy.document.title}</td>
                <td>${item.loanDate}</td>
                <td>${item.dueDate}</td>
                <td>${item.copy.barCode}</td>
                <td>
                    <button class="choose-btn ${isSelected ? 'selected' : ''}"
                            onclick="toggleItem(this, '${item.id}')">
                            ${isSelected ? 'Bỏ chọn' : 'Chọn'}
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>

<script>
    function toggleItem(button, loanItemId) {
        fetch('${pageContext.request.contextPath}/returnItem?action=choose&loanItemId=' + loanItemId)
            .then(res => res.json())
            .then(() => {
                button.classList.toggle('selected');
                button.textContent = button.classList.contains('selected') ? 'Bỏ chọn' : 'Chọn';
            })
            .catch(err => console.error('Toggle error:', err));
    }
</script>

</body>
</html>
