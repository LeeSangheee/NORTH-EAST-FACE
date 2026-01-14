<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<%
  model.Member member = (model.Member) request.getAttribute("member");
  String mName = member != null ? member.getUsername() : "";
  String mEmail = member != null ? member.getEmail() : "";
  String mPhone = member != null ? member.getPhone() : "";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>주문 결제 - NORTH EAST FACE</title>
  <style>
    :root { --gray:#f5f5f5; --line:#e5e5e5; --text:#222; --muted:#777; --black:#111; }
    * { box-sizing: border-box; }
    body { margin: 0; font-family: 'Helvetica Neue', Arial, sans-serif; color: var(--text); background: #fff; }
    .page { max-width: 1180px; margin: 0 auto; padding: 28px 20px 40px; }
    .checkout-title { font-size: 26px; font-weight: 800; margin-bottom: 24px; }
    
    .checkout-layout { display: grid; grid-template-columns: 2fr 1fr; gap: 24px; align-items: start; }
    @media(max-width: 980px){ .checkout-layout { grid-template-columns: 1fr; } }
    
    .panel { background: #fff; border: 1px solid var(--line); border-radius: 8px; padding: 20px; }
    
    .section-title { font-size: 16px; font-weight: 800; margin-bottom: 14px; }
    
    .form-group { margin-bottom: 16px; }
    .form-label { font-size: 13px; font-weight: 600; color: #666; margin-bottom: 6px; display: block; }
    .form-input { width: 100%; padding: 10px 12px; border: 1px solid var(--line); border-radius: 4px; font-size: 14px; font-family: inherit; }
    .form-input:focus { outline: none; border-color: var(--black); }
    
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
    
    .payment-methods { display: flex; gap: 10px; margin-bottom: 16px; }
    .payment-method { flex: 1; padding: 12px; border: 1px solid var(--line); border-radius: 4px; cursor: pointer; text-align: center; transition: all 0.2s; }
    .payment-method.active { background: var(--black); color: #fff; border-color: var(--black); }
    
    .order-summary { position: sticky; top: 80px; }
    .summary-item { display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px solid var(--line); }
    .summary-item:last-child { border-bottom: none; }
    .summary-total { display: flex; justify-content: space-between; font-size: 16px; font-weight: 800; margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--black); }
    
    .checkout-btn { width: 100%; padding: 14px; background: var(--black); color: #fff; border: none; border-radius: 4px; font-size: 16px; font-weight: 800; cursor: pointer; margin-top: 12px; }
    .checkout-btn:hover { background: #333; }
    
    .term { font-size: 12px; color: var(--muted); margin-top: 10px; }
  </style>
</head>
<body>
  <ui:header />
  <main class="page">
    <h1 class="checkout-title">주문 결제</h1>
    
    <div class="checkout-layout">
      <section class="panel">
        <h2 class="section-title">배송 정보</h2>
        <div class="form-group">
          <label class="form-label">이름</label>
          <input type="text" id="nameInput" class="form-input" placeholder="이름을 입력하세요" value="<%= mName %>" />
        </div>
        
        <div class="form-group">
          <label class="form-label">이메일</label>
          <input type="email" id="emailInput" class="form-input" placeholder="이메일을 입력하세요" value="<%= mEmail %>" />
        </div>
        
        <div class="form-group">
          <label class="form-label">전화번호</label>
          <input type="tel" id="phoneInput" class="form-input" placeholder="01012345678" value="<%= mPhone %>" />
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">우편번호</label>
            <div style="display:flex; gap:8px;">
              <input type="text" id="zipInput" class="form-input" placeholder="우편번호" style="flex:1;" readonly />
              <button type="button" id="zipSearch" class="checkout-btn" style="width:auto; padding:0 12px; font-size:13px; height:40px;">우편번호 찾기</button>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">배송 주소</label>
            <input type="text" id="addressInput" class="form-input" placeholder="도로명 주소" readonly />
          </div>
        </div>
        
        <div class="form-group">
          <label class="form-label">상세 주소</label>
          <input type="text" id="detailAddress" class="form-input" placeholder="상세 주소" />
        </div>
        
        <h2 class="section-title" style="margin-top: 24px;">결제 방법</h2>
        <div class="payment-methods">
          <div class="payment-method active" data-method="credit">신용카드</div>
        </div>
        
        <div class="form-group">
          <label class="form-label">카드 번호</label>
          <input type="text" class="form-input" placeholder="1234-5678-9012-3456" maxlength="19" />
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">유효기간</label>
            <input type="text" class="form-input" placeholder="MM/YY" maxlength="5" />
          </div>
          <div class="form-group">
            <label class="form-label">CVC</label>
            <input type="text" class="form-input" placeholder="000" maxlength="3" />
          </div>
        </div>
        
        <div class="form-group">
          <label class="form-label">카드 소유자명</label>
          <input type="text" class="form-input" placeholder="카드에 표기된 이름" />
        </div>
        
        <div class="term">
          • 이 페이지는 데모 페이지입니다. 실제 결제는 진행되지 않습니다.<br/>
          • 테스트 카드 번호: 4111-1111-1111-1111
        </div>
      </section>
      
      <aside class="panel order-summary">
        <h2 class="section-title">주문 요약</h2>
        <div id="summaryItems"></div>
        <div class="summary-total">
          <span>총 결제 금액</span>
          <span id="totalPrice">0 원</span>
        </div>
        <button class="checkout-btn">결제하기</button>
      </aside>
    </div>
  </main>

  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
  <script>
    var KEY = 'nef_cart';
    var CTX = '${pageContext.request.contextPath}';
    var IS_LOGGED_IN = <%= Boolean.TRUE.equals(request.getAttribute("isLoggedIn")) %>;
    var PREFILL_NAME = '<%= mName %>';
    var PREFILL_EMAIL = '<%= mEmail %>';
    var PREFILL_PHONE = '<%= mPhone %>';
    
    function currency(n){ 
      return new Intl.NumberFormat('ko-KR').format(n) + ' 원'; 
    }

    function readLocalCart(){ 
      try { 
        var raw = localStorage.getItem(KEY); 
        return raw ? JSON.parse(raw) : []; 
      } catch(e){ 
        return []; 
      } 
    }

    function fetchDbCart(){
      return fetch(CTX + '/api/cart', {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      })
      .then(function(res){ if (!res.ok) throw new Error('HTTP ' + res.status); return res.json(); })
      .then(function(items){
        if (!Array.isArray(items)) return [];
        return items.map(function(it){
          return {
            name: it.name,
            qty: it.quantity,
            price: it.price
          };
        });
      });
    }

    function loadCart(){
      if (IS_LOGGED_IN) {
        return fetchDbCart().catch(function(){ return readLocalCart(); });
      }
      return Promise.resolve(readLocalCart());
    }
    
    function renderSummary(cart){
      cart = cart || [];
      var html = '';
      var total = 0;
      
      cart.forEach(function(item){
        var line = (item.price || 0) * (item.qty || 1);
        total += line;
        html += '<div class="summary-item">' +
          '<span>' + (item.name || '상품') + ' (' + (item.qty || 1) + '개)</span>' +
          '<span>' + currency(line) + '</span>' +
        '</div>';
      });
      
      document.getElementById('summaryItems').innerHTML = html;
      document.getElementById('totalPrice').textContent = currency(total);
    }
    
    // 결제 방법 선택 (신용카드 고정, UI만 유지)
    document.querySelectorAll('.payment-method').forEach(function(btn){
      btn.addEventListener('click', function(){
        document.querySelectorAll('.payment-method').forEach(function(b){ b.classList.remove('active'); });
        btn.classList.add('active');
      });
    });

    // Prefill inputs
    (function(){
      var nameEl = document.getElementById('nameInput');
      var emailEl = document.getElementById('emailInput');
      var phoneEl = document.getElementById('phoneInput');
      if (nameEl && !nameEl.value) nameEl.value = PREFILL_NAME;
      if (emailEl && !emailEl.value) emailEl.value = PREFILL_EMAIL;
      if (phoneEl && !phoneEl.value) phoneEl.value = PREFILL_PHONE;
    })();

    // Postcode lookup (Daum API - no key needed)
    function openPostcode(){
      new daum.Postcode({
        oncomplete: function(data){
          var addr = data.roadAddress || data.jibunAddress || '';
          var zone = data.zonecode || '';
          var zipEl = document.getElementById('zipInput');
          var addrEl = document.getElementById('addressInput');
          if (zipEl) zipEl.value = zone;
          if (addrEl) addrEl.value = addr;
          var detail = document.getElementById('detailAddress');
          if (detail) detail.focus();
        }
      }).open();
    }
    var zipBtn = document.getElementById('zipSearch');
    if (zipBtn) zipBtn.addEventListener('click', openPostcode);
    
    // 결제 버튼
    document.querySelector('.checkout-btn').addEventListener('click', function(){
      alert('테스트 결제 완료! (실제 결제는 진행되지 않습니다)');
      if (IS_LOGGED_IN) {
        fetch(CTX + '/api/cart', {
          method: 'POST',
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
          credentials: 'same-origin',
          body: 'action=clear'
        }).catch(function(){});
      }
      localStorage.removeItem(KEY);
      window.location.href = CTX + '/';
    });
    
    loadCart().then(renderSummary).catch(function(){ renderSummary(readLocalCart()); });
  </script>
</body>
</html>
