package util;

import java.nio.charset.StandardCharsets;
import java.util.Date;

import javax.crypto.SecretKey;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

public final class JwtUtil {
    // 환경변수에서 SECRET_KEY를 가져오거나 기본값 사용 (프로덕션에서는 반드시 환경변수 사용)
    private static final String SECRET = envOrDefault("JWT_SECRET", "your-super-secret-key-minimum-32-characters-for-hs256");
    private static final SecretKey KEY = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
    private static final long EXPIRATION_TIME = 86400000; // 24시간 (ms)

    private JwtUtil() {
        // utility
    }

    /**
     * JWT 토큰 생성
     * @param username 사용자 아이디
     * @param memberId 회원 ID
     * @return JWT 토큰
     */
    public static String generateToken(String username, long memberId) {
        long now = System.currentTimeMillis();
        return Jwts.builder()
                .setSubject(username)
                .claim("memberId", memberId)
                .setIssuedAt(new Date(now))
                .setExpiration(new Date(now + EXPIRATION_TIME))
                .signWith(KEY, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * JWT 토큰 검증 및 username 추출
     * @param token JWT 토큰
     * @return username (유효한 경우), null (유효하지 않은 경우)
     */
    public static String validateAndGetUsername(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return claims.getSubject();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * JWT 토큰에서 memberId 추출
     * @param token JWT 토큰
     * @return memberId (유효한 경우), -1 (유효하지 않은 경우)
     */
    public static long validateAndGetMemberId(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return claims.get("memberId", Number.class).longValue();
        } catch (Exception e) {
            return -1;
        }
    }

    /**
     * JWT 토큰이 유효한지 확인
     * @param token JWT 토큰
     * @return 유효하면 true, 유효하지 않으면 false
     */
    public static boolean isValidToken(String token) {
        if (token == null || token.isBlank()) {
            return false;
        }
        try {
            Jwts.parserBuilder()
                    .setSigningKey(KEY)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    private static String envOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return value == null || value.isBlank() ? defaultValue : value;
    }
}
