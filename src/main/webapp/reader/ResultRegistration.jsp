<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }
        .box {
            width: 360px;
            margin: 80px auto;
            padding: 25px;
            text-align: center;
            background: #ffffff;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .btn {
            padding: 6px 20px;
            background: #21a1e6;
            border: none;
            border-radius: 3px;
            color: white;
            cursor: pointer;
        }
        .btn:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>

<div class="box">
    <h4>Register reader card successfully</h4>
    <br>
    <form action="<%= request.getContextPath() %>/reader/ReaderHome.jsp" method="get">
        <button class="btn" type="submit">back to menu</button>
    </form>
</div>

</body>
</html>
