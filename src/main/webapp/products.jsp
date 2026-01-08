<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>Shop - NORTH EAST FACE®</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; background: #f5f5f5; }
        .hero { background: #111; color: white; padding: 5rem 0 3rem; text-align: center; }
        .hero h1 { font-size: 3rem; font-weight: 300; margin-bottom: 1rem; }
        .hero p { color: #ccc; }
        .product-grid { max-width: 1200px; margin: 2rem auto 4rem; display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1.5rem; padding: 0 2rem; }
        .product-card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.1); transition: transform 0.3s, box-shadow 0.3s; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 14px 30px rgba(0,0,0,0.15); }
        .product-image { height: 220px; background: #e5e5e5; display: flex; align-items: center; justify-content: center; font-size: 3rem; }
        .product-body { padding: 1.5rem; }
        .product-body h3 { font-size: 1.2rem; margin-bottom: 0.5rem; }
        .product-body p { color: #666; margin-bottom: 1rem; }
        .price { font-weight: bold; margin-bottom: 1rem; display: block; }
        .product-footer { display: flex; justify-content: space-between; align-items: center; padding: 0 1.5rem 1.5rem; }
        .btn { display: inline-block; padding: 0.6rem 1.2rem; background: #000; color: white; text-decoration: none; text-transform: uppercase; letter-spacing: 1px; font-size: 0.85rem; transition: opacity 0.3s; border: 1px solid #000; }
        .btn:hover { opacity: 0.85; }
        .tag { background: #eee; padding: 0.4rem 0.8rem; border-radius: 20px; font-size: 0.8rem; color: #555; }
        .footer { background: #000; color: white; padding: 2rem 0; text-align: center; }
        .footer small { color: #777; }
    </style>
</head>
<body>
        <ui:header />

    <section class="hero">
        <h1>개발자를 위한 아웃도어</h1>
        <p>혹독한 배포 환경에서도 버티는 장비</p>
    </section>

    <section class="product-grid">
        <div class="product-card">
            <div class="product-image">🧥</div>
            <div class="product-body">
                <h3>IDE 울트라 자켓</h3>
                <p>컴파일 타임 추위를 막아주는 초경량 자켓</p>
                <span class="price">₩ 590,000</span>
            </div>
            <div class="product-footer">
                <span class="tag">신상품</span>
                <a class="btn" href="product-detail.jsp">View</a>
            </div>
        </div>

        <div class="product-card">
            <div class="product-image">🎒</div>
            <div class="product-body">
                <h3>코드 베이스캠프 백팩</h3>
                <p>노트북 2대, 서버 랙 미니어처까지 수납 가능한 올인원</p>
                <span class="price">₩ 420,000</span>
            </div>
            <div class="product-footer">
                <span class="tag">베스트</span>
                <a class="btn" href="backpack-detail.jsp">View</a>
            </div>
        </div>

        <div class="product-card">
            <div class="product-image">☕</div>
            <div class="product-body">
                <h3>카페인 서바이벌 키트</h3>
                <p>24시간 무중단 코딩을 위한 풀세트</p>
                <span class="price">₩ 89,000</span>
            </div>
            <div class="product-footer">
                <span class="tag">한정판</span>
                <a class="btn" href="product-detail.jsp">View</a>
            </div>
        </div>

        <div class="product-card">
            <div class="product-image">🧢</div>
            <div class="product-body">
                <h3>Commit 캡</h3>
                <p>깃헙 액션이 실패해도 스타일은 성공</p>
                <span class="price">₩ 49,000</span>
            </div>
            <div class="product-footer">
                <span class="tag">NEW</span>
                <a class="btn" href="product-detail.jsp">View</a>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="nav-container">
            <p>NORTH EAST FACE® — Never Stop Coding</p>
            <small>© 2026 NEF. All code, no bugs.</small>
        </div>
    </footer>
</body>
</html>
