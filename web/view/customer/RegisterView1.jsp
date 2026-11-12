<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Khi doRegister1.jsp quay lại kèm thông báo lỗi: outMessage là nội dung lỗi, errField là ô bị lỗi.
     Các ô giữ nguyên giá trị đã nhập (param), riêng hai ô mật khẩu bị xóa trống khi mật khẩu nhập lại không khớp. --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng ký thành viên</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Đăng ký thành viên</h2>
<c:if test="${not empty outMessage and empty errField}">
    <p id="outMessage" class="error"><c:out value="${outMessage}"/></p>
</c:if>
<form action="doRegister1.jsp" method="post">
<table class="form">
    <tr><td>Họ / Tên đệm / Tên:</td>
        <td><input type="text" name="inLastName" class="w3" value="${fn:escapeXml(param.inLastName)}">
            <input type="text" name="inMiddleName" class="w3" value="${fn:escapeXml(param.inMiddleName)}">
            <input type="text" name="inFirstName" class="w3" value="${fn:escapeXml(param.inFirstName)}"></td></tr>
    <tr><td>Tên đăng nhập:</td>
        <td><input type="text" name="inUsername" value="${fn:escapeXml(param.inUsername)}"></td></tr>
    <c:if test="${errField == 'username'}">
        <tr><td></td><td id="outMessage" class="error"><c:out value="${outMessage}"/></td></tr>
    </c:if>
    <tr><td>Mật khẩu:</td>
        <td><input type="password" name="inPassword"
                   value="${errField == 'password' ? '' : fn:escapeXml(param.inPassword)}"></td></tr>
    <tr><td>Nhập lại mật khẩu:</td>
        <td><input type="password" name="inRetypePassword"
                   value="${errField == 'password' ? '' : fn:escapeXml(param.inRetypePassword)}"></td></tr>
    <c:if test="${errField == 'password'}">
        <tr><td></td><td id="outMessage" class="error"><c:out value="${outMessage}"/></td></tr>
    </c:if>
    <tr><td>Email:</td>
        <td><input type="text" name="inEmail" value="${fn:escapeXml(param.inEmail)}"></td></tr>
    <c:if test="${errField == 'email'}">
        <tr><td></td><td id="outMessage" class="error"><c:out value="${outMessage}"/></td></tr>
    </c:if>
    <tr><td>Số điện thoại:</td>
        <td><input type="text" name="inTel" value="${fn:escapeXml(param.inTel)}"></td></tr>
    <c:if test="${errField == 'tel'}">
        <tr><td></td><td id="outMessage" class="error"><c:out value="${outMessage}"/></td></tr>
    </c:if>
    <tr><td>Số nhà:</td>
        <td><input type="text" name="inHouseNumber" class="w2" value="${fn:escapeXml(param.inHouseNumber)}">
            <span class="label2">Đường/Phố:</span>
            <input type="text" name="inStreet" class="w2b" value="${fn:escapeXml(param.inStreet)}"></td></tr>
    <tr><td>Phường/Xã:</td>
        <td><input type="text" name="inWard" class="w2" value="${fn:escapeXml(param.inWard)}">
            <span class="label2">Quận/Huyện:</span>
            <input type="text" name="inDistrict" class="w2b" value="${fn:escapeXml(param.inDistrict)}"></td></tr>
    <tr><td>Tỉnh/Thành phố:</td>
        <td><input type="text" name="inCity" value="${fn:escapeXml(param.inCity)}"></td></tr>
    <tr><td></td>
        <td><input type="submit" name="subRegister" value="Đăng ký">
            <input type="button" name="subCancel" value="Huỷ" onclick="location.href='HomeView1.jsp'"></td></tr>
</table>
</form>
</body>
</html>
