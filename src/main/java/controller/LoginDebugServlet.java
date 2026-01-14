package controller;

import java.io.IOException;
import java.io.PrintWriter;
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

/**
 * 로그인 디버깅 도구
 * /login-debug?username=test&password=test123456
 */
@WebServlet("/login-debug")
public class LoginDebugServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<html><head><title>Login Debug</title><style>");
            out.println("body { font-family: monospace; margin: 20px; }");
            out.println("table { border-collapse: collapse; width: 100%; }");
            out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            out.println("th { background-color: #f2f2f2; }");
            out.println(".success { background-color: #d4edda; }");
            out.println(".error { background-color: #f8d7da; }");
            out.println("</style></head><body>");
            
            out.println("<h2>로그인 디버그 도구</h2>");
            out.println("<p><a href=\"/db-test\">← DB 연결 테스트</a></p>");
            
            // DB 연결 확인
            try (Connection conn = DBConnection.getConnection()) {
                out.println("<p class='success'>✓ DB 연결 성공</p>");
            } catch (SQLException e) {
                out.println("<p class='error'>✗ DB 연결 실패: " + escape(e.getMessage()) + "</p>");
                return;
            }
            
            // 전체 회원 목록 표시
            out.println("<h3>1. 데이터베이스의 모든 회원</h3>");
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT member_id, username, email, password_hash FROM member");
                 ResultSet rs = ps.executeQuery()) {
                
                if (!rs.next()) {
                    out.println("<p class='error'>회원 데이터가 없습니다.</p>");
                } else {
                    out.println("<table>");
                    out.println("<tr><th>member_id</th><th>username</th><th>email</th><th>password_hash (처음 20자)</th></tr>");
                    rs.beforeFirst();
                    while (rs.next()) {
                        String hash = rs.getString("password_hash");
                        String shortHash = hash != null && hash.length() > 20 ? hash.substring(0, 20) + "..." : hash;
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("member_id") + "</td>");
                        out.println("<td>" + escape(rs.getString("username")) + "</td>");
                        out.println("<td>" + escape(rs.getString("email")) + "</td>");
                        out.println("<td>" + escape(shortHash) + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }
            } catch (SQLException e) {
                out.println("<p class='error'>회원 조회 오류: " + escape(e.getMessage()) + "</p>");
            }
            
            // 로그인 시뮬레이션
            if (username != null && !username.isEmpty() && password != null && !password.isEmpty()) {
                out.println("<h3>2. 로그인 시뮬레이션</h3>");
                out.println("<p>입력한 아이디: <strong>" + escape(username) + "</strong></p>");
                out.println("<p>입력한 비밀번호: <strong>" + escape(password) + "</strong></p>");
                
                String passwordHash = hashSha256(password);
                out.println("<p>계산된 해시: <strong>" + passwordHash + "</strong></p>");
                
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(
                             "SELECT member_id, username, password_hash FROM members WHERE (username = ? OR email = ?) AND password_hash = ?")) {
                    ps.setString(1, username);
                    ps.setString(2, username);
                    ps.setString(3, passwordHash);
                    
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            out.println("<p class='success'>✓ 로그인 성공!</p>");
                            out.println("<table>");
                            out.println("<tr><th>member_id</th><th>username</th></tr>");
                            out.println("<tr><td>" + rs.getInt("member_id") + "</td><td>" + escape(rs.getString("username")) + "</td></tr>");
                            out.println("</table>");
                        } else {
                            out.println("<p class='error'>✗ 로그인 실패 - 일치하는 사용자가 없습니다.</p>");
                            
                            // 해시 일치 여부 확인
                            try (PreparedStatement ps2 = conn.prepareStatement(
                                    "SELECT member_id, username, password_hash FROM members WHERE username = ? OR email = ?")) {
                                ps2.setString(1, username);
                                ps2.setString(2, username);
                                try (ResultSet rs2 = ps2.executeQuery()) {
                                    if (rs2.next()) {
                                        String dbHash = rs2.getString("password_hash");
                                        out.println("<p>같은 이름의 사용자는 있지만 비밀번호가 일치하지 않습니다.</p>");
                                        out.println("<table>");
                                        out.println("<tr><th>항목</th><th>값</th></tr>");
                                        out.println("<tr><td>DB의 해시</td><td>" + escape(dbHash) + "</td></tr>");
                                        out.println("<tr><td>입력의 해시</td><td>" + passwordHash + "</td></tr>");
                                        out.println("<tr><td>일치 여부</td><td class='error'>" + (dbHash.equals(passwordHash) ? "일치" : "불일치") + "</td></tr>");
                                        out.println("</table>");
                                    }
                                }
                            }
                        }
                    }
                } catch (SQLException e) {
                    out.println("<p class='error'>조회 오류: " + escape(e.getMessage()) + "</p>");
                }
            } else {
                out.println("<h3>2. 로그인 시뮬레이션</h3>");
                out.println("<p>테스트하려면 쿼리 파라미터를 추가하세요:</p>");
                out.println("<p><code>/login-debug?username=test&password=test123456</code></p>");
            }
            
            out.println("<hr>");
            out.println("<p><strong>테스트 단계:</strong></p>");
            out.println("<ol>");
            out.println("<li>먼저 회원가입으로 테스트 계정을 만들어주세요.</li>");
            out.println("<li>위의 '1. 데이터베이스의 모든 회원' 목록에서 확인하세요.</li>");
            out.println("<li>그 다음 쿼리 파라미터를 추가해서 로그인을 테스트하세요.</li>");
            out.println("</ol>");
            
            out.println("</body></html>");
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
    
    private String escape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
