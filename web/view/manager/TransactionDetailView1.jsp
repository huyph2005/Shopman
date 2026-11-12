<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*, model.*, java.math.BigDecimal, java.util.Date" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (!(session.getAttribute("member") instanceof Manager1)) {
        response.sendRedirect("../member/LoginView1.jsp?err=timeout");
        return;
    }
    ProductRevenueStat1[] listStat = (ProductRevenueStat1[]) session.getAttribute("listStat");
    if (listStat == null || request.getParameter("index") == null) {
        response.sendRedirect("ProductRevenueStatView1.jsp");
        return;
    }
    // nhận mặt hàng được chọn (vị trí index trong listStat) và khoảng thời gian
    Product1 product = listStat[Integer.parseInt(request.getParameter("index"))];
    Date startDate = (Date) session.getAttribute("startDate");
    Date endDate = (Date) session.getAttribute("endDate");
    // Lấy các lần giao dịch
    InvoiceDetailDAO1 dao = new InvoiceDetailDAO1();
    InvoiceDetail1[] listDetail = dao.getInvoiceDetailOfProduct(product, startDate, endDate);
    // Tính tổng cộng
    int totalQuantity = 0;
    BigDecimal totalAmount = BigDecimal.ZERO;
    for (InvoiceDetail1 detail : listDetail) {
        totalQuantity += detail.getQuantity();
        BigDecimal quantity = BigDecimal.valueOf(detail.getQuantity());
        totalAmount = totalAmount.add(detail.getUnitPrice().multiply(quantity));
    }
    pageContext.setAttribute("product", product);
    pageContext.setAttribute("listDetail", listDetail);
    pageContext.setAttribute("totalQuantity", totalQuantity);
    pageContext.setAttribute("totalAmount", totalAmount);
%>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chi tiết giao dịch mặt hàng</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<h2>Chi tiết giao dịch mặt hàng</h2>
<p id="outProductName">Mặt hàng: <b><c:out value="${product.code}"/> – <c:out value="${product.name}"/></b>
   &nbsp;(<fmt:formatDate value="${sessionScope.startDate}" pattern="dd/MM/yyyy"/> –
   <fmt:formatDate value="${sessionScope.endDate}" pattern="dd/MM/yyyy"/>)</p>
<table id="outTransactionList" class="grid">
    <tr><th>STT</th><th>Mã HĐ</th><th>Ngày</th><th>Khách hàng</th><th>SL</th>
        <th class="right">Đơn giá</th><th class="right">Thành tiền</th></tr>
    <c:forEach var="detail" items="${listDetail}" varStatus="i">
    <tr><td>${i.count}</td>
        <td><c:out value="${detail.invoice.code}"/></td>
        <td><fmt:formatDate value="${detail.invoice.orderDate}" pattern="dd/MM/yyyy"/></td>
        <td><c:out value="${detail.invoice.customer.fullName.lastName} ${detail.invoice.customer.fullName.middleName} ${detail.invoice.customer.fullName.firstName}"/></td>
        <td>${detail.quantity}</td>
        <td class="right"><fmt:formatNumber value="${detail.unitPrice}" pattern="#,##0"/></td>
        <td class="right"><fmt:formatNumber value="${detail.unitPrice * detail.quantity}" pattern="#,##0"/></td></tr>
    </c:forEach>
    <tr id="outTotal"><td colspan="4" class="right"><b>Tổng cộng</b></td>
        <td><b>${totalQuantity}</b></td><td></td>
        <td class="right"><b><fmt:formatNumber value="${totalAmount}" pattern="#,##0"/></b></td></tr>
</table>
<p><input type="button" name="subBack" value="Quay lại" onclick="location.href='ProductRevenueStatView1.jsp'"></p>
</body>
</html>
