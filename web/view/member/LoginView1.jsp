<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng nhập</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Đăng nhập</h2>
<c:if test="${param.err == 'fail'}"><p class="error">Sai tên đăng nhập hoặc mật khẩu!</p></c:if>
<c:if test="${param.err == 'timeout'}"><p class="error">Hết phiên làm việc, vui lòng đăng nhập lại!</p></c:if>
<form action="doLogin1.jsp" method="post">
<table class="form">
    <tr><td>Tên đăng nhập:</td><td><input type="text" name="username" required></td></tr>
    <tr><td>Mật khẩu:</td><td><input type="password" name="password" required></td></tr>
    <tr><td></td><td><input type="submit" value="Đăng nhập">
        <input type="button" value="Quay lại" onclick="location.href='../customer/HomeView1.jsp'"></td></tr>
</table>
</form>
</body>
</html>
