<%@ tag language="java" pageEncoding="UTF-8" body-content="empty" %>
<%-- Shared header tag --%>
<style>
    .global-header { position: sticky; top: 0; z-index: 1000; background: #fff; border-bottom: 1px solid #eee; }
    .header-inner { max-width: 1200px; margin: 0 auto; padding: 14px 24px; display: flex; align-items: center; gap: 22px; }
    .logo-link { display: inline-flex; align-items: center; text-decoration: none; }
    .logo-link img { display: block; height: 44px; width: auto; }
    .icon-button { background: none; border: none; font-size: 24px; line-height: 1; cursor: pointer; color: #111; padding: 6px 4px; }
    .icon-button:focus { outline: 2px solid #000; outline-offset: 2px; }
    .main-nav { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
    .main-nav a { text-decoration: none; color: #111; font-weight: 600; font-size: 15px; letter-spacing: -0.01em; }
    .main-nav a:hover { color: #444; }
    .header-spacer { flex: 1; }
    .header-right { display: flex; align-items: center; gap: 14px; }
    .search-box { display: flex; align-items: center; gap: 8px; border: 1px solid #d0d0d0; border-radius: 8px; padding: 8px 10px; min-width: 200px; }
    .search-box input { border: none; outline: none; font-size: 14px; width: 100%; }
    .search-box .search-icon { font-size: 18px; color: #333; }
        .cart-link { position: relative; }
        .cart-badge { position: absolute; top: -4px; right: -6px; background: #111; color: #fff; border-radius: 999px; min-width: 18px; height: 18px; display: inline-flex; align-items: center; justify-content: center; font-size: 11px; padding: 0 5px; border: 2px solid #fff; }

        /* Login-required modal (shared) */
        .login-modal { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; z-index: 1300; }
        .login-modal.is-open { display: flex; }
        .login-modal .backdrop { position: absolute; inset: 0; background: rgba(0,0,0,0.55); }
        .login-modal .sheet { position: relative; background: #fff; display: inline-block; width: auto; max-width: 92vw; border-radius: 10px; box-shadow: 0 18px 38px rgba(0,0,0,0.28); overflow: hidden; border: 1px solid rgba(0,0,0,0.06); }
        .login-modal .close { position: absolute; right: 14px; top: 14px; border: none; background: none; font-size: 18px; cursor: pointer; color: #555; }
        .login-modal .head { padding: 22px 20px 12px; padding-right: 48px; border-bottom: 1px solid #eee; font-size: 18px; font-weight: 800; display: flex; align-items: center; gap: 8px; white-space: nowrap; }
        .login-modal .head .brand { 
            display: inline-block; 
            font-family: "Arial Black", "Helvetica Neue", Arial, sans-serif; 
            font-weight: 900; 
            text-transform: uppercase; 
            letter-spacing: 0.03em; 
            font-size: 24px; 
            line-height: 1.1; 
            margin-bottom: 0;
        }
        .login-modal .brand-east { opacity: 0.55; }
        .login-modal .body { padding: 14px 20px 10px; font-size: 13px; color: #444; line-height: 1.55; }
        .login-modal .benefits { padding: 14px 16px; margin: 0 16px 14px; border: 1px solid #eee; border-radius: 6px; background: #fafafa; display: grid; gap: 10px; font-size: 12px; color: #444; }
        .login-modal .benefit { display: flex; gap: 10px; align-items: flex-start; }
        .login-modal .benefit-icon { font-size: 18px; }
        .login-modal .actions { display: grid; grid-template-columns: 1fr 1fr; border-top: 1px solid #eee; }
        .login-modal .btn { border-radius: 0; height: 46px; font-size: 14px; font-weight: 800; padding: 0; display: flex; align-items: center; justify-content: center; }
        .login-modal .btn.join { background: #fff; color: #111; border: 1px solid #ddd; border-right: 1px solid #eee; }
        .login-modal .btn.login { background: #111; color: #fff; border: 1px solid #111; }
        .login-modal .footer { text-align: center; padding: 12px; font-size: 12px; color: #666; border-top: 1px solid #eee; }
        .login-modal .footer a { color: #111; text-decoration: underline; }
</style>
<header class="global-header">
    <div class="header-inner">
        <a class="logo-link" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/static/images/logo.png" alt="NORTH EAST FACE"/>
        </a>
        <button class="icon-button" aria-label="Toggle menu">☰</button>
        <nav class="main-nav" aria-label="Primary">
            <a href="${pageContext.request.contextPath}/products">ACTIVITY</a>
            <a href="${pageContext.request.contextPath}/products">NEW</a>
            <a href="${pageContext.request.contextPath}/products">랭킹</a>
            <a href="${pageContext.request.contextPath}/products">화이트라벨</a>
            <a href="${pageContext.request.contextPath}/products">남성</a>
            <a href="${pageContext.request.contextPath}/products">여성</a>
            <a href="${pageContext.request.contextPath}/products">키즈</a>
            <a href="${pageContext.request.contextPath}/products">아울렛 ↗</a>
        </nav>
        <div class="header-spacer"></div>
        <div class="header-right">
            <div class="search-box">
                <input type="text" placeholder="눕시가이드" aria-label="Search"/>
                <span class="search-icon">🔍</span>
            </div>
                                <a class="icon-button cart-link" href="${pageContext.request.contextPath}/cart" aria-label="Cart">🛒<span id="cartCount" class="cart-badge" style="display:none">0</span></a>
            <a class="icon-button" href="${pageContext.request.contextPath}/hello" aria-label="Account">👤</a>
            <a class="icon-button" href="${pageContext.request.contextPath}/login" aria-label="Login">↪</a>
        </div>
    </div>
</header>
        <div id="globalLoginModal" class="login-modal" aria-hidden="true">
            <div class="backdrop" data-close="1"></div>
            <div class="sheet" role="dialog" aria-modal="true" aria-label="회원 혜택 안내">
                <button class="close" type="button" data-close="1">×</button>
                <div class="head"><span class="brand">NORTH <span class="brand-east">EAST</span> FACE®</span> 회원 혜택</div>
                <div class="body">회원가입 후 구매하시면 더 많은 혜택을 받을 수 있습니다.</div>
                <div class="benefits">
                    <div class="benefit"><span class="benefit-icon">💳</span><div>회원 구매 시 5% 적립<br/>공식몰 멤버십 전용 3% 메리트 적립</div></div>
                    <div class="benefit"><span class="benefit-icon">🎂</span><div>생일 축하 할인쿠폰 지급<br/>회원 등급에 따라 생일 할인 쿠폰 지급</div></div>
                    <div class="benefit"><span class="benefit-icon">📝</span><div>리뷰 리워드 혜택 제공<br/>상품 리뷰 작성 시 메리트 적립 혜택</div></div>
                </div>
                <div class="actions">
                    <a class="btn join" href="${pageContext.request.contextPath}/register">회원가입</a>
                    <a class="btn login" href="${pageContext.request.contextPath}/login">로그인</a>
                </div>
            </div>
  
        </div>
        <script>
            (function(){
                var KEY = 'nef_cart';
                var badge = document.getElementById('cartCount');
                function countItems(){
                    try {
                        var raw = localStorage.getItem(KEY);
                        var list = raw ? JSON.parse(raw) : [];
                        var total = Array.isArray(list) ? list.reduce(function(sum, it){ return sum + (it.qty || 0); }, 0) : 0;
                        if (!badge) return;
                        badge.textContent = String(total);
                        badge.style.display = total > 0 ? 'inline-flex' : 'none';
                    } catch(e) {}
                }
                window.nefUpdateCartBadge = countItems;
                window.addEventListener('storage', function(ev){ if (ev.key === KEY) countItems(); });
                countItems();

                // Global login modal helpers
                window.IS_LOGGED_IN = ${sessionScope.user != null};
                function showLoginModal(){ var m = document.getElementById('globalLoginModal'); if (m) { m.classList.add('is-open'); m.setAttribute('aria-hidden','false'); } }
                function hideLoginModal(){ var m = document.getElementById('globalLoginModal'); if (m) { m.classList.remove('is-open'); m.setAttribute('aria-hidden','true'); } }
                window.showLoginModal = showLoginModal;
                window.hideLoginModal = hideLoginModal;
                document.getElementById('globalLoginModal').addEventListener('click', function(e){ if (e.target.dataset && e.target.dataset.close) hideLoginModal(); });
            })();
        </script>
<script>
    (function(){
        var KEY = 'nef_cart';
        var badge = document.getElementById('cartCount');
        function countItems(){
            try {
                var raw = localStorage.getItem(KEY);
                var list = raw ? JSON.parse(raw) : [];
                var total = Array.isArray(list) ? list.reduce(function(sum, it){ return sum + (it.qty || 0); }, 0) : 0;
                if (!badge) return;
                badge.textContent = String(total);
                badge.style.display = total > 0 ? 'inline-flex' : 'none';
            } catch(e) {
                // ignore
            }
        }
        window.nefUpdateCartBadge = countItems;
        window.addEventListener('storage', function(ev){ if (ev.key === KEY) countItems(); });
        countItems();
    })();
</script>
