<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>장바구니 - NORTH EAST FACE</title>
  <style>
    body { margin: 0; font-family: 'Helvetica Neue', Arial, sans-serif; color: #222; }
    .page { max-width: 1000px; margin: 0 auto; padding: 24px; }
    h1 { font-size: 24px; margin: 0 0 16px; }
    .empty { padding: 28px; text-align: center; color: #666; border: 1px dashed #ddd; border-radius: 6px; }

    .list { display: grid; grid-template-columns: 1fr; gap: 12px; }
    .item { display: grid; grid-template-columns: 64px 1fr auto; gap: 14px; align-items: center; border: 1px solid #eee; border-radius: 6px; padding: 12px; }
    .emoji { font-size: 36px; }
    .name { font-weight: 700; margin-bottom: 6px; }
    .opts { font-size: 13px; color: #555; }
    .qty { display: inline-flex; align-items: center; gap: 6px; margin-top: 8px; }
    .qty button { width: 28px; height: 28px; }
    .price { font-weight: 700; }
    .right { text-align: right; }

    .summary { margin-top: 18px; border-top: 1px solid #eee; padding-top: 14px; display: flex; justify-content: space-between; align-items: center; }
    .btn { appearance: none; border: none; padding: 12px 18px; border-radius: 4px; cursor: pointer; font-weight: 700; }
    .btn.primary { background: #111; color: #fff; }
    .btn.secondary { background: #f2f2f2; }
    .actions { display: flex; gap: 10px; }
  </style>
</head>
<body>
  <ui:header />
  <main class="page">
    <h1>장바구니</h1>
    <div id="cartRoot"></div>
  </main>

  <script>
    const KEY = 'nef_cart';
    const $root = document.getElementById('cartRoot');

    function readCart(){
      try { const raw = localStorage.getItem(KEY); return raw ? JSON.parse(raw) : []; }
      catch(e){ return []; }
    }
    function writeCart(list){
      try { localStorage.setItem(KEY, JSON.stringify(list)); if (window.nefUpdateCartBadge) window.nefUpdateCartBadge(); }
      catch(e){ /* ignore */ }
    }

    function currency(n){
      return new Intl.NumberFormat('ko-KR').format(n) + ' 원';
    }

    function render(){
      const cart = readCart();
      if (!cart.length){
        $root.innerHTML = '<div class="empty">장바구니가 비어있어요</div>';
        return;
      }
      let total = 0;
      const frag = document.createDocumentFragment();
      const list = document.createElement('div');
      list.className = 'list';
      cart.forEach((it, idx) => {
        const row = document.createElement('div');
        row.className = 'item';
        total += (it.price || 0) * (it.qty || 1);
        row.innerHTML = `
          <div class="emoji">${it.emoji || '🧥'}</div>
          <div>
            <div class="name">${it.name || '상품'}</div>
            <div class="opts">컬러: <span style="background:${it.color}; display:inline-block; width:14px; height:14px; border:1px solid #ccc; vertical-align:middle"></span> · 사이즈: ${it.size || ''}</div>
            <div class="qty">
              <button type="button" aria-label="감소">-</button>
              <span>${it.qty || 1}</span>
              <button type="button" aria-label="증가">+</button>
              <button type="button" aria-label="삭제" style="margin-left:8px">삭제</button>
            </div>
          </div>
          <div class="right">
            <div class="price">${currency((it.price || 0) * (it.qty || 1))}</div>
          </div>
        `;
        const [minusBtn, , plusBtn, removeBtn] = row.querySelectorAll('.qty button');
        minusBtn.addEventListener('click', () => {
          const list = readCart();
          const p = list[idx];
          p.qty = Math.max(1, (p.qty || 1) - 1);
          writeCart(list); render();
        });
        plusBtn.addEventListener('click', () => {
          const list = readCart();
          const p = list[idx];
          p.qty = (p.qty || 1) + 1;
          writeCart(list); render();
        });
        removeBtn.addEventListener('click', () => {
          const list = readCart();
          list.splice(idx, 1);
          writeCart(list); render();
        });
        list.appendChild(row);
      });
      frag.appendChild(list);
      const summary = document.createElement('div');
      summary.className = 'summary';
      summary.innerHTML = `
        <div>합계: <strong>${currency(total)}</strong></div>
        <div class="actions">
          <button class="btn secondary" id="clearBtn">비우기</button>
          <button class="btn primary">주문하기</button>
        </div>
      `;
      frag.appendChild(summary);
      $root.innerHTML = '';
      $root.appendChild(frag);
      summary.querySelector('#clearBtn').addEventListener('click', () => { writeCart([]); render(); });
    }

    render();
    window.addEventListener('storage', (ev) => { if (ev.key === KEY) render(); });
  </script>
</body>
</html>
