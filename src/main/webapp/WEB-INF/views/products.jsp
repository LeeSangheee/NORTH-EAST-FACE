<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="t" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - NORTH EAST FACE®</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, sans-serif; 
            background: #f8f8f8;
            color: #111;
            line-height: 1.6;
        }
        
        /* 상품 그리드 */
        .products-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 24px;
        }
        
        .products-header {
            margin-bottom: 32px;
        }
        
        .products-header h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .products-count {
            color: #666;
            font-size: 14px;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }
        
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }
        
        .product-image {
            position: relative;
            width: 100%;
            padding-top: 100%;
            background: #f0f0f0;
            overflow: hidden;
        }
        
        .product-image img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .product-image .placeholder {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 64px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .product-brand {
            position: absolute;
            top: 12px;
            right: 12px;
            background: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .product-info {
            padding: 16px;
        }
        
        .product-name {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 8px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .product-price {
            font-size: 18px;
            font-weight: 700;
            color: #111;
        }
        
        .product-stock {
            margin-top: 8px;
            font-size: 13px;
            color: #666;
        }
        
        .product-stock.low-stock {
            color: #e53e3e;
            font-weight: 600;
        }
        
        .no-products {
            text-align: center;
            padding: 80px 20px;
            color: #666;
        }
        
        .no-products-icon {
            font-size: 64px;
            margin-bottom: 16px;
        }
        
        .no-products h2 {
            font-size: 24px;
            margin-bottom: 8px;
            color: #333;
        }
        
        /* 로딩 */
        .loading {
            text-align: center;
            padding: 80px 20px;
            color: #666;
        }
    </style>
</head>
<body>
    <t:header/>
    
    <div class="products-container">
        <div class="products-header">
            <h1>
                <c:choose>
                    <c:when test="${not empty categoryName}">
                        <c:out value="${categoryName}"/>
                    </c:when>
                    <c:otherwise>전체 상품</c:otherwise>
                </c:choose>
            </h1>
            <p class="products-count">총 <strong>${products.size()}</strong>개의 상품</p>
        </div>
        
        <c:choose>
            <c:when test="${empty products}">
                <div class="no-products">
                    <div class="no-products-icon">📦</div>
                    <h2>등록된 상품이 없습니다</h2>
                    <p>새로운 상품이 곧 준비될 예정입니다.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="products-grid">
                    <c:forEach var="product" items="${products}">
                        <a href="${pageContext.request.contextPath}/product-detail?id=${product.productId}" class="product-card">
                            <div class="product-image">
                                <c:choose>
                                    <c:when test="${not empty product.imageFileName}">
                                        <img src="${product.imageFileName}" 
                                             alt="${product.name}"
                                             onerror="this.src='${pageContext.request.contextPath}/static/images/logo.png'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/static/images/logo.png" alt="${product.name}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">
                                    <c:out value="${product.name}"/>
                                </h3>
                                <div class="product-price">
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol=""/>원
                                </div>
                                <c:choose>
                                    <c:when test="${product.stockQty <= 0}">
                                        <div class="product-stock low-stock">품절</div>
                                    </c:when>
                                    <c:when test="${product.stockQty < 10}">
                                        <div class="product-stock low-stock">재고 ${product.stockQty}개</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="product-stock">재고 있음</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        // 로컬스토리지 카트 수량 표시
        function updateCartCount() {
            const cart = JSON.parse(localStorage.getItem('cart') || '[]');
            const count = cart.reduce((sum, item) => sum + (item.quantity || 0), 0);
            const badge = document.getElementById('cartCount');
            if (badge) {
                if (count > 0) {
                    badge.textContent = count > 99 ? '99+' : count;
                    badge.style.display = 'inline-block';
                } else {
                    badge.style.display = 'none';
                }
            }
        }
        
        updateCartCount();
        
        // 카트 변경 감지
        window.addEventListener('storage', updateCartCount);
    </script>
</body>
</html>
