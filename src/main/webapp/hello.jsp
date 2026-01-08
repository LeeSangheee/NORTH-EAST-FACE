<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>About - NORTH EAST FACE®</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; background: #f6f6f6; }
        .hero { background: #111; color: white; padding: 4rem 0 3rem; text-align: center; }
        .hero h1 { font-size: 2.8rem; font-weight: 300; margin-bottom: 0.5rem; }
        .hero p { color: #aaa; }
        .container { max-width: 900px; margin: -40px auto 4rem; background: white; border-radius: 12px; box-shadow: 0 14px 30px rgba(0,0,0,0.08); padding: 2.5rem; }
        h2 { margin: 1.5rem 0 0.5rem; font-weight: 600; }
        p { color: #555; margin-bottom: 1rem; }
        .values { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1.2rem; margin-top: 1.5rem; }
        .card { padding: 1.4rem; border: 1px solid #eee; border-radius: 10px; background: #fafafa; }
        .card h3 { margin-bottom: 0.6rem; }
        .footer { background: #000; color: white; padding: 2rem 0; text-align: center; }
        .footer small { color: #777; }
    </style>
</head>
<body>
    <ui:header />

    <section class="hero">
        <h1>Never Stop Coding</h1>
        <p>혹독한 환경에서도 멈추지 않는 개발자를 위해</p>
    </section>

    <div class="container">
        <h2>브랜드 스토리</h2>
        <p>NORTH EAST FACE®는 혹한의 개발 환경과 타이트한 데드라인을 견디는 개발자를 위해 탄생했습니다. 우리의 장비는 단순한 굿즈가 아니라, 코드 품질을 지켜주는 방어구입니다.</p>

        <h2>철학</h2>
        <div class="values">
            <div class="card">
                <h3>Resilience</h3>
                <p>서버 다운 타임에도, 추운 데이터센터에서도, 개발은 계속되어야 합니다.</p>
            </div>
            <div class="card">
                <h3>Craft</h3>
                <p>픽셀 하나, 줄바꿈 하나까지 고민하는 장인 정신으로 만듭니다.</p>
            </div>
            <div class="card">
                <h3>Community</h3>
                <p>함께 등반하는 동료 개발자들이 있기에 정상에 오릅니다.</p>
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
