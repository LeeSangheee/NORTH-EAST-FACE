<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><c:out value="${product.name}"/> - NORTH EAST FACE</title>
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: 'Helvetica Neue', Arial, sans-serif; color: #222; }
    .page { max-width: 1200px; margin: 0 auto; padding: 24px; }
    .detail { display: grid; grid-template-columns: 1fr 1fr; gap: 32px; align-items: start; }
    .left { position: sticky; top: 16px; }
    .emoji-frame { width: 100%; aspect-ratio: 1 / 1; background: #f6f6f6; border: 1px solid #e6e6e6; border-radius: 6px; display: flex; align-items: center; justify-content: center; }
    .emoji { font-size: clamp(140px, 28vw, 320px); line-height: 1; }

    .right h1 { font-size: 28px; margin: 0 0 8px; }
    .meta { color: #777; font-size: 14px; margin-bottom: 16px; }
    .price { font-size: 22px; font-weight: 700; margin: 8px 0 20px; }

    /* CTAs: full-width Buy + outlined Cart with wishlist */
    .cta { margin-top: 24px; display: grid; grid-template-columns: 1fr; gap: 10px; }
    .btn { appearance: none; border: none; padding: 0 18px; border-radius: 4px; cursor: pointer; font-weight: 700; height: 56px; }
    .btn.buy { background: #111; color: #fff; width: 100%; }

    /* Add-to-cart modal */
    .cart-modal { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; z-index: 1200; }
    .cart-modal.is-open { display: flex; }
    .cart-modal .backdrop { position: absolute; inset: 0; background: rgba(0,0,0,0.55); }
    .cart-modal .sheet { position: relative; background: #fff; width: min(380px, 92vw); border-radius: 10px; overflow: hidden; box-shadow: 0 18px 38px rgba(0,0,0,0.28); border: 1px solid rgba(0,0,0,0.06); text-align: center; }
    .cart-modal .body { padding: 30px 26px 18px; display: grid; gap: 10px; color: #222; font-size: 14px; justify-items: center; }
    .cart-modal .icon { font-size: 36px; color: #888; margin-bottom: 4px; }
    .cart-modal .actions { display: grid; grid-template-columns: 1fr 1fr; }
    .cart-modal .btn { border-radius: 0; height: 48px; font-size: 14px; font-weight: 800; padding: 0; display: flex; align-items: center; justify-content: center; }
    .cart-modal .btn.cart-link { background: #f8f8f8; color: #111; border: 1px solid #ddd; }
    .cart-modal .btn.close { background: #111; color: #fff; border: 1px solid #111; }

    /* Login-required modal */
    .login-modal { position: fixed; inset: 0; display: none; align-items: center; justify-content: center; z-index: 1300; }
    .login-modal.is-open { display: flex; }
    .login-modal .backdrop { position: absolute; inset: 0; background: rgba(0,0,0,0.55); }
    .login-modal .sheet { position: relative; background: #fff; width: min(360px, 92vw); border-radius: 10px; box-shadow: 0 18px 38px rgba(0,0,0,0.28); overflow: hidden; border: 1px solid rgba(0,0,0,0.06); }
    .login-modal .close { position: absolute; right: 14px; top: 14px; border: none; background: none; font-size: 18px; cursor: pointer; color: #555; }
    .login-modal .head { padding: 22px 20px 12px; border-bottom: 1px solid #eee; font-size: 18px; font-weight: 800; }
    .login-modal .body { padding: 14px 20px 10px; font-size: 13px; color: #444; line-height: 1.55; }
    .login-modal .benefits { padding: 14px 16px; margin: 0 16px 14px; border: 1px solid #eee; border-radius: 6px; background: #fafafa; display: grid; gap: 10px; font-size: 12px; color: #444; }
    .login-modal .benefit { display: flex; gap: 10px; align-items: flex-start; }
    .login-modal .benefit-icon { font-size: 18px; }
    .login-modal .actions { display: grid; grid-template-columns: 1fr 1fr; border-top: 1px solid #eee; }
    .login-modal .btn { border-radius: 0; height: 46px; font-size: 14px; font-weight: 800; padding: 0; }
    .login-modal .btn.join { background: #fff; color: #111; border: 1px solid #ddd; border-right: 1px solid #eee; }
    .login-modal .btn.login { background: #111; color: #fff; border: 1px solid #111; }
    .login-modal .footer { text-align: center; padding: 12px; font-size: 12px; color: #666; border-top: 1px solid #eee; }
    .login-modal .footer a { color: #111; text-decoration: underline; }

    @media (max-width: 920px) {
      .detail { grid-template-columns: 1fr; }
      .left { position: static; }
    }
  </style>
</head>
<body>
  <ui:header />
  <main class="page">
    <div class="detail" id="detailRoot">
      <div class="left">
        <div class="emoji-frame">
          <c:choose>
            <c:when test="${not empty product.imageFileName}">
              <img src="${product.imageFileName}" 
                   alt="${product.name}" 
                   style="width: 100%; height: 100%; object-fit: cover;"
                   onerror="this.style.display='none'; this.parentElement.innerHTML='<div class=\'emoji\'>🧥</div>'">
            </c:when>
            <c:otherwise>
              <div class="emoji">🧥</div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      <div class="right">
        <c:if test="${not empty categoryName}">
          <div class="meta" id="category">
            <a href="${pageContext.request.contextPath}/products?categoryId=${product.categoryId}" 
               style="color: #111; text-decoration: none; font-weight: 600;">
              <c:out value="${categoryName}"/>
            </a>
          </div>
        </c:if>
        <h1 id="title"><c:out value="${product.name}"/></h1>
        <div class="price" id="price"><fmt:formatNumber value="${product.price}" pattern="#,##0"/> 원</div>
        <div class="meta" style="margin-top: 12px;">
          <c:choose>
            <c:when test="${product.stockQty <= 0}">품절</c:when>
            <c:when test="${product.stockQty < 10}">재고 ${product.stockQty}개</c:when>
            <c:otherwise>재고 있음</c:otherwise>
          </c:choose>
        </div>

        <div class="cta">
          <button class="btn buy">바로구매</button>
          <button class="btn cart-main" style="width: 100%; background: #fff; color: #111; border: 1px solid #111;">장바구니</button>
        </div>
      </div>
    </div>
  </main>

  <script>
    // 서버에서 전달된 상품 ID
    const productId = ${product.productId};

    // 간단한 로컬 데이터 (index.jsp와 매핑)
    const PRODUCTS = {
      '1': { name: "M'S OBIR HYBRID DOWN COAT", emoji: '🧥', price: '314,100 원', colors: ['#bdbdbd','#111','#ececec'], sizes: ['090(S)','095(M)','100(L)','105(XL)','110(XXL)'] },
      '2': { name: "M'S HIMALAYAN PARKA (RDS)", emoji: '🧥', price: '950,000 원', colors: ['#c9c9c9','#333'], sizes: ['095(M)','100(L)','105(XL)','110(XXL)'] },
      '3': { name: "W'S EVERLOFT DOWN COAT (RDS)", emoji: '🧥', price: '318,400 원', colors: ['#d9d9d9','#111'], sizes: ['085(S)','090(M)','095(L)','100(XL)'] },
      '4': { name: "W'S 2000 NUPTSE JACKET", emoji: '🧥', price: '319,200 원', colors: ['#bfbfbf','#111','#e6e6e6'], sizes: ['085(S)','090(M)','095(L)','100(XL)'] },
      '5': { name: 'BOREALIS BOOTIE', emoji: '🥾', price: '135,200 원', colors: ['#cfcfcf','#111'], sizes: ['240','250','260','270','280'] },
      '6': { name: 'BOREALIS CLASSIC BACKPACK', emoji: '🎒', price: '149,000 원', colors: ['#e4e4e4','#111'], sizes: ['ONE SIZE'] },
      '7': { name: 'MONTANA SKI GLOVE', emoji: '🧤', price: '89,000 원', colors: ['#dedede','#111'], sizes: ['S','M','L','XL'] },
      '8': { name: 'HORIZON HAT', emoji: '🧢', price: '27,300 원', colors: ['#efefef','#111'], sizes: ['S','M','L'] }
    };

    const data = PRODUCTS[productId] || { name: '상품 ' + productId, emoji: '🧥', price: '-' };

    // ---- Cart via DB only ----
    const IS_LOGGED_IN = ${not empty isLoggedIn ? 'true' : 'false'};

    function addToCart(productId, quantity) {
      // 로그인 체크
      if (!IS_LOGGED_IN) {
        showLoginModal();
        return;
      }
      
      // DB에 저장
      const formData = new FormData();
      formData.append('action', 'add');
      formData.append('productId', productId);
      formData.append('quantity', quantity || 1);
      
      fetch('${pageContext.request.contextPath}/api/cart', {
        method: 'POST',
        body: formData
      })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          showToast('장바구니에 담았어요');
          showCartModal();
        } else {
          showToast('장바구니 추가 실패: ' + (data.message || '오류'));
        }
      })
      .catch(err => {
        console.error('Cart API error:', err);
        showToast('장바구니 추가 중 오류 발생');
      });
    }

    // Modal helpers
    const CART_URL = '${pageContext.request.contextPath}/cart';
    function ensureCartModal() {
      let modal = document.getElementById('cartModal');
      if (modal) return modal;
      modal = document.createElement('div');
      modal.id = 'cartModal';
      modal.className = 'cart-modal';
      modal.innerHTML = '' +
        '<div class="backdrop" data-close="1"></div>' +
        '<div class="sheet" role="dialog" aria-modal="true" aria-label="장바구니 알림">' +
          '<div class="body">' +
            '<div class="icon">🛒</div>' +
            '<div>선택하신 상품을<br/>장바구니에 담았습니다.</div>' +
          '</div>' +
          '<div class="actions">' +
            '<a class="btn cart-link" href="' + CART_URL + '">장바구니 바로가기</a>' +
            '<button class="btn close" type="button" data-close="1">계속 쇼핑하기</button>' +
          '</div>' +
        '</div>';
      document.body.appendChild(modal);
      modal.addEventListener('click', (e) => {
        if (e.target.dataset.close) hideCartModal();
      });
      return modal;
    }

    function showCartModal() {
      const modal = ensureCartModal();
      modal.classList.add('is-open');
    }

    function hideCartModal() {
      const modal = document.getElementById('cartModal');
      if (modal) modal.classList.remove('is-open');
    }

    // Login modal helpers
    const LOGIN_URL = '${pageContext.request.contextPath}/login';
    const JOIN_URL = '${pageContext.request.contextPath}/register';
    function ensureLoginModal() {
      let modal = document.getElementById('loginModal');
      if (modal) return modal;
      modal = document.createElement('div');
      modal.id = 'loginModal';
      modal.className = 'login-modal';
      modal.innerHTML = '' +
        '<div class="backdrop" data-close="1"></div>' +
        '<div class="sheet" role="dialog" aria-modal="true" aria-label="회원 혜택 안내">' +
          '<button class="close" type="button" data-close="1">×</button>' +
          '<div class="head">노스페이스 회원 혜택</div>' +
          '<div class="body">회원가입 후 구매하시면 더 많은 혜택을 받을 수 있습니다.</div>' +
          '<div class="benefits">' +
            '<div class="benefit"><span class="benefit-icon">💳</span><div>회원 구매 시 5% 적립<br/>공식몰 멤버십 전용 3% 메리트 적립</div></div>' +
            '<div class="benefit"><span class="benefit-icon">🎂</span><div>생일 축하 할인쿠폰 지급<br/>회원 등급에 따라 생일 할인 쿠폰 지급</div></div>' +
            '<div class="benefit"><span class="benefit-icon">📝</span><div>리뷰 리워드 혜택 제공<br/>상품 리뷰 작성 시 메리트 적립 혜택</div></div>' +
          '</div>' +
          '<div class="actions">' +
            '<a class="btn join" href="' + JOIN_URL + '">회원가입</a>' +
            '<a class="btn login" href="' + LOGIN_URL + '">로그인</a>' +
          '</div>' +
        '</div>';
      document.body.appendChild(modal);
      modal.addEventListener('click', (e) => {
        if (e.target.dataset.close) hideLoginModal();
      });
      return modal;
    }

    function showLoginModal() {
      const modal = ensureLoginModal();
      modal.classList.add('is-open');
    }

    function hideLoginModal() {
      const modal = document.getElementById('loginModal');
      if (modal) modal.classList.remove('is-open');
    }

    function showToast(text) {
      let t = document.getElementById('toast');
      if (!t) {
        t = document.createElement('div');
        t.id = 'toast';
        t.style.position = 'fixed';
        t.style.left = '50%';
        t.style.bottom = '24px';
        t.style.transform = 'translateX(-50%)';
        t.style.background = '#111';
        t.style.color = '#fff';
        t.style.padding = '12px 16px';
        t.style.borderRadius = '6px';
        t.style.boxShadow = '0 6px 18px rgba(0,0,0,0.25)';
        t.style.zIndex = '9999';
        document.body.appendChild(t);
      }
      t.textContent = text;
      t.style.opacity = '1';
      clearTimeout(t._timer);
      t._timer = setTimeout(() => { t.style.opacity = '0'; }, 1600);
    }

    function addToCart(productId, quantity) {
      if (!IS_LOGGED_IN) {
        showLoginModal();
        return;
      }
      
      const params = new URLSearchParams();
      params.append('action', 'add');
      params.append('productId', productId);
      params.append('quantity', quantity || 1);
      
      fetch('${pageContext.request.contextPath}/api/cart', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
      })
      .then(res => res.json())
      .then(data => {
        if (data.success) {
          showToast('장바구니에 담았어요');
          if (window.nefUpdateCartBadge) window.nefUpdateCartBadge();
          showCartModal();
        } else {
          showToast('장바구니 추가 실패: ' + (data.message || '오류'));
        }
      })
      .catch(err => {
        console.error('Cart API error:', err);
        showToast('장바구니 추가 중 오류 발생');
      });
    }

    // Bind Cart and Buy buttons
    const cartBtn = document.querySelector('.cart-main');
    const buyBtn = document.querySelector('.btn.buy');

    cartBtn?.addEventListener('click', () => {
      addToCart(productId, 1);
    });

    buyBtn?.addEventListener('click', () => {
      if (!IS_LOGGED_IN) {
        showLoginModal();
        return;
      }
      // 바로구매: 바로 결제 페이지로 이동 (장바구니에 추가하지 않음)
      window.location.href = '${pageContext.request.contextPath}/checkout?productId=' + productId + '&quantity=1';
    });
  </script>
</body>
</html>
