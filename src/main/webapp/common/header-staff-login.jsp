<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.librarysystem.model.Staff" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    String staffName = (staff != null) ? staff.getFullName() : "Guest";
%>
<style>
    /* === ĐỒNG BỘ HOÀN TOÀN VỚI HEADER CŨ === */
    .staff-header {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 40px; /* Giống header cũ */
        background: #ffffff;
        box-shadow: 0 2px 6px rgba(0,0,0,0.15); /* Giống hệt */
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 16px; /* Giống header cũ */
        z-index: 999;
        font-family: 'Segoe UI', Arial, sans-serif;
        font-size: 18px; /* Giống header cũ */
        font-weight: 600;
        color: #333; /* Giống header cũ */
    }

    /* TRÁI: TÊN HỆ THỐNG */
    .header-left {
        display: flex;
        align-items: center;
    }

    .system-name {
        color: #005b96;
        font-weight: 600;
        font-size: 18px;
        letter-spacing: 0.3px;
    }

    /* GIỮA: TÊN STAFF */
    .staff-info {
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
        font-size: 15px;
        color: #555;
        font-weight: 500;
    }

    .staff-name {
        color: #d63384;
        font-weight: 600;
    }

    /* PHẢI: NÚT LOGOUT */
    .header-right {
        display: flex;
        align-items: center;
    }

    .logout-btn {
        background: #dc3545;
        color: white;
        border: none;
        padding: 5px 14px;
        border-radius: 4px;
        font-size: 13.5px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        text-decoration: none;
        display: inline-block;
    }

    .logout-btn:hover {
        background: #c82333;
        transform: translateY(-1px);
        box-shadow: 0 2px 4px rgba(220,53,69,0.3);
    }

    /* === ĐẨY NỘI DUNG XUỐNG DƯỚI HEADER === */
    body {
        margin: 0;
        padding-top: 50px; /* 40px header + 30px gap (tăng để đẹp hơn) */
        background-color: #f4f7fb;
        min-height: 100vh;
        font-family: 'Segoe UI', Arial, sans-serif;
    }

    /* === RESPONSIVE NHỎ === */
    @media (max-width: 768px) {
        .staff-info {
            display: none; /* Ẩn tên staff trên mobile */
        }
        .staff-header {
            justify-content: space-between;
        }
        .system-name {
            font-size: 16px;
        }
        .logout-btn {
            padding: 4px 10px;
            font-size: 13px;
        }
    }

    @media (max-width: 480px) {
        .staff-header {
            padding: 0 12px;
        }
        .system-name {
            font-size: 15px;
        }
    }
</style>

<header class="staff-header">
    <!-- TRÁI: TÊN HỆ THỐNG -->
    <div class="header-left">
        <div class="system-name">Library Management</div>
    </div>

    <!-- GIỮA: TÊN STAFF (CĂN CHÍNH GIỮA) -->
    <div class="staff-info">
        Welcome, <span class="staff-name"><%= staffName %></span>
    </div>

    <!-- PHẢI: NÚT ĐĂNG XUẤT -->
    <div class="header-right">
        <form action="<%= request.getContextPath() %>/staff/StaffLogin.jsp" method="post" style="margin:0;">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>
</header>