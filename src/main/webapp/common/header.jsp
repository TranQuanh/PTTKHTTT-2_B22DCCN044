<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .main-header {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height:40px; /* Nhỏ hơn, gọn hơn */
    background: #ffffff;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    display: flex;
    align-items: center;
    justify-content: center; /* Căn giữa chữ */
    font-size: 18px; /* Nhỏ hơn một chút */
    font-weight: 600;
    color: #333;
    z-index: 999;
    padding: 0 16px; /* Khoảng cách 2 bên */
    text-align: center;
  }

  /* Đẩy nội dung xuống dưới header + khoảng trống đều */
  body {
    margin: 0;
    padding-top: 70px; /* 50px header + 20px khoảng cách */
    background-color: #f4f7fb;
    font-family: 'Segoe UI', sans-serif;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }
</style>

<header class="main-header">
  Library System
</header>