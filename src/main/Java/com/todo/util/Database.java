package com.todo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Database {  // Class name must be Database

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Check for Railway Cloud Env Variables
            String cloudUrl = System.getenv("MYSQL_URL");
            String cloudUser = System.getenv("MYSQLUSER");
            String cloudPass = System.getenv("MYSQLPASSWORD");
            String cloudHost = System.getenv("MYSQLHOST");
            String cloudPort = System.getenv("MYSQLPORT");
            String cloudDb   = System.getenv("MYSQLDATABASE");

            if (cloudUrl != null) {
                return DriverManager.getConnection(cloudUrl, cloudUser, cloudPass);
            } else if (cloudHost != null) {
                String url = "jdbc:mysql://" + cloudHost + ":" + cloudPort + "/" + cloudDb;
                return DriverManager.getConnection(url, cloudUser, cloudPass);
            } else {
                // Localhost Fallback
                return DriverManager.getConnection("jdbc:mysql://localhost:3306/todo_app", "root", ""); 
            }
        } catch (ClassNotFoundException e) {
            throw new SQLException(e);
        }
    }
}