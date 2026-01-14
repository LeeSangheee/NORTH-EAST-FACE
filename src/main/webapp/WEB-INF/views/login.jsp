<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
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
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 20px;
            position: relative;
        }
        
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
        input[type="password"]:focus {
            outline: none;
            border-bottom-color: #111;
        }
        
        input::placeholder { color: #aaa; }
        
        .check-status {
            font-size: 12px;
            margin-top: 4px;
            min-height: 16px;
        }
        .check-status.ok { color: #1e8449; }
        .check-status.err { color: #c0392b; }
        
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
        
        .footer-links {
            display: flex;
            justify-content: center;
            gap: 16px;
            margin-top: 24px;
            font-size: 13px;
        }
        
        .footer-links a {
            color: #666;
            text-decoration: none;
        }
        
        .footer-links a:hover {
            color: #111;
            text-decoration: underline;
        }
    </style>
</head>
<body>

<t:header />

<div class="container">
    <h2 class="page-title">로그인</h2>
    
    <%-- 세션에서 에러 메시지를 읽고 즉시 제거 --%>
    <c:set var="errorMessage" value="${sessionScope.error}" />
    <c:remove var="error" scope="session" />
    
    <c:if test="${not empty errorMessage}">
        <div class="msg error">${errorMessage}</div>
    </c:if>
    
    <form method="post" action="${pageContext.request.contextPath}/login" onsubmit="return validateForm();">
        <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" required placeholder="you@example.com">
            <div id="emailStatus" class="check-status"></div>
        </div>
        
        <div class="form-group">
            <label for="password">비밀번호</label>
            <input type="password" id="password" name="password" required 
                   placeholder="비밀번호를 입력해주세요" onblur="validatePassword();">
            <div id="passwordStatus" class="check-status"></div>
        </div>
        
        <button class="btn-submit" type="submit">로그인</button>
    </form>
    
    <div class="footer-links">
        <a href="${pageContext.request.contextPath}/register">회원가입</a>
        <span>|</span>
        <a href="#">비밀번호 찾기</a>
    </div>
</div>

<script>
function validateEmail() {
    const email = document.getElementById('email').value.trim();
    const statusEl = document.getElementById('emailStatus');
    if (!statusEl) return;
    if (!email) {
        statusEl.textContent = '';
        statusEl.className = 'check-status';
        return;
    }
    statusEl.textContent = '';
    statusEl.className = 'check-status';
}

function validatePassword() {
    const password = document.getElementById('password').value.trim();
    const statusEl = document.getElementById('passwordStatus');
    
    if (!password) {
        statusEl.textContent = '';
        statusEl.className = 'check-status';
        return;
    }
    
    statusEl.textContent = '';
    statusEl.className = 'check-status';
}

function validateForm() {
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value.trim();
    
    if (!email) {
        alert('이메일을 입력해주세요.');
        document.getElementById('email').focus();
        return false;
    }
    
    if (!password) {
        alert('비밀번호를 입력해주세요.');
        document.getElementById('password').focus();
        return false;
    }
    
    return true;
}
</script>

</body>
</html>
