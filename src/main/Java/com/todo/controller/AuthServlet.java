package com.todo.controller;

import com.todo.util.Database; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");

            try (Connection conn = Database.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT id, username FROM users WHERE username = ? AND password = ?")) {
                
                ps.setString(1, user);
                ps.setString(2, pass);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("username", rs.getString("username"));
                    response.sendRedirect("tasks");
                } else {
                    response.sendRedirect("login.jsp?error=invalid");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect("login.jsp?error=db");
            }

        } else if ("register".equals(action)) {
             String user = request.getParameter("username");
             String pass = request.getParameter("password");

            
             try (Connection conn = Database.getConnection();
                  PreparedStatement ps = conn.prepareStatement("INSERT INTO users (username, password) VALUES (?, ?)")) {
                 
                 ps.setString(1, user);
                 ps.setString(2, pass);
                 ps.executeUpdate();
                 response.sendRedirect("login.jsp?message=created");
                 
             } catch (SQLException e) {
                 e.printStackTrace();
                 response.sendRedirect("register.jsp?error=exists");
             }
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession();
            session.invalidate(); 
            response.sendRedirect("login.jsp");
        }
    }
}