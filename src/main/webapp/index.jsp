<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>NORTH EAST FACE® - Never Stop Coding</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; }
        .hero { height: 100vh; background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 800"><rect fill="%23333" width="1200" height="800"/><polygon fill="%23555" points="0,800 400,200 800,600 1200,100 1200,800"/><text x="600" y="400" text-anchor="middle" fill="%23777" font-size="120" font-family="Arial">⛰️</text></svg>'); background-size: cover; background-position: center; display: flex; align-items: center; justify-content: center; text-align: center; color: white; }
        .hero-content h1 { font-size: 4rem; font-weight: 300; margin-bottom: 1rem; text-shadow: 2px 2px 4px rgba(0,0,0,0.5); }
        .hero-content p { font-size: 1.2rem; margin-bottom: 2rem; max-width: 600px; }
        .cta-button { display: inline-block; background: #fff; color: #000; padding: 1rem 2rem; text-decoration: none; font-weight: bold; text-transform: uppercase; letter-spacing: 1px; transition: all 0.3s; border: 2px solid #fff; }
        .cta-button:hover { background: transparent; color: #fff; }
        .categories { padding: 4rem 0; background: #f8f8f8; }
        .container { max-width: 1200px; margin: 0 auto; padding: 0 2rem; }
        .section-title { text-align: center; font-size: 2.5rem; margin-bottom: 3rem; font-weight: 300; }
        .category-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2rem; }
        .category-card { background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .category-card:hover { transform: translateY(-5px); }
        .category-image { height: 200px; background: #ddd; display: flex; align-items: center; justify-content: center; font-size: 3rem; }
        .category-content { padding: 1.5rem; }
        .category-content h3 { font-size: 1.3rem; margin-bottom: 0.5rem; }
        .category-content p { color: #666; margin-bottom: 1rem; }
        .category-link { color: #000; text-decoration: none; font-weight: bold; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px; }
        .footer { background: #000; color: white; padding: 3rem 0 1rem; }
        .footer-content { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin-bottom: 2rem; }
        .footer-section h4 { margin-bottom: 1rem; text-transform: uppercase; letter-spacing: 1px; }
        .footer-section ul { list-style: none; line-height: 1.8; color: #ccc; }
        .footer-bottom { text-align: center; color: #777; font-size: 0.9rem; }
    </style>
</head>
<body>
    <ui:header />

    <section class="hero">
        <div class="hero-content">
            <h1>NEVER STOP CODING</h1>
            <p>혹독한 개발 환경을 이겨내는 혁신적인 장비. 개발자를 위한 프리미엄 아웃도어 브랜드.</p>
            <a href="products.jsp" class="cta-button">Shop Now</a>
        </div>
    </section>

    <section class="categories" id="categories">
        <div class="container">
            <h2 class="section-title">개발자를 위한 컬렉션</h2>
            <div class="category-grid">
                <div class="category-card">
                    <div class="category-image">🧥</div>
                    <div class="category-content">
                        <h3>IDE 울트라 자켓</h3>
                        <p>극한의 추위에서도 코딩 가능한 프리미엄 개발자 자켓</p>
                        <a href="products.jsp" class="category-link">Shop IDE Jackets →</a>
                    </div>
                </div>
                <div class="category-card">
                    <div class="category-image">🎒</div>
                    <div class="category-content">
                        <h3>코드 베이스캠프 백팩</h3>
                        <p>모든 개발 장비를 안전하게 보관하는 대용량 백팩</p>
                        <a href="products.jsp" class="category-link">Shop Backpacks →</a>
                    </div>
                </div>
                <div class="category-card">
                    <div class="category-image">☕</div>
                    <div class="category-content">
                        <h3>카페인 서바이벌 키트</h3>
                        <p>24시간 코딩을 위한 프리미엄 커피 장비 세트</p>
                        <a href="products.jsp" class="category-link">Shop Caffeine →</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container footer-content">
            <div class="footer-section">
                <h4>NORTH EAST FACE®</h4>
                <ul>
                    <li>Never Stop Coding</li>
                    <li>For Extreme Developers</li>
                    <li>Since 2024</li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Support</h4>
                <ul>
                    <li>FAQ</li>
                    <li>Warranty</li>
                    <li>Contact</li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Community</h4>
                <ul>
                    <li>Hackathons</li>
                    <li>Meetups</li>
                    <li>Careers</li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            © 2026 NORTH EAST FACE®. Never Stop Coding.
        </div>
    </footer>
</body>
</html>
