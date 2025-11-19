<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession currentSession = request.getSession(false);

    if (currentSession != null && currentSession.getAttribute("userId") != null) {
        // CASE A: User is already logged in
        response.sendRedirect("tasks");
    } else {  
        // CASE B: User is not logged in (Guest)
        response.sendRedirect("login.jsp");
    }
%>