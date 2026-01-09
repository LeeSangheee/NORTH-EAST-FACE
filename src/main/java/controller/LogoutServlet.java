package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doLogout(request, response);
    }
    
    private void doLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        // JWT 쿠키 삭제 (MaxAge를 0으로 설정하여 즉시 만료)
        Cookie jwtCookie = new Cookie("jwtToken", "");
        jwtCookie.setHttpOnly(true);
        jwtCookie.setSecure(false);     // 로컬 개발용
        jwtCookie.setPath("/");
        jwtCookie.setMaxAge(0);         // 쿠키 즉시 삭제
        response.addCookie(jwtCookie);
        
        // 홈페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/");
    }
}
