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

import util.JwtUtil;

/**
 * 모든 요청에 JWT 토큰 정보를 추가하는 필터
 * - 쿠키에서 JWT 토큰을 추출하여 검증
 * - 유효하면 request attribute에 username과 memberId를 저장
 * - 로그인 여부와 사용자 정보를 JSP에서 접근 가능하게 함
 */
@WebFilter(urlPatterns = "/*")
public class JwtInfoFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        String token = extractTokenFromCookie(httpRequest);
        
        // JWT 토큰이 유효하면 사용자 정보를 request attribute에 저장
        if (token != null && JwtUtil.isValidToken(token)) {
            String username = JwtUtil.validateAndGetUsername(token);
            long memberId = JwtUtil.validateAndGetMemberId(token);
            
            if (username != null && memberId > 0) {
                httpRequest.setAttribute("username", username);
                httpRequest.setAttribute("memberId", memberId);
                httpRequest.setAttribute("isLoggedIn", true);
            }
        }
        
        chain.doFilter(request, response);
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
