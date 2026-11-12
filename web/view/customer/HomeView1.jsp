<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang chủ ShopMan</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Trang chủ ShopMan</h2>
<form action="HomeView1.jsp" method="get">
    <input type="text" name="keyword" size="30" placeholder="Tìm kiếm hàng hóa...">
    <input type="submit" value="Tìm">
</form>
<p>
<c:choose>
    <c:when test="${not empty sessionScope.member}">
        Xin chào: <b><c:out value="${sessionScope.member.fullName.lastName} ${sessionScope.member.fullName.middleName} ${sessionScope.member.fullName.firstName}"/></b> |
        <a href="../member/doLogout1.jsp">Đăng xuất</a>
    </c:when>
    <c:otherwise>
        <a href="../member/LoginView1.jsp">Đăng nhập</a> |
        <a id="subRegister" href="RegisterView1.jsp"><b>Đăng ký thành viên</b></a>
    </c:otherwise>
</c:choose>
</p>
<p class="note">(danh mục hàng, hàng nổi bật...)</p>
</body>
</html>
