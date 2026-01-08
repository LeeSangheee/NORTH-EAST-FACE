<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>코드 베이스캠프 백팩 - NORTH EAST FACE®</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; background: #f8f8f8; }
        .hero { background: #111; color: white; padding: 2.5rem 0; text-align: center; }
        .hero h1 { font-size: 2.5rem; font-weight: 300; }
        .hero p { color: #ccc; margin-top: 0.5rem; }
        .container { max-width: 1100px; margin: -40px auto 4rem; background: white; border-radius: 12px; box-shadow: 0 14px 30px rgba(0,0,0,0.12); overflow: hidden; }
        .content { display: grid; grid-template-columns: 1.1fr 1fr; gap: 0; }
        .image { background: linear-gradient(135deg, #1f2933, #3a4b5c); height: 100%; display: flex; align-items: center; justify-content: center; color: white; font-size: 6rem; }
        .details { padding: 2.5rem; }
        .badge { display: inline-block; background: #eee; padding: 0.35rem 0.8rem; border-radius: 20px; font-size: 0.85rem; color: #555; margin-bottom: 1rem; }
        h2 { font-size: 1.8rem; margin-bottom: 1rem; }
        .price { font-size: 1.4rem; font-weight: bold; margin: 1rem 0 1.5rem; }
        .desc { color: #555; margin-bottom: 1.5rem; }
        .specs { list-style: none; color: #444; line-height: 1.8; margin-bottom: 2rem; }
        .cta { display: inline-block; padding: 0.9rem 1.6rem; background: #000; color: white; text-decoration: none; text-transform: uppercase; letter-spacing: 1px; font-size: 0.9rem; border: 1px solid #000; transition: opacity 0.3s; }
        .cta:hover { opacity: 0.85; }
        .breadcrumb { margin-bottom: 1rem; color: #777; font-size: 0.9rem; }
        .breadcrumb a { color: #777; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }
        .footer { background: #000; color: white; padding: 2rem 0; text-align: center; }
        .footer small { color: #777; }
    </style>
</head>
<body>
    <ui:header />

    <section class="hero">
        <h1>코드 베이스캠프 백팩</h1>
        <p>모든 개발 장비를 안전하게 보관하는 대용량 백팩</p>
    </section>

    <div class="container">
        <div class="content">
            <div class="image">🎒</div>
            <div class="details">
                <div class="breadcrumb"><a href="index.jsp">Home</a> / <a href="products.jsp">Shop</a> / Backpack</div>
                <span class="badge">BEST</span>
                <h2>코드 베이스캠프 백팩</h2>
                <div class="price">₩ 420,000</div>
                <p class="desc">노트북 2대, 서버 랙 미니어처까지 수납 가능한 올인원 백팩. 극한의 원격 근무 환경에서도 당신의 장비를 완벽히 보호합니다.</p>
                <ul class="specs">
                    <li>• 서버급 충격 흡수 패널</li>
                    <li>• 27" 모니터 대응 확장 포켓</li>
                    <li>• 장시간 빌드 대기용 패딩 스트랩</li>
                    <li>• 배터리 뱅크 전용 케이블 채널</li>
                </ul>
                <a class="cta" href="products.jsp">Back to Shop</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="nav-container">
            <p>NORTH EAST FACE® — Never Stop Coding</p>
            <small>© 2026 NEF. All code, no bugs.</small>
        </div>
    </footer>
</body>
</html>
