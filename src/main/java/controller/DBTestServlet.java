package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/db-test")
public class DBTestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");
        String status;
        String details;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT 1");
             ResultSet rs = ps.executeQuery()) {
            boolean ok = rs.next() && rs.getInt(1) == 1;
            status = ok ? "OK" : "FAIL";
            details = "Connected to DB and SELECT 1 returned " + (ok ? "1" : "unexpected value");
        } catch (SQLException e) {
            status = "ERROR";
            details = e.getMessage();
        }

        try (PrintWriter out = resp.getWriter()) {
            out.println("<html><head><title>DB Test</title></head><body>");
            out.println("<h3>DB Connection Test</h3>");
            out.println("<p>Status: <strong>" + escape(status) + "</strong></p>");
            out.println("<p>Details: " + escape(details) + "</p>");
            out.println("<p>Using URL: " + escape(getEnvOrFallback("DB_URL", "jdbc:mysql://localhost:3306/north_east_face")) + "</p>");
            out.println("</body></html>");
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String getEnvOrFallback(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? fallback : value;
    }
}
