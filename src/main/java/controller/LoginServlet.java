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
import javax.servlet.http.HttpSession;

import util.DBConnection;
import util.JwtUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String email = trim(request.getParameter("email"));
        String password = trim(request.getParameter("password"));

        if (isBlank(email) || isBlank(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("error", "이메일과 비밀번호를 입력해 주세요.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String passwordHash = hashSha256(password);
        String sql = "SELECT member_id, username FROM member WHERE email = ? AND password_hash = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // 로그인 성공
                    long memberId = rs.getLong("member_id");
                    String loginUsername = rs.getString("username");
                    
                    // JWT 토큰 생성
                    String jwtToken = JwtUtil.generateToken(loginUsername, memberId);
                    
                    // HttpOnly 쿠키에 JWT 토큰 저장
                    javax.servlet.http.Cookie jwtCookie = new javax.servlet.http.Cookie("jwtToken", jwtToken);
                    jwtCookie.setHttpOnly(true);    // JavaScript로 접근 불가
                    jwtCookie.setSecure(false);     // 로컬 개발용 (프로덕션에서는 true)
                    jwtCookie.setPath("/");         // 전체 애플리케이션에서 사용 가능
                    jwtCookie.setMaxAge(86400);     // 24시간
                    response.addCookie(jwtCookie);
                    
                    // 이전 페이지로 이동 (없으면 홈으로)
                    String referer = request.getHeader("referer");
                    if (referer != null && !referer.contains("/login") && !referer.contains("/register")) {
                        response.sendRedirect(referer);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/");
                    }
                    return;
                } else {
                    // 로그인 실패 - 디버그 정보 추가
                    System.out.println("[DEBUG] 로그인 실패 - 입력값: email=" + email + ", password hash=" + passwordHash);
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "이메일 또는 비밀번호가 일치하지 않습니다.");
                    response.sendRedirect(request.getContextPath() + "/login");
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] 로그인 중 DB 오류: " + e.getMessage());
            e.printStackTrace();
            HttpSession session = request.getSession();
            session.setAttribute("error", "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            response.sendRedirect(request.getContextPath() + "/login");
        }
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

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
