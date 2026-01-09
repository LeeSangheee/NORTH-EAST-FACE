<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%
    // 이미 로그인된 경우 홈으로 리다이렉트
    Boolean isLoggedIn = (Boolean) request.getAttribute("isLoggedIn");
    if (isLoggedIn != null && isLoggedIn) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: #fff; }
        
        .container { max-width: 600px; margin: 24px auto; padding: 0 20px; }
        
        .page-title { font-size: 20px; font-weight: 600; margin-bottom: 24px; text-align: center; color: #111; }
        
        .msg {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
            font-size: 14px;
        }
        .error { background: #ffeaea; color: #c0392b; }
        .success { background: #e8f7ef; color: #1e8449; }
        
        .input-with-button {
            display: flex;
            gap: 4px;
            justify-content: space-between;
            align-items: center;
        }
        #username {
            flex-grow: 1;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 20px;
            position: relative;
        }
        
        .form-row {
            display: flex;
            gap: 8px;
            margin-bottom: 20px;
            align-items: flex-end;
        }
        
        .form-row .form-group { margin-bottom: 0; flex: 1; }
        
        label {
            font-size: 13px;
            color: #666;
            font-weight: 500;
        }
        
        input[type="text"],
        input[type="email"],
        input[type="password"] {
            padding: 12px;
            font-size: 16px;
            border: none;
            border-bottom: 1px solid #ddd;
            background: transparent;
            font-family: inherit;
            transition: border-color 0.2s;
        }
        
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-bottom-color: #111;
        }
        
        input::placeholder { color: #aaa; }
        
        .btn-check {
            padding: 10px 16px;
            background: #111;
            color: #fff;
            border: none;
            font-size: 13px;
            cursor: pointer;
            border-radius: 4px;
            white-space: nowrap;
            height: 42px;
        }
        
        .btn-check:hover { background: #333; }
        
        .check-status {
            font-size: 12px;
            margin-top: 4px;
            min-height: 16px;
        }
        .check-status.ok { color: #1e8449; }
        .check-status.err { color: #c0392b; }
        
        .terms {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin: 24px 0;
            padding: 16px 0;
            border-top: 1px solid #e0e0e0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .term-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
        
        input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #111;
        }
        
        .term-label { flex: 1; cursor: pointer; }
        .term-arrow { color: #999; font-size: 16px; }
        
        .btn-submit {
            width: 100%;
            padding: 14px;
            background: #111;
            color: #fff;
            border: none;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            border-radius: 4px;
            margin-top: 24px;
            transition: background 0.2s;
        }
        
        .btn-submit:hover { background: #333; }
        .btn-submit:active { background: #000; }
    </style>
</head>
<body>

<t:header />

<div class="container">
    <h2 class="page-title">회원가입</h2>
    
    <c:if test="${not empty error}">
        <div class="msg error">${error}</div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="msg success">${success}</div>
    </c:if>
    
    <form method="post" action="${pageContext.request.contextPath}/register" onsubmit="return validateForm();">
        <div class="form-row">
            <div class="form-group">
                <label for="username">아이디 (영문/숫자)</label>
                <div class="input-with-button">
                <input type="text" id="username" name="username" maxlength="64" 
                       pattern="[a-zA-Z0-9]+" required value="${param.username}" 
                       placeholder="영문자와 숫자만 입력해주세요"
                       onblur="validateUsername();">
                       <button type="button" class="btn-check" onclick="checkDuplicate(); return false;">중복확인</button>
                </div>
                <div id="usernameStatus" class="check-status"></div>
            </div>
            
        </div>
        
        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" minlength="6" required 
                   placeholder="6자 이상 입력해주세요" onblur="validatePassword();">
            <div id="passwordStatus" class="check-status"></div>
        </div>
        
        <div class="form-group">
            <label for="confirm">비밀번호 확인</label>
            <input type="password" id="confirm" name="confirm" minlength="6" required 
                   placeholder="비밀번호를 다시 입력해주세요" onblur="validateConfirm();">
            <div id="confirmStatus" class="check-status"></div>
        </div>
        
        <div class="form-group">
            <label for="email">이메일</label>
            <input type="email" id="email" name="email" maxlength="255" required 
                   value="${param.email}" placeholder="이메일을 입력해주세요" onblur="validateEmail();">
            <div id="emailStatus" class="check-status"></div>
        </div>
        
        <div class="form-group">
            <label for="phone">휴대전화번호</label>
            <input type="text" id="phone" name="phone" maxlength="32" required 
                   value="${param.phone}" placeholder="010-1234-5678" onblur="validatePhone();">
            <div id="phoneStatus" class="check-status"></div>
        </div>
        
        <div class="terms">
            <div class="term-item">
                <input type="checkbox" id="terms" name="terms" onchange="toggleAll();">
                <label for="terms" class="term-label">전체 동의</label>
            </div>
            <div class="term-item">
                <input type="checkbox" id="privacy" name="privacy" required onchange="updateAllCheck();">
                <label for="privacy" class="term-label">개인정보 취급방침 동의 (필수)</label>
                <span class="term-arrow">›</span>
            </div>
            <div class="term-item">
                <input type="checkbox" id="marketing" name="marketing" onchange="updateAllCheck();">
                <label for="marketing" class="term-label">마케팅 정보 수신 동의 (선택)</label>
                <span class="term-arrow">›</span>
            </div>
        </div>
        
        <button class="btn-submit" type="submit">회원가입</button>
    </form>
</div>

<script>
var usernameChecked = false;
var usernameAvailable = false;

function validateUsername() {
    const username = document.getElementById('username').value.trim();
    const statusEl = document.getElementById('usernameStatus');
    
    if (!username) {
        statusEl.textContent = '';
        statusEl.className = 'check-status';
        usernameChecked = false;
        usernameAvailable = false;
        return;
    }
    
    if (!/^[a-zA-Z0-9]+$/.test(username)) {
        statusEl.textContent = '✗ 영문자와 숫자만 사용 가능합니다.';
        statusEl.className = 'check-status err';
        usernameChecked = false;
        usernameAvailable = false;
        return;
    }
    
    statusEl.textContent = '중복확인을 진행해주세요.';
    statusEl.className = 'check-status';
    usernameChecked = false;
    usernameAvailable = false;
}

async function checkDuplicate() {
    const username = document.getElementById('username').value.trim();
    const statusEl = document.getElementById('usernameStatus');
    
    if (!username) {
        statusEl.textContent = '아이디를 입력해주세요.';
        statusEl.className = 'check-status err';
        usernameChecked = false;
        return;
    }
    
    if (!/^[a-zA-Z0-9]+$/.test(username)) {
        statusEl.textContent = '✗ 영문자와 숫자만 사용 가능합니다.';
        statusEl.className = 'check-status err';
        usernameChecked = false;
        usernameAvailable = false;
        return;
    }
    
    try {
        const resp = await fetch('${pageContext.request.contextPath}/api/check-username?username=' + encodeURIComponent(username));
        const data = await resp.json();
        
        if (data.status === 200 && data.message === 'available') {
            statusEl.textContent = '✓ 사용 가능한 아이디입니다.';
            statusEl.className = 'check-status ok';
            usernameChecked = true;
            usernameAvailable = true;
        } else {
            statusEl.textContent = '✗ 이미 사용 중인 아이디입니다.';
            statusEl.className = 'check-status err';
            usernameChecked = true;
            usernameAvailable = false;
        }
    } catch (err) {
        statusEl.textContent = '확인 중 오류 발생';
        statusEl.className = 'check-status err';
        console.error(err);
    }
}

function validatePassword() {
    const password = document.getElementById('password').value.trim();
    const statusEl = document.getElementById('passwordStatus');
    
    if (!password) {
        statusEl.textContent = '';
        statusEl.className = 'check-status';
        return;
    }
    
    if (password.length < 6) {
        statusEl.textContent = '✗ 비밀번호는 6자 이상이어야 합니다.';
        statusEl.className = 'check-status err';
    } else {
        statusEl.textContent = '✓ 사용 가능한 비밀번호입니다.';
        statusEl.className = 'check-status ok';
    }
}

function validateConfirm() {
    const password = document.getElementById('password').value.trim();
    const confirm = document.getElementById('confirm').value.trim();
    const statusEl = document.getElementById('confirmStatus');
    
    if (!confirm) {
        statusEl.textContent = '';
        statusEl.className = 'check-status';
        return;
    }
    
    if (password !== confirm) {
        statusEl.textContent = '✗ 비밀번호가 일치하지 않습니다.';
        statusEl.className = 'check-status err';
    } else {
        statusEl.textContent = '✓ 비밀번호가 일치합니다.';
        statusEl.className = 'check-status ok';
    }
}

function validateEmail() {
    const email = document.getElementById('email').value.trim();
    const statusEl = document.getElementById('emailStatus');
    
    if (!email) {
        statusEl.textContent = '';
        statusEl.className = 'check-status';
        return;
    }
    
    if (!email.includes('@') || !email.includes('.')) {
        statusEl.textContent = '✗ 유효한 이메일을 입력해주세요.';
        statusEl.className = 'check-status err';
    } else {
        statusEl.textContent = '✓ 올바른 이메일 형식입니다.';
        statusEl.className = 'check-status ok';
    }
}

function validatePhone() {
    const phone = document.getElementById('phone').value.trim();
    const statusEl = document.getElementById('phoneStatus');
    
    if (!phone) {
        statusEl.textContent = '';
        statusEl.className = 'check-status';
        return;
    }
    
    const cleaned = phone.replace(/-/g, '');
    if (!/^\d{10,11}$/.test(cleaned)) {
        statusEl.textContent = '✗ 유효한 휴대폰번호를 입력해주세요. (10-11자리 숫자)';
        statusEl.className = 'check-status err';
    } else {
        statusEl.textContent = '✓ 올바른 휴대폰번호입니다.';
        statusEl.className = 'check-status ok';
    }
}

function toggleAll() {
    const termsAll = document.getElementById('terms').checked;
    document.getElementById('privacy').checked = termsAll;
    document.getElementById('marketing').checked = termsAll;
}

function updateAllCheck() {
    const privacy = document.getElementById('privacy').checked;
    const marketing = document.getElementById('marketing').checked;
    document.getElementById('terms').checked = privacy && marketing;
}

function validateForm() {
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();
    const confirm = document.getElementById('confirm').value.trim();
    const email = document.getElementById('email').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const terms = document.getElementById('terms').checked;
    
    // 0. 아이디 형식
    if (!/^[a-zA-Z0-9]+$/.test(username)) {
        alert('아이디는 영문자와 숫자만 사용 가능합니다.');
        document.getElementById('username').focus();
        return false;
    }
    
    // 1. 중복확인 여부
    if (!usernameAvailable) {
        alert('아이디 중복확인을 완료해주세요.');
        return false;
    }
    
    // 2. 비밀번호 일치
    if (password !== confirm) {
        alert('비밀번호와 확인 비밀번호가 일치하지 않습니다.');
        document.getElementById('confirm').focus();
        return false;
    }
    
    // 3. 비밀번호 길이
    if (password.length < 6) {
        alert('비밀번호는 6자 이상이어야 합니다.');
        document.getElementById('password').focus();
        return false;
    }
    
    // 4. 이메일 유효성 (간단히)
    if (!email.includes('@')) {
        alert('유효한 이메일을 입력해주세요.');
        document.getElementById('email').focus();
        return false;
    }
    
    // 5. 휴대폰 유효성 (숫자만)
    if (!/^\d{10,11}$/.test(phone.replace(/-/g, ''))) {
        alert('유효한 휴대폰번호를 입력해주세요. (숫자만)');
        document.getElementById('phone').focus();
        return false;
    }
    
    // 6. 개인정보 취급방침 동의 (필수)
    const privacy = document.getElementById('privacy').checked;
    if (!privacy) {
        alert('개인정보 취급방침 동의는 필수입니다.');
        return false;
    }
    
    return true;
}
</script>

</body>
</html>
