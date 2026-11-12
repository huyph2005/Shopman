<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*, model.*" %>
<%
    // Các bước xử lý theo biểu đồ hoạt động của module Đăng ký thành viên
    if (request.getParameter("inUsername") == null) {
        response.sendRedirect("RegisterView1.jsp");
        return;
    }

    // Nhận thông tin đăng ký
    String inLastName = request.getParameter("inLastName").trim();
    String inMiddleName = request.getParameter("inMiddleName").trim();
    String inFirstName = request.getParameter("inFirstName").trim();
    String inUsername = request.getParameter("inUsername").trim();
    String inPassword = request.getParameter("inPassword");
    String inRetypePassword = request.getParameter("inRetypePassword");
    String inEmail = request.getParameter("inEmail").trim();
    String inTel = request.getParameter("inTel").trim();
    String inHouseNumber = request.getParameter("inHouseNumber").trim();
    String inStreet = request.getParameter("inStreet").trim();
    String inWard = request.getParameter("inWard").trim();
    String inDistrict = request.getParameter("inDistrict").trim();
    String inCity = request.getParameter("inCity").trim();

    String outMessage = null;   // thông báo lỗi
    String errField = "";       // ô bị lỗi, để hiện thông báo ngay dưới ô đó

    // Kiểm tra dữ liệu nhập: đủ các ô (trừ tên đệm), email đúng định dạng,
    // mật khẩu nhập lại khớp
    if (inLastName.isEmpty() || inFirstName.isEmpty() || inUsername.isEmpty()
            || inPassword.isEmpty() || inRetypePassword.isEmpty() || inEmail.isEmpty()
            || inTel.isEmpty() || inHouseNumber.isEmpty() || inStreet.isEmpty()
            || inWard.isEmpty() || inDistrict.isEmpty() || inCity.isEmpty()) {
        outMessage = "Vui lòng nhập đầy đủ các thông tin bắt buộc";
    } else if (!inEmail.matches("[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+")) {
        outMessage = "Email không đúng định dạng";
        errField = "email";
    } else if (!inPassword.equals(inRetypePassword)) {
        outMessage = "Mật khẩu nhập lại không khớp";
        errField = "password";
    }

    if (outMessage == null) {
        // Đóng gói thông tin khách hàng
        FullName1 fullName = new FullName1();
        fullName.setLastName(inLastName);
        fullName.setMiddleName(inMiddleName);
        fullName.setFirstName(inFirstName);
        Address1 address = new Address1();
        address.setHouseNumber(inHouseNumber);
        address.setStreet(inStreet);
        address.setWard(inWard);
        address.setDistrict(inDistrict);
        address.setCity(inCity);
        Customer1 customer = new Customer1();
        customer.setUsername(inUsername);
        customer.setPassword(inPassword);
        customer.setEmail(inEmail);
        customer.setTel(inTel);
        customer.setFullName(fullName);
        customer.setAddress(address);

        // Kiểm tra thông tin đã tồn tại
        String exist = new MemberDAO1().checkMemberExist(customer);
        if ("email".equals(exist)) {
            outMessage = "Email đã được sử dụng, vui lòng nhập email khác";
            errField = "email";
        } else if ("username".equals(exist)) {
            outMessage = "Tên đăng nhập đã được sử dụng, vui lòng chọn tên khác";
            errField = "username";
        } else if ("tel".equals(exist)) {
            outMessage = "Số điện thoại đã được sử dụng, vui lòng nhập số khác";
            errField = "tel";
        } else if (!new CustomerDAO1().addCustomer(customer)) {
            // Lưu thông tin khách hàng không thành công
            outMessage = "Lưu thông tin không thành công, vui lòng thử lại";
        }
    }

    if (outMessage != null) {
        // quay lại RegisterView1.jsp kèm thông báo lỗi, giữ nguyên thông tin đã nhập
        request.setAttribute("outMessage", outMessage);
        request.setAttribute("errField", errField);
        request.getRequestDispatcher("RegisterView1.jsp").forward(request, response);
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng ký thành công</title>
<link rel="stylesheet" href="../../style.css">
</head>
<body>
<%-- Thông báo đăng ký thành công --%>
<h2 id="outMessage">Đăng ký thành công!</h2>
<input type="button" name="subOK" value="OK" onclick="location.href='HomeView1.jsp'">
</body>
</html>
