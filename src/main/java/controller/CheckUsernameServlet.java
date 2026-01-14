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

@WebServlet("/api/check-username")
public class CheckUsernameServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String username = trim(request.getParameter("username"));

        if (isBlank(username)) {
            sendJson(response, 400, "username required");
            return;
        }

        String sql = "SELECT 1 FROM members WHERE username = ? OR email = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                boolean exists = rs.next();
                sendJson(response, 200, exists ? "already used" : "available");
            }
        } catch (SQLException e) {
            sendJson(response, 500, "DB error: " + e.getMessage());
        }
    }

    private void sendJson(HttpServletResponse resp, int code, String message) throws IOException {
        resp.setStatus(code);
        try (PrintWriter out = resp.getWriter()) {
            out.println("{\"status\":" + code + ",\"message\":\"" + escape(message) + "\"}");
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
