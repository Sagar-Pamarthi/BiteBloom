
package com.tap.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = System.getenv("DB_URL");
            

    private static final String USERNAME = System.getenv("DB_USERNAME");
            

    private static final String PASSWORD = System.getenv("DB_PASSWORD");
            

    public static Connection getConnection() {

        if (URL == null || URL.isBlank()
                || USERNAME == null || USERNAME.isBlank()
                || PASSWORD == null || PASSWORD.isBlank()) {

            throw new IllegalStateException(
                "Database configuration missing. "
                + "Set DB_URL, DB_USERNAME and DB_PASSWORD."
            );
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(
                    URL, USERNAME, PASSWORD
            );

        } catch (SQLException | ClassNotFoundException e) {
            throw new IllegalStateException(
                    "Failed to connect to the database.", e
            );
        }
    }
}
