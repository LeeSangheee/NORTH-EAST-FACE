package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// Lightweight JDBC helper; overrides via env: DB_URL, DB_USER, DB_PASSWORD
public final class DBConnection {
    private static final String URL = envOrDefault("DB_URL",
            "jdbc:mysql://localhost:3306/north_east_face?serverTimezone=Asia/Seoul&characterEncoding=UTF-8");
    private static final String USER = envOrDefault("DB_USER", "root");
    private static final String PASSWORD = envOrDefault("DB_PASSWORD", "root");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL driver not found", e);
        }
    }

    private DBConnection() {
        // utility
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static String envOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? defaultValue : value;
    }
}
