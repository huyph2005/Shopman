<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*, model.*, java.math.BigDecimal, java.sql.Date" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!(session.getAttribute("member") instanceof Manager1)) {
        response.sendRedirect("../member/LoginView1.jsp?err=timeout");
        return;
    }
    if (request.getParameter("startDate") != null) {
        // Nhận khoảng thời gian từ SelectDateRangeView1.jsp
        Date startDate = Date.valueOf(request.getParameter("startDate"));
        Date endDate = Date.valueOf(request.getParameter("endDate"));
        // Lấy thống kê doanh thu
        ProductRevenueStatDAO1 dao = new ProductRevenueStatDAO1();
        ProductRevenueStat1[] listStat = dao.getProductRevenueStat(startDate, endDate);
        if (listStat.length == 0) {
            // không có dữ liệu: quay lại SelectDateRangeView1.jsp kèm thông báo
            String url = "SelectDateRangeView1.jsp?err=nodata&inStartDate=" + startDate
                    + "&inEndDate=" + endDate;
            response.sendRedirect(url);
            return;
        }
        session.setAttribute("startDate", startDate);
        session.setAttribute("endDate", endDate);
        session.setAttribute("listStat", listStat);
    }
    // quay lại từ TransactionDetailView1.jsp: không có tham số, chỉ đọc lại từ session
    ProductRevenueStat1[] listStat = (ProductRevenueStat1[]) session.getAttribute("listStat");
    if (listStat == null) {
        response.sendRedirect("SelectDateRangeView1.jsp");
        return;
    }
    // Tính tổng cộng
    int totalQuantity = 0;
    BigDecimal totalRevenue = BigDecimal.ZERO;
    for (ProductRevenueStat1 stat : listStat) {
        totalQuantity += stat.getTotalQuantity();
        totalRevenue = totalRevenue.add(stat.getTotalRevenue());
    }
    pageContext.setAttribute("totalQuantity", totalQuantity);
    pageContext.setAttribute("totalRevenue", totalRevenue);
%>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thống kê mặt hàng theo doanh thu</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Thống kê mặt hàng theo doanh thu</h2>
<p id="outStatPeriod">Từ ngày: <b><fmt:formatDate value="${sessionScope.startDate}" pattern="dd/MM/yyyy"/></b>
   &nbsp; đến ngày: <b><fmt:formatDate value="${sessionScope.endDate}" pattern="dd/MM/yyyy"/></b></p>
<table id="outsubRevenueStatList" class="grid">
    <tr><th>STT</th><th>Mã hàng</th><th>Tên hàng</th><th class="right">SL bán</th><th class="right">Doanh thu (đ)</th></tr>
    <c:forEach var="stat" items="${sessionScope.listStat}" varStatus="i">
    <tr><td>${i.count}</td>
        <td><c:out value="${stat.code}"/></td>
        <td><a href="TransactionDetailView1.jsp?index=${i.index}">
            <c:out value="${stat.name}"/></a></td>
        <td class="right">${stat.totalQuantity}</td>
        <td class="right">
            <fmt:formatNumber value="${stat.totalRevenue}" pattern="#,##0"/></td></tr>
    </c:forEach>
    <tr id="outTotal"><td colspan="3" class="right"><b>Tổng cộng</b></td>
        <td class="right"><b>${totalQuantity}</b></td>
        <td class="right"><b><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></b></td></tr>
</table>
<p class="note">(click vào một dòng mặt hàng để xem chi tiết giao dịch)</p>
<input type="button" name="subBack" value="Quay lại" onclick="location.href='SelectDateRangeView1.jsp'">
</body>
</html>
