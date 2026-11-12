<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (!(session.getAttribute("member") instanceof Manager1)) {
        response.sendRedirect("../member/LoginView1.jsp?err=timeout");
        return;
    }
    Manager1 manager = (Manager1) session.getAttribute("member");
    pageContext.setAttribute("manager", manager);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang chủ nhân viên quản lý</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Trang chủ nhân viên quản lý</h2>
<p>Xin chào: <b><c:out value="${manager.fullName.lastName} ${manager.fullName.middleName} ${manager.fullName.firstName}"/></b></p>
<ul>
    <li><a id="subViewReport" href="SelectReportView1.jsp"><b>Xem báo cáo</b></a></li>
    <li><a href="#">Quản lý thông tin hàng hóa</a></li>
    <li><a href="#">Quản lý thông tin nhà cung cấp</a></li>
    <li><a href="#">Nhập hàng</a></li>
    <li><a href="../member/doLogout1.jsp">Đăng xuất</a></li>
</ul>
</body>
</html>
