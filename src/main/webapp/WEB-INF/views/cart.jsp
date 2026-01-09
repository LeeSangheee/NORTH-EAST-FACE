<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<%
  Boolean isLoggedIn = (Boolean) request.getAttribute("isLoggedIn");
  boolean showLoginNote = isLoggedIn == null || !isLoggedIn;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>장바구니 - NORTH EAST FACE</title>
  <style>
    :root { --gray:#f5f5f5; --line:#e5e5e5; --text:#222; --muted:#777; --black:#111; }
    * { box-sizing: border-box; }
    body { margin: 0; font-family: 'Helvetica Neue', Arial, sans-serif; color: var(--text); background: #fff; }
    .page { max-width: 1180px; margin: 0 auto; padding: 28px 20px 40px; }
    .cart-title { display: flex; align-items: baseline; gap: 10px; margin-bottom: 16px; }
    .cart-title h1 { margin: 0; font-size: 26px; font-weight: 800; }
    .cart-title .count { color: var(--muted); font-size: 14px; }

    .cart-layout { display: grid; grid-template-columns: 2fr 0.9fr; gap: 24px; align-items: start; }
    @media(max-width: 980px){ .cart-layout { grid-template-columns: 1fr; } }

    .panel { background: #fff; border: 1px solid var(--line); border-radius: 8px; }
    .cart-main { padding: 0; border-radius: 10px; }
    .select-row { display: flex; align-items: center; gap: 8px; padding: 14px 16px; border-bottom: 1px solid var(--line); font-weight: 700; }
    .list { display: flex; flex-direction: column; }
    .item { display: grid; grid-template-columns: 40px 96px 1fr 180px; gap: 14px; align-items: center; padding: 14px 16px; border-bottom: 1px solid var(--line); }
    .item:last-child { border-bottom: none; }
    .item-check { display: flex; justify-content: center; }
    .thumb { width: 96px; height: 96px; border: 1px solid var(--line); border-radius: 6px; background: var(--gray); display: flex; align-items: center; justify-content: center; font-size: 42px; }
    .info { display: flex; flex-direction: column; gap: 6px; }
    .brand { font-size: 12px; color: var(--muted); letter-spacing: 0.01em; }
    .name { font-weight: 800; font-size: 15px; }
    .meta { font-size: 13px; color: var(--muted); display: flex; gap: 8px; align-items: center; }
    .chip { width: 14px; height: 14px; border: 1px solid #ccc; border-radius: 3px; display: inline-block; }
    .opts { display: flex; gap: 10px; align-items: center; font-size: 12px; color: var(--muted); }
    .opts a { color: var(--muted); text-decoration: none; }
    .opt-btns { display: flex; gap: 8px; margin-top: 4px; }
    .ghost-btn { border: 1px solid var(--line); background: #fff; border-radius: 4px; padding: 7px 12px; cursor: pointer; font-size: 12px; }

    .price-col { text-align: right; display: grid; gap: 8px; justify-items: end; }
    .price-main { font-weight: 800; font-size: 16px; }
    .qty { display: inline-flex; align-items: center; gap: 0; border: 1px solid var(--line); border-radius: 4px; overflow: hidden; }
    .qty button { width: 32px; height: 32px; border: none; background: #fff; cursor: pointer; }
    .qty span { padding: 0 12px; font-weight: 700; }
    .buy-btn { width: 120px; height: 36px; border: 1px solid var(--black); background: var(--black); color: #fff; border-radius: 4px; cursor: pointer; font-weight: 700; }

    .cart-actions { display: flex; gap: 10px; padding: 14px 16px; border-top: 1px solid var(--line); }
    .action-btn { border: 1px solid var(--line); background: #fff; padding: 10px 14px; border-radius: 4px; cursor: pointer; font-weight: 700; }

    .notice { margin-top: 18px; padding: 14px 16px; background: #fafafa; border: 1px solid var(--line); border-radius: 6px; font-size: 12px; line-height: 1.7; color: #555; }

    .summary-card { padding: 18px 16px; border-radius: 10px; border: 1px solid var(--line); position: sticky; top: 80px; background: #fff; }
    .summary-title { font-size: 18px; font-weight: 800; margin: 0 0 12px; }
    .summary-rows { display: grid; gap: 10px; margin-bottom: 14px; }
    .s-row { display: flex; justify-content: space-between; font-size: 14px; color: #444; }
    .s-row strong { color: #000; }
    .total-row { border-top: 1px solid var(--line); padding-top: 12px; font-size: 16px; font-weight: 800; }
    .total-row .highlight { color: #e53935; }
    .order-btn { width: 100%; height: 46px; border: none; background: var(--black); color: #fff; border-radius: 6px; font-weight: 800; cursor: pointer; margin-top: 12px; }
    .summary-note { margin: 10px 0 0; font-size: 12px; color: var(--muted); }

    .empty { padding: 60px 20px; text-align: center; color: #666; border: 1px dashed var(--line); border-radius: 8px; }

    input[type=checkbox] { width: 16px; height: 16px; }
  </style>
</head>
<body>
  <ui:header />
  <main class="page">
    <div class="cart-title">
      <h1>장바구니</h1>
      <div class="count" id="titleCount">상품 0개</div>
    </div>
    <div class="cart-layout">
      <section class="panel cart-main">
        <div class="select-row">
          <label><input type="checkbox" id="selectAll" checked> 전체선택</label>
        </div>
        <div id="cartList" class="list"></div>
        <div class="cart-actions">
          <button class="action-btn" id="deleteSelected">선택상품삭제</button>
          <button class="action-btn" id="deleteAll">전체상품삭제</button>
        </div>
        <div class="notice">
          • 단순 변심으로 인한 주문 취소는 결제 후 2시간 이내에 진행해 주세요.<br/>
          • 일부 상품은 준비 중 상태로 전환 후 주문 취소가 불가하며 반품 접수 시 배송비가 부과될 수 있습니다.<br/>
          • 인기 상품은 주문 후 품절이 발생할 수 있습니다.
        </div>
      </section>
      <aside class="summary-card" id="summary"></aside>
    </div>
  </main>

  <script>
    var KEY = 'nef_cart';
    var CTX = '${pageContext.request.contextPath}';
    var IS_LOGGED_IN = <%= !showLoginNote %>;
    
    var $list = document.getElementById('cartList');
    var $summary = document.getElementById('summary');
    var $titleCount = document.getElementById('titleCount');
    var $selectAll = document.getElementById('selectAll');
    var $deleteSelected = document.getElementById('deleteSelected');
    var $deleteAll = document.getElementById('deleteAll');

    var selected = [];
    var currentCart = [];

    // ============ 데이터 조회 함수 ============
    function readCart(){
      return currentCart || [];
    }

    function readLocalStorageCart(){
      try { var raw = localStorage.getItem(KEY); return raw ? JSON.parse(raw) : []; } catch(e){ return []; }
    }

    function writeCart(list){
      if (IS_LOGGED_IN) {
        currentCart = list;
        saveCartToDb(list);
      } else {
        currentCart = list;
        try { localStorage.setItem(KEY, JSON.stringify(list)); if (window.nefUpdateCartBadge) window.nefUpdateCartBadge(); } catch(e){}
      }
    }

    function currency(n){ return new Intl.NumberFormat('ko-KR').format(n) + ' 원'; }
    
    function showToast(text){
      var t = document.getElementById('toast');
      if (!t){ t = document.createElement('div'); t.id='toast'; t.style.position='fixed'; t.style.left='50%'; t.style.bottom='24px'; t.style.transform='translateX(-50%)'; t.style.background='#111'; t.style.color='#fff'; t.style.padding='12px 16px'; t.style.borderRadius='6px'; t.style.boxShadow='0 6px 16px rgba(0,0,0,0.25)'; t.style.zIndex='9999'; document.body.appendChild(t);} 
      t.textContent = text; t.style.opacity='1'; clearTimeout(t._timer); t._timer=setTimeout(function(){ t.style.opacity='0'; },1500);
    }

    // ============ API 호출 함수 ============
    function getCartFromDb(callback) {
      fetch(CTX + '/api/cart/items', { method: 'GET' })
        .then(function(res){ return res.json(); })
        .then(function(items){ 
          if (callback) callback(items || []);
        })
        .catch(function(err){ 
          console.error('DB에서 카트 로드 실패:', err);
          if (callback) callback([]);
        });
    }

    function saveCartToDb(items) {
      fetch(CTX + '/api/cart/migrate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=add&items=' + encodeURIComponent(JSON.stringify(items))
      })
      .catch(function(err){ console.error('DB 저장 실패:', err); });
    }

    function migrateLocalStorageToDb(onSuccess, onFail) {
      var localItems = readLocalStorageCart();
      if (!localItems || localItems.length === 0) {
        if (typeof onSuccess === 'function') onSuccess();
        return;
      }

      fetch(CTX + '/api/cart/migrate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=migrate&items=' + encodeURIComponent(JSON.stringify(localItems))
      })
      .then(function(res){ return res.json(); })
      .then(function(data){
        if (data && data.success) {
          try { localStorage.removeItem(KEY); } catch(e){}
          if (window.nefUpdateCartBadge) window.nefUpdateCartBadge();
          if (typeof onSuccess === 'function') onSuccess();
        } else {
          if (typeof onFail === 'function') onFail();
        }
      })
      .catch(function(err){ 
        console.error('마이그레이션 실패:', err);
        if (typeof onFail === 'function') onFail();
      });
    }

    function syncSelection(len){
      if (!selected || selected.length !== len) selected = new Array(len).fill(true);
    }

    function render(cart){
      if (!cart) cart = readCart();
      currentCart = cart;
      syncSelection(cart.length);
      $titleCount.textContent = '상품 ' + cart.length + '개';

      if (!cart.length){
        $list.innerHTML = '<div class="empty">장바구니가 비어있어요</div>';
        $summary.innerHTML = '';
        $selectAll.checked = false;
        return;
      }

      var html = '';
      var selectedTotal = 0;
      var selectedCount = 0;

      cart.forEach(function(it, idx){
        var line = (it.price || 0) * (it.qty || 1);
        if (selected[idx]) { selectedTotal += line; selectedCount += (it.qty || 1); }
        html += '' +
          '<div class="item">' +
            '<div class="item-check"><input type="checkbox" class="row-check" data-idx="' + idx + '" ' + (selected[idx] ? 'checked' : '') + '></div>' +
            '<div class="thumb">' + (it.emoji || '🧥') + '</div>' +
            '<div class="info">' +
              '<div class="brand">NORTH EAST FACE</div>' +
              '<div class="name">' + (it.name || '상품') + '</div>' +
              '<div class="meta">' +
                '<span class="chip" style="background:' + (it.color || '#ccc') + ';"></span>' +
                '<span>' + (it.size || '') + '</span>' +
                '<span>' + ((it.qty||1)) + '개</span>' +
              '</div>' +
              '<div class="opt-btns">' +
                '<button class="ghost-btn" data-idx="' + idx + '" data-action="change">옵션/수량 변경</button>' +
                '<button class="ghost-btn" data-idx="' + idx + '" data-action="remove">삭제</button>' +
              '</div>' +
            '</div>' +
            '<div class="price-col">' +
              '<div class="price-main">' + currency(line) + '</div>' +
              '<div class="qty">' +
                '<button type="button" data-idx="' + idx + '" data-action="minus">-</button>' +
                '<span>' + (it.qty || 1) + '</span>' +
                '<button type="button" data-idx="' + idx + '" data-action="plus">+</button>' +
              '</div>' +
              '<button class="buy-btn" data-idx="' + idx + '" data-action="buy">바로구매</button>' +
            '</div>' +
          '</div>';
      });

      $list.innerHTML = html;

      // Summary
      $summary.innerHTML = '' +
        '<div class="summary-title">주문 금액</div>' +
        '<div class="summary-rows">' +
          '<div class="s-row"><span>상품금액</span><strong>' + currency(selectedTotal) + '</strong></div>' +
          '<div class="s-row"><span>총 할인 금액</span><strong>0 원</strong></div>' +
          '<div class="s-row total-row"><span>결제 예상 금액</span><strong class="highlight">' + currency(selectedTotal) + '</strong></div>' +
        '</div>' +
        '<button class="order-btn" id="orderBtn">총 ' + selectedCount + '개 | ' + currency(selectedTotal) + ' 주문하기</button>'
        <% if (showLoginNote) { %>
        + '<p class="summary-note">로그인 후 최대 혜택가를 확인하세요.</p>'
        <% } %>
        ;

      bindRowEvents(cart);
      bindSummaryEvents(cart);
      updateSelectAllState();
    }

    function updateSelectAllState(){
      var allChecked = selected.length && selected.every(function(v){ return v; });
      $selectAll.checked = allChecked;
    }

    function bindRowEvents(cart){
      var checks = document.querySelectorAll('.row-check');
      checks.forEach(function(chk){
        chk.addEventListener('change', function(){
          var i = parseInt(chk.getAttribute('data-idx'), 10);
          selected[i] = chk.checked;
          render();
        });
      });

      document.querySelectorAll('[data-action="minus"]').forEach(function(btn){
        btn.addEventListener('click', function(){
          var i = parseInt(btn.getAttribute('data-idx'), 10);
          var list = readCart();
          list[i].qty = Math.max(1, (list[i].qty || 1) - 1);
          writeCart(list); render(list);
        });
      });
      document.querySelectorAll('[data-action="plus"]').forEach(function(btn){
        btn.addEventListener('click', function(){
          var i = parseInt(btn.getAttribute('data-idx'), 10);
          var list = readCart();
          list[i].qty = (list[i].qty || 1) + 1;
          writeCart(list); render(list);
        });
      });
      document.querySelectorAll('[data-action="remove"]').forEach(function(btn){
        btn.addEventListener('click', function(){
          var i = parseInt(btn.getAttribute('data-idx'), 10);
          var list = readCart();
          list.splice(i,1);
          writeCart(list); selected.splice(i,1); render(list);
        });
      });
      document.querySelectorAll('[data-action="change"]').forEach(function(btn){
        btn.addEventListener('click', function(){ showToast('옵션 변경은 상세 페이지에서 진행해주세요'); });
      });
      document.querySelectorAll('[data-action="buy"]').forEach(function(btn){
        btn.addEventListener('click', function(){
          <% if (!showLoginNote) { %>
            window.location.href = CTX + '/checkout';
          <% } else { %>
            if (window.IS_LOGGED_IN) { window.location.href = CTX + '/checkout'; return; }
            window.showLoginModal && window.showLoginModal();
          <% } %>
        });
      });
    }

    function bindSummaryEvents(cart){
      var orderBtn = document.getElementById('orderBtn');
      if (orderBtn) orderBtn.addEventListener('click', function(){
        <% if (!showLoginNote) { %>
          window.location.href = CTX + '/checkout';
        <% } else { %>
          if (window.IS_LOGGED_IN) { window.location.href = CTX + '/checkout'; return; }
          window.showLoginModal && window.showLoginModal();
        <% } %>
      });
    }

    $selectAll.addEventListener('change', function(){
      selected = selected.map(function(){ return $selectAll.checked; });
      render();
    });

    $deleteSelected.addEventListener('click', function(){
      var list = readCart();
      var next = [];
      var nextSel = [];
      list.forEach(function(it, idx){
        if (!selected[idx]) { next.push(it); nextSel.push(true); }
      });
      selected = nextSel;
      writeCart(next); render(next);
    });

    $deleteAll.addEventListener('click', function(){
      writeCart([]); selected = []; render([]);
    });

    window.addEventListener('storage', function(ev){ if (ev.key === KEY && !IS_LOGGED_IN) render(); });

    // ============ 초기화 ============
    function initCart() {
      if (IS_LOGGED_IN) {
        var localItems = readLocalStorageCart();
        if (localItems && localItems.length > 0) {
          render(localItems); // 1) 로컬 먼저 렌더링
          migrateLocalStorageToDb(function(){ // 2) 마이그레이션 성공 시 DB에서 새로 조회하여 렌더
            getCartFromDb(function(items){
              var serverItems = (items || []).map(function(it){
                return {
                  productId: it.productId,
                  qty: it.quantity,
                  price: it.price,
                  name: it.name,
                  emoji: '🧥'
                };
              });
              render(serverItems);
            });
          }, function(){
            // 실패 시 로컬 그대로 유지 (아무 것도 하지 않음)
          });
        } else {
          getCartFromDb(function(items){
            var serverItems = (items || []).map(function(it){
              return {
                productId: it.productId,
                qty: it.quantity,
                price: it.price,
                name: it.name,
                emoji: '🧥'
              };
            });
            render(serverItems);
          });
        }
      } else {
        render();
      }
    }

    window.checkAndMigrateCart = function() {
      if (IS_LOGGED_IN) {
        migrateLocalStorageToDb();
      }
    };

    initCart();
  </script>
</body>
</html>
