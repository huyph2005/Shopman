<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="dao.*, model.*" %>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    Member1 member = new MemberDAO1().checkLogin(username, password);
    if (member == null) {
        response.sendRedirect("LoginView1.jsp?err=fail");
    } else {
        session.setAttribute("member", member);
        if (member instanceof Manager1) {
            response.sendRedirect("../manager/ManagerHomeView1.jsp");
        } else {
            response.sendRedirect("../customer/HomeView1.jsp");
        }
    }
%>
