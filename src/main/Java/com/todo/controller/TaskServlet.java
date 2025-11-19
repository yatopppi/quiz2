package com.todo.controller;

import com.todo.util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String categoryParam = request.getParameter("category");
        Integer selectedCategoryId = (categoryParam != null && !categoryParam.isEmpty()) ? Integer.parseInt(categoryParam) : null;

        List<Map<String, Object>> tasks = new ArrayList<>();
        List<Map<String, Object>> categories = new ArrayList<>();

        try (Connection conn = DBUtil.getConnection()) {
            // 1. Fetch Categories
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM categories WHERE user_id = ?")) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> cat = new HashMap<>();
                    cat.put("id", rs.getInt("id"));
                    cat.put("name", rs.getString("name"));
                    categories.add(cat);
                }
            }

            // 2. Fetch Tasks (UPDATED to include category_id)
            String finalSql = "SELECT * FROM tasks WHERE user_id = ?";
            if (selectedCategoryId != null) finalSql += " AND category_id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(finalSql)) {
                ps.setInt(1, userId);
                if (selectedCategoryId != null) ps.setInt(2, selectedCategoryId);
                
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> task = new HashMap<>();
                    task.put("id", rs.getInt("id"));
                    task.put("title", rs.getString("title"));
                    task.put("isCompleted", rs.getBoolean("is_completed"));
                    // CRITICAL: Pass the current category ID to the JSP
                    task.put("categoryId", rs.getObject("category_id")); 
                    tasks.add(task);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        request.setAttribute("taskList", tasks);
        request.setAttribute("categoryList", categories);
        request.setAttribute("currentCat", selectedCategoryId);
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String redirectUrl = "tasks"; 
        // Preserve current view
        String currentCat = request.getParameter("currentCat");
        if(currentCat != null && !currentCat.isEmpty()) redirectUrl += "?category=" + currentCat;

        try (Connection conn = DBUtil.getConnection()) {
            if ("add".equals(action)) {
                // Add Task Logic
                String title = request.getParameter("title");
                String catId = request.getParameter("categoryId");
                PreparedStatement ps = conn.prepareStatement("INSERT INTO tasks (title, user_id, category_id) VALUES (?, ?, ?)");
                ps.setString(1, title);
                ps.setInt(2, userId);
                if (catId != null && !catId.isEmpty()) ps.setInt(3, Integer.parseInt(catId));
                else ps.setNull(3, java.sql.Types.INTEGER);
                ps.executeUpdate();

            } else if ("delete".equals(action)) {
                // Delete Task Logic
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = conn.prepareStatement("DELETE FROM tasks WHERE id = ? AND user_id = ?");
                ps.setInt(1, id);
                ps.setInt(2, userId);
                ps.executeUpdate();

            } else if ("toggle".equals(action)) {
                // Toggle Checkbox Logic
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement ps = conn.prepareStatement("UPDATE tasks SET is_completed = NOT is_completed WHERE id = ? AND user_id = ?");
                ps.setInt(1, id);
                ps.setInt(2, userId);
                ps.executeUpdate();

            } else if ("addCategory".equals(action)) {
                // Add Category Logic
                String name = request.getParameter("categoryName");
                PreparedStatement ps = conn.prepareStatement("INSERT INTO categories (name, user_id) VALUES (?, ?)");
                ps.setString(1, name);
                ps.setInt(2, userId);
                ps.executeUpdate();
                
            } else if ("deleteCategory".equals(action)) {
                // Delete Category Logic
                int catId = Integer.parseInt(request.getParameter("id"));
                PreparedStatement unlink = conn.prepareStatement("UPDATE tasks SET category_id = NULL WHERE category_id = ? AND user_id = ?");
                unlink.setInt(1, catId);
                unlink.setInt(2, userId);
                unlink.executeUpdate();

                PreparedStatement del = conn.prepareStatement("DELETE FROM categories WHERE id = ? AND user_id = ?");
                del.setInt(1, catId);
                del.setInt(2, userId);
                del.executeUpdate();
                redirectUrl = "tasks"; // Must reset to "All tasks" view
                
            } else if ("updateCategory".equals(action)) {
                // --- NEW FEATURE: Re-assign Category ---
                int id = Integer.parseInt(request.getParameter("id"));
                String newCatId = request.getParameter("newCategoryId");

                PreparedStatement ps = conn.prepareStatement("UPDATE tasks SET category_id = ? WHERE id = ? AND user_id = ?");
                
                if (newCatId != null && !newCatId.isEmpty()) {
                    ps.setInt(1, Integer.parseInt(newCatId)); // Assign
                } else {
                    ps.setNull(1, java.sql.Types.INTEGER); // Remove (Uncategorized)
                }
                
                ps.setInt(2, id);
                ps.setInt(3, userId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        response.sendRedirect(redirectUrl);
    }
}