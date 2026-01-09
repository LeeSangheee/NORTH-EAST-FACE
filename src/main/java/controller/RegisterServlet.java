package controller;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = trim(request.getParameter("username"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String password = trim(request.getParameter("password"));
        String confirm = trim(request.getParameter("confirm"));

        if (isBlank(username) || isBlank(email) || isBlank(phone) || isBlank(password) || isBlank(confirm)) {
            request.setAttribute("error", "모든 필드를 입력해 주세요.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // 아이디 유효성: 영문자, 숫자만
        if (!username.matches("^[a-zA-Z0-9]+$")) {
            request.setAttribute("error", "아이디는 영문자와 숫자만 사용 가능합니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("error", "비밀번호 확인이 일치하지 않습니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "비밀번호는 6자 이상이어야 합니다.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        String hash = hashSha256(password);

        // 중복 체크: username과 email 각각 확인
        String checkUsernameSql = "SELECT COUNT(*) FROM member WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkUsernameSql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    request.setAttribute("error", "이미 사용 중인 아이디입니다.");
                    request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                    return;
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "DB 오류: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        String checkEmailSql = "SELECT COUNT(*) FROM member WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkEmailSql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    request.setAttribute("error", "이미 사용 중인 이메일입니다.");
                    request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                    return;
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "DB 오류: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // 가입 처리
        String sql = "INSERT INTO member (username, password_hash, email, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, hash);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();
            request.setAttribute("success", "가입이 완료되었습니다. 로그인해 주세요.");
            // 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        } catch (SQLException e) {
            request.setAttribute("error", "DB 오류: " + e.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    private String hashSha256(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes());
            StringBuilder sb = new StringBuilder(hash.length * 2);
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }

    private boolean isDuplicateKey(SQLException e) {
        // MySQL duplicate key uses SQLState 23000
        return "23000".equals(e.getSQLState());
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
