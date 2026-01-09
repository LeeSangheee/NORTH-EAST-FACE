<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>마이페이지 - NORTH EAST FACE</title>
  <style>
    :root { --gray:#f5f5f5; --line:#e5e5e5; --text:#222; --muted:#777; --black:#111; }
    * { box-sizing: border-box; }
    body { margin: 0; font-family: 'Helvetica Neue', Arial, sans-serif; color: var(--text); background: #fff; }
    .page { max-width: 1180px; margin: 0 auto; padding: 28px 20px 40px; }
    .page-title { font-size: 26px; font-weight: 800; margin-bottom: 24px; }
    
    .mypage-layout { display: grid; grid-template-columns: 280px 1fr; gap: 24px; }
    @media(max-width: 980px){ .mypage-layout { grid-template-columns: 1fr; } }
    
    .sidebar { border: 1px solid var(--line); border-radius: 8px; height: fit-content; position: sticky; top: 80px; }
    .sidebar-item { display: block; padding: 14px 16px; border-bottom: 1px solid var(--line); text-decoration: none; color: #666; font-size: 14px; transition: background 0.2s; }
    .sidebar-item:last-child { border-bottom: none; }
    .sidebar-item:hover { background: var(--gray); color: var(--black); }
    .sidebar-item.active { background: var(--black); color: #fff; font-weight: 600; }
    
    .content-area { }
    .panel { background: #fff; border: 1px solid var(--line); border-radius: 8px; padding: 20px; }
    
    .section-title { font-size: 18px; font-weight: 800; margin-bottom: 16px; }
    
    .info-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--line); }
    .info-row:last-child { border-bottom: none; }
    .info-label { color: var(--muted); font-size: 13px; }
    .info-value { font-weight: 600; }
    
    .order-list { display: grid; gap: 12px; }
    .order-item { padding: 14px; border: 1px solid var(--line); border-radius: 6px; display: flex; justify-content: space-between; align-items: center; }
    .order-info { display: flex; flex-direction: column; gap: 4px; }
    .order-date { font-size: 12px; color: var(--muted); }
    .order-status { display: inline-block; padding: 4px 8px; background: #f0f0f0; border-radius: 3px; font-size: 11px; font-weight: 600; }
    
    .empty-msg { padding: 40px; text-align: center; color: var(--muted); }
  </style>
</head>
<body>
  <ui:header />
  <main class="page">
    <h1 class="page-title">마이페이지</h1>
    
    <div class="mypage-layout">
      <aside class="sidebar">
        <a class="sidebar-item active" href="/mypage">회원 정보</a>
        <a class="sidebar-item" href="/mypage/orders">주문 현황</a>
        <a class="sidebar-item" href="/mypage/wishlist">위시리스트</a>
        <a class="sidebar-item" href="/mypage/settings">설정</a>
      </aside>
      
      <div class="content-area">
        <section class="panel">
          <h2 class="section-title">회원 정보</h2>
          
          <div class="info-row">
            <span class="info-label">아이디</span>
            <span class="info-value">${requestScope.username}</span>
          </div>
          
          <div class="info-row">
            <span class="info-label">회원 ID</span>
            <span class="info-value">${requestScope.memberId}</span>
          </div>
          
          <div class="info-row">
            <span class="info-label">가입일</span>
            <span class="info-value">2026-01-09</span>
          </div>
          
          <div class="info-row">
            <span class="info-label">회원 등급</span>
            <span class="info-value">일반 회원</span>
          </div>
        </section>
        
        <section class="panel" style="margin-top: 24px;">
          <h2 class="section-title">최근 주문</h2>
          
          <div class="empty-msg">아직 주문 내역이 없습니다.</div>
        </section>
      </div>
    </div>
  </main>
</body>
</html>
