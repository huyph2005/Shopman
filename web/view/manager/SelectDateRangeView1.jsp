<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="model.*, java.time.LocalDate" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (!(session.getAttribute("member") instanceof Manager1)) {
        response.sendRedirect("../member/LoginView1.jsp?err=timeout");
        return;
    }
    String inStartDate = request.getParameter("inStartDate");
    String inEndDate = request.getParameter("inEndDate");
    String outMessage = null;
    if ("nodata".equals(request.getParameter("err"))) {
        // ProductRevenueStatView1.jsp quay lại vì không có dữ liệu
        outMessage = "Không có dữ liệu thống kê trong khoảng thời gian đã chọn";
    } else if (request.getParameter("subViewStatistics") != null) {
        // Kiểm tra khoảng thời gian: ngày kết thúc phải sau ngày bắt đầu
        try {
            if (!LocalDate.parse(inEndDate).isAfter(LocalDate.parse(inStartDate))) {
                outMessage = "Ngày kết thúc phải sau ngày bắt đầu";
            }
        } catch (Exception e) {
            outMessage = "Vui lòng chọn ngày bắt đầu và ngày kết thúc";
        }
        if (outMessage == null) {
            // hợp lệ: gọi trang thống kê
            String url = "ProductRevenueStatView1.jsp?startDate=" + inStartDate
                    + "&endDate=" + inEndDate;
            response.sendRedirect(url);
            return;
        }
    }
    pageContext.setAttribute("outMessage", outMessage);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thống kê mặt hàng theo doanh thu</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Thống kê mặt hàng theo doanh thu</h2>
<form action="SelectDateRangeView1.jsp" method="get">
<table class="form">
    <tr><td>Ngày bắt đầu:</td>
        <td><input type="date" name="inStartDate" value="<c:out value='${param.inStartDate}'/>"></td></tr>
    <tr><td>Ngày kết thúc:</td>
        <td><input type="date" name="inEndDate" value="<c:out value='${param.inEndDate}'/>"></td></tr>
    <c:if test="${not empty outMessage}">
        <tr><td></td><td id="outMessage" class="error"><c:out value="${outMessage}"/></td></tr>
    </c:if>
    <tr><td></td>
        <td><input type="submit" name="subViewStatistics" value="Xem thống kê">
            <input type="button" name="subBack" value="Quay lại" onclick="location.href='SelectReportView1.jsp'"></td></tr>
</table>
</form>
</body>
</html>
