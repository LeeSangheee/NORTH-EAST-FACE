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
        .hero { position: relative; height: 78vh; min-height: 520px; color: white; overflow: hidden; display: flex; align-items: center; justify-content: center; text-align: center; }
        .hero-carousel { position: absolute; inset: 0; }
        .hero-slide { position: absolute; inset: 0; background-size: cover; background-position: center; opacity: 0; transition: opacity 0.8s ease-in-out; }
        .hero-slide.is-active { opacity: 1; }
        .hero::before { content: ""; position: absolute; inset: 0; background: linear-gradient(180deg, rgba(0,0,0,0.45), rgba(0,0,0,0.35)); }
        .hero-content { position: relative; z-index: 1; padding: 0 1.5rem; }
        .hero-content h1 { font-size: 3.8rem; font-weight: 700; margin-bottom: 0.8rem; letter-spacing: 0.01em; text-shadow: 2px 2px 8px rgba(0,0,0,0.55); text-transform: uppercase; }
        .hero-content .hero-sub { font-size: 1.1rem; font-weight: 600; letter-spacing: 0.05em; margin-bottom: 1rem; text-shadow: 1px 1px 5px rgba(0,0,0,0.45); }
        .hero-content .hero-meta { display: inline-flex; gap: 10px; align-items: center; font-size: 1.25rem; font-weight: 800; letter-spacing: 0.1em; margin-bottom: 0.4rem; text-shadow: 1px 1px 6px rgba(0,0,0,0.5); }
        .hero-nav { position: absolute; inset: 0; display: flex; justify-content: space-between; align-items: center; pointer-events: none; padding: 0 18px; z-index: 2; }
        .hero-nav button { pointer-events: all; background: rgba(0,0,0,0.35); color: #fff; border: 1px solid rgba(255,255,255,0.35); border-radius: 50%; width: 44px; height: 44px; font-size: 20px; cursor: pointer; transition: background 0.2s, transform 0.2s; }
        .hero-nav button:hover { background: rgba(0,0,0,0.55); transform: translateY(-2px); }
        .hero-nav button:focus { outline: 2px solid #fff; outline-offset: 2px; }
        .hero-dots { position: absolute; bottom: 28px; left: 50%; transform: translateX(-50%); display: flex; gap: 10px; z-index: 2; }
        .hero-dots button { width: 11px; height: 11px; border-radius: 50%; border: 1px solid #fff; background: rgba(255,255,255,0.4); cursor: pointer; transition: background 0.2s, transform 0.2s; }
        .hero-dots button.is-active { background: #fff; transform: scale(1.05); }
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
        <div class="hero-carousel" id="heroCarousel">
            <div class="hero-slide is-active" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner1.webp');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner2.webp');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner3.webp');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner4.webp');"></div>
        </div>
        <div class="hero-nav" aria-hidden="true">
            <button type="button" id="heroPrev" aria-label="Previous banner">‹</button>
            <button type="button" id="heroNext" aria-label="Next banner">›</button>
        </div>
        <div class="hero-content">
        </div>
        <div class="hero-dots" id="heroDots" aria-label="Hero banners"></div>
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
    <script>
        (function() {
            const slides = Array.from(document.querySelectorAll('#heroCarousel .hero-slide'));
            const dotsContainer = document.getElementById('heroDots');
            const prevBtn = document.getElementById('heroPrev');
            const nextBtn = document.getElementById('heroNext');
            if (!slides.length || !dotsContainer || !prevBtn || !nextBtn) return;

            let current = 0;
            let timer;

            const setActive = (idx) => {
                slides.forEach((s, i) => s.classList.toggle('is-active', i === idx));
                Array.from(dotsContainer.children).forEach((d, i) => d.classList.toggle('is-active', i === idx));
                current = idx;
            };

            slides.forEach((_, i) => {
                const b = document.createElement('button');
                b.type = 'button';
                b.setAttribute('aria-label', `배너 ${i + 1}`);
                b.addEventListener('click', () => {
                    clearInterval(timer);
                    setActive(i);
                    start();
                });
                dotsContainer.appendChild(b);
            });

            const next = () => setActive((current + 1) % slides.length);
            const prev = () => setActive((current - 1 + slides.length) % slides.length);
            const start = () => {
                timer = setInterval(next, 4500);
            };

            prevBtn.addEventListener('click', () => {
                clearInterval(timer);
                prev();
                start();
            });

            nextBtn.addEventListener('click', () => {
                clearInterval(timer);
                next();
                start();
            });

            setActive(0);
            start();
        })();
    </script>
</body>
</html>
