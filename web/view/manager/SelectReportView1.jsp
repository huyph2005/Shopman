<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*" %>
<%
    if (!(session.getAttribute("member") instanceof Manager1)) {
        response.sendRedirect("../member/LoginView1.jsp?err=timeout");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chọn loại báo cáo</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Chọn loại báo cáo</h2>
<ul id="outsubReportTypeList">
    <li><a href="#">Thống kê hàng nhập</a></li>
    <li><a href="#">Thống kê hàng xuất</a></li>
    <li><a href="#">Thống kê khách hàng</a></li>
    <li><a href="#">Thống kê nhà cung cấp</a></li>
    <li><a href="SelectDateRangeView1.jsp"><b>Thống kê mặt hàng theo doanh thu</b></a></li>
</ul>
</body>
</html>
