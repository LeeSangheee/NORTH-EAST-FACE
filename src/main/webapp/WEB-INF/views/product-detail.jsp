<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>상품 상세 - NORTH EAST FACE</title>
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

    .opt { margin: 18px 0; }
    .opt h3 { font-size: 14px; margin: 0 0 10px; color: #444; letter-spacing: .02em; }

    .colors { display: flex; gap: 10px; }
    .color { width: 36px; height: 36px; border-radius: 4px; border: 1px solid #e0e0e0; cursor: pointer; position: relative; background: #eee; }
    .color.is-active { outline: 2px solid #111; outline-offset: 2px; }

    .sizes { display: grid; grid-template-columns: repeat(5, minmax(68px, 1fr)); gap: 8px; }
    .size { border: 1px solid #ddd; border-radius: 4px; padding: 10px 8px; text-align: center; cursor: pointer; font-size: 13px; }
    .size.is-active { border-color: #111; background: #111; color: #fff; }

    /* CTAs: full-width Buy + outlined Cart with wishlist */
    .cta { margin-top: 24px; display: grid; grid-template-columns: 1fr; gap: 10px; }
    .btn { appearance: none; border: none; padding: 0 18px; border-radius: 4px; cursor: pointer; font-weight: 700; height: 56px; }
    .btn.buy { background: #111; color: #fff; width: 100%; }

    .cart-row { display: flex; width: 100%; border: 1px solid #111; border-radius: 4px; overflow: hidden; }
    .cart-main { flex: 1; background: #fff; color: #111; height: 56px; display: flex; align-items: center; justify-content: center; font-weight: 700; cursor: pointer; }
    .wishlist { width: 64px; min-width: 64px; height: 56px; background: #fff; border-left: 1px solid #111; display: flex; align-items: center; justify-content: center; cursor: pointer; }
    .wishlist span { font-size: 18px; }

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
        <div class="emoji-frame"><div class="emoji" id="emoji">🧥</div></div>
      </div>
      <div class="right">
        <div class="meta" id="sku">SKU -</div>
        <h1 id="title">상품 상세</h1>
        <div class="price" id="price">- 원</div>

        <section class="opt">
          <h3>COLOR</h3>
          <div class="colors" id="colors"></div>
        </section>

        <section class="opt">
          <h3>사이즈</h3>
          <div class="sizes" id="sizes"></div>
        </section>

        <div class="cta">
          <button class="btn buy">바로구매</button>
          <div class="cart-row" role="group" aria-label="장바구니 및 찜">
            <button class="cart-main" type="button">장바구니</button>
            <button class="wishlist" type="button" aria-label="위시리스트">
              <span>♡</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </main>

  <script>
    // 서버에서 전달된 상품 ID
    const productId = '${productId}' || '1';

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

    const data = PRODUCTS[productId] || { name: '상품 ' + productId, emoji: '🧥', price: '-', colors: ['#e5e5e5'], sizes: ['FREE'] };

    // 좌측 이미지는 한 장만: 큰 이모지 하나
    document.getElementById('emoji').textContent = data.emoji;

    // 기본 정보
    document.getElementById('title').textContent = data.name;
    document.getElementById('price').textContent = data.price;
    document.getElementById('sku').textContent = 'SKU ' + ("NJ" + String(productId).padStart(3,'0'));

    // 색상 스와치 생성
    const $colors = document.getElementById('colors');
    data.colors.forEach((c, i) => {
      const d = document.createElement('button');
      d.type = 'button';
      d.className = 'color' + (i === 0 ? ' is-active' : '');
      d.style.background = c;
      d.addEventListener('click', () => {
        document.querySelectorAll('.color').forEach(el => el.classList.remove('is-active'));
        d.classList.add('is-active');
      });
      $colors.appendChild(d);
    });

    // 사이즈 옵션 생성
    const $sizes = document.getElementById('sizes');
    data.sizes.forEach((s, i) => {
      const b = document.createElement('button');
      b.type = 'button';
      b.className = 'size' + (i === 0 ? ' is-active' : '');
      b.textContent = s;
      b.addEventListener('click', () => {
        document.querySelectorAll('.size').forEach(el => el.classList.remove('is-active'));
        b.classList.add('is-active');
      });
      $sizes.appendChild(b);
    });

    // ---- Cart via localStorage ----
    const CART_KEY = 'nef_cart';

    function readCart() {
      try {
        const raw = localStorage.getItem(CART_KEY);
        return raw ? JSON.parse(raw) : [];
      } catch (e) {
        console.warn('Cart read error', e);
        return [];
      }
    }

    function writeCart(cart) {
      try {
        localStorage.setItem(CART_KEY, JSON.stringify(cart));
      } catch (e) {
        console.warn('Cart write error', e);
      }
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

    function getActiveColor() {
      const el = document.querySelector('.color.is-active');
      // return background color value (hex or rgb)
      return el ? (el.style.background || '#000') : '#000';
    }

    function getActiveSize() {
      const el = document.querySelector('.size.is-active');
      return el ? el.textContent : '';
    }

    function parsePriceToNumber(text) {
      const n = parseInt(String(text).replace(/[^0-9]/g, ''), 10);
      return isNaN(n) ? 0 : n;
    }

    function addToCart(item) {
      const cart = readCart();
      const key = (p) => [p.id, p.color, p.size].join('|');
      const targetKey = key(item);
      const found = cart.find(p => key(p) === targetKey);
      if (found) {
        found.qty += item.qty;
      } else {
        cart.push(item);
      }
      writeCart(cart);
      showToast('장바구니에 담았어요');
      if (window.nefUpdateCartBadge) window.nefUpdateCartBadge();
    }

    // Bind Cart and Buy buttons
    const cartBtn = document.querySelector('.cart-main');
    const buyBtn = document.querySelector('.btn.buy');

    cartBtn?.addEventListener('click', () => {
      const payload = {
        id: String(productId),
        name: data.name,
        emoji: data.emoji,
        price: parsePriceToNumber(data.price),
        priceText: data.price,
        color: getActiveColor(),
        size: getActiveSize(),
        qty: 1
      };
      addToCart(payload);
    });

    buyBtn?.addEventListener('click', () => {
      const payload = {
        id: String(productId),
        name: data.name,
        emoji: data.emoji,
        price: parsePriceToNumber(data.price),
        priceText: data.price,
        color: getActiveColor(),
        size: getActiveSize(),
        qty: 1
      };
      addToCart(payload);
      showToast('바로구매 준비중 (데모): 장바구니에 담음');
    });
  </script>
</body>
</html>
