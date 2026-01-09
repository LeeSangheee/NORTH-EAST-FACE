package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.JwtUtil;

/**
 * JWT 토큰 검증 필터
 * - 쿠키에서 JWT 토큰을 추출하여 검증
 * - 유효한 토큰이면 요청에 사용자 정보를 저장
 * - 무효한 토큰이면 로그인 페이지로 리다이렉트
 */
@WebFilter(urlPatterns = {"/student/*", "/teacher/*", "/api/protected/*", "/checkout"})
public class JwtAuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String token = extractTokenFromCookie(httpRequest);
        
        if (token != null && JwtUtil.isValidToken(token)) {
            // 유효한 토큰 - 사용자 정보를 요청에 저장
            String username = JwtUtil.validateAndGetUsername(token);
            long memberId = JwtUtil.validateAndGetMemberId(token);
            
            httpRequest.setAttribute("username", username);
            httpRequest.setAttribute("memberId", memberId);
            httpRequest.setAttribute("jwtToken", token);
            
            chain.doFilter(request, response);
        } else {
            // 유효하지 않은 토큰 - 로그인 페이지로 리다이렉트
            HttpSession session = httpRequest.getSession();
            session.setAttribute("error", "로그인이 필요합니다.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
    
    /**
     * 쿠키에서 JWT 토큰 추출
     */
    private String extractTokenFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("jwtToken".equals(cookie.getName())) {
                    String value = cookie.getValue();
                    return value.isEmpty() ? null : value;
                }
            }
        }
        return null;
    }
    
    @Override
    public void destroy() {
    }
}
