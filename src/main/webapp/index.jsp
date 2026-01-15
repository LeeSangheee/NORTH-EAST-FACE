<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.ProductDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags" %>
<%
    // Get latest 8 products if not already set by servlet
    if (request.getAttribute("newArrivals") == null) {
        ProductDAO productDAO = new ProductDAO();
        List<ProductDAO.Product> newArrivals = productDAO.getLatestProducts(8);
        request.setAttribute("newArrivals", newArrivals);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>NORTH EAST FACE® - Never Stop Coding</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; }
        .hero { position: relative; height: 78vh; min-height: 520px; color: white; overflow: hidden; display: flex; align-items: center; justify-content: center; text-align: center; }
        .hero-carousel { position: absolute; inset: 0; }
        .hero-slide { position: absolute; inset: 0; background-size: cover; background-position: center; opacity: 0; transition: opacity 0.8s ease-in-out; }
        .hero-slide.is-active { opacity: 1; }
        .hero::before { content: ""; position: absolute; inset: 0; background: linear-gradient(180deg, rgba(0,0,0,0.45), rgba(0,0,0,0.35)); }
        .hero-content { position: relative; z-index: 1; padding: 0 1.5rem; }
        .hero-content h1 { font-size: 3.8rem; font-weight: 700; margin-bottom: 0.8rem; letter-spacing: 0.01em; text-shadow: 2px 2px 8px rgba(0,0,0,0.55); text-transform: uppercase; }
        .hero-content .hero-sub { font-size: 1.1rem; font-weight: 600; letter-spacing: 0.05em; margin-bottom: 1rem; text-shadow: 1px 1px 5px rgba(0,0,0,0.45); }
        .hero-content .hero-meta { display: inline-flex; gap: 10px; align-items: center; font-size: 1.25rem; font-weight: 800; letter-spacing: 0.1em; margin-bottom: 0.4rem; text-shadow: 1px 1px 6px rgba(0,0,0,0.5); }
        .hero-nav { position: absolute; inset: 0; display: flex; justify-content: space-between; align-items: center; pointer-events: none; padding: 0 18px; z-index: 2; }
        .hero-nav button { pointer-events: all; background: rgba(0,0,0,0.35); color: #fff; border: 1px solid rgba(255,255,255,0.35); border-radius: 50%; width: 44px; height: 44px; font-size: 20px; cursor: pointer; transition: background 0.2s, transform 0.2s; }
        .hero-nav button:hover { background: rgba(0,0,0,0.55); transform: translateY(-2px); }
        .hero-nav button:focus { outline: 2px solid #fff; outline-offset: 2px; }
        .hero-dots { position: absolute; bottom: 28px; left: 50%; transform: translateX(-50%); display: flex; gap: 10px; z-index: 2; }
        .hero-dots button { width: 11px; height: 11px; border-radius: 50%; border: 1px solid #fff; background: rgba(255,255,255,0.4); cursor: pointer; transition: background 0.2s, transform 0.2s; }
        .hero-dots button.is-active { background: #fff; transform: scale(1.05); }
        .new-arrivals { padding: 4rem 0; background: #fff; overflow: hidden; }
        .new-arrivals-header { text-align: center; margin-bottom: 2.5rem; }
        .new-arrivals-header h2 { font-size: 2.8rem; margin-bottom: 0.5rem; font-weight: 700; }
        .new-arrivals-header h2 .new-text { color: #e53935; }
        .new-arrivals-header p { color: #666; font-size: 1rem; letter-spacing: 0.02em; }
        .products-slider { position: relative; max-width: 1200px; margin: 0 auto; }
        .products-track-container { overflow: hidden; width: 100%; }
        .products-track { display: flex; gap: 20px; will-change: transform; user-select: none; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; cursor: grab; }
        .products-track:active { cursor: grabbing; }
        /* Ensure anchor wrapper doesn't add link styling */
        .products-track a { text-decoration: none; color: inherit; display: block; }
        /* Keep original card width by sizing the flex item (anchor) */
        .products-track .product-link { flex: 0 0 280px; }
        /* Make inner card fill the anchor width */
        .product-card { width: 100%; }
        .product-card { flex: 0 0 280px; background: #fff; border: 1px solid #e0e0e0; border-radius: 4px; overflow: hidden; cursor: pointer; transition: transform 0.3s, box-shadow 0.3s; }
        .product-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
        .product-image { width: 100%; height: 280px; background: #f5f5f5; display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden; }
        .product-image img { width: 100%; height: 100%; object-fit: cover; object-position: center; }
        .product-badge { position: absolute; top: 12px; right: 12px; display: flex; gap: 6px; }
        .badge { background: #000; color: #fff; padding: 4px 8px; font-size: 0.7rem; font-weight: 600; border-radius: 2px; text-transform: uppercase; }
        .product-info { padding: 1.2rem; }
        .product-name { font-size: 0.95rem; font-weight: 600; margin-bottom: 0.8rem; line-height: 1.3; min-height: 2.6em; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .product-price { display: flex; align-items: center; gap: 8px; }
        .discount-rate { color: #e53935; font-weight: 700; font-size: 1rem; }
        .sale-price { font-size: 1.05rem; font-weight: 700; }
        .original-price { color: #999; text-decoration: line-through; font-size: 0.9rem; }
        .container { max-width: 1200px; margin: 0 auto; padding: 0 2rem; }
        .footer { background: #000; color: white; padding: 3rem 0 1rem; }
        .footer-content { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin-bottom: 2rem; }
        .footer-section h4 { margin-bottom: 1rem; text-transform: uppercase; letter-spacing: 1px; }
        .footer-section ul { list-style: none; line-height: 1.8; color: #ccc; }
        .footer-bottom { text-align: center; color: #777; font-size: 0.9rem; }
    </style>
</head>
<body>
    <ui:header />

    <section class="hero">
        <div class="hero-carousel" id="heroCarousel">
            <div class="hero-slide is-active" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner1.webp');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner2.webp');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner3.webp');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/static/images/carousel/banner4.webp');"></div>
        </div>
        <div class="hero-nav" aria-hidden="true">
            <button type="button" id="heroPrev" aria-label="Previous banner">‹</button>
            <button type="button" id="heroNext" aria-label="Next banner">›</button>
        </div>
        <div class="hero-content">
        </div>
        <div class="hero-dots" id="heroDots" aria-label="Hero banners"></div>
    </section>

    <section class="new-arrivals">
        <div class="container">
            <div class="new-arrivals-header">
                <h2><span class="new-text">New</span> Arrivals</h2>
                <p>가장 먼저 만나 보는 신상품 컬렉션</p>
            </div>
            <div class="products-slider">
                <div class="products-track-container">
                    <div class="products-track" id="productsTrack">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container footer-content">
            <div class="footer-section">
                <h4>NORTH EAST FACE®</h4>
                <ul>
                    <li>Never Stop Coding</li>
                    <li>For Extreme Developers</li>
                    <li>Since 2024</li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Support</h4>
                <ul>
                    <li>FAQ</li>
                    <li>Warranty</li>
                    <li>Contact</li>
                </ul>
            </div>
            <div class="footer-section">
                <h4>Community</h4>
                <ul>
                    <li>Hackathons</li>
                    <li>Meetups</li>
                    <li>Careers</li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            © 2026 NORTH EAST FACE®. Never Stop Coding.
        </div>
    </footer>
    <script>
        (function() {
            const slides = Array.from(document.querySelectorAll('#heroCarousel .hero-slide'));
            const dotsContainer = document.getElementById('heroDots');
            const prevBtn = document.getElementById('heroPrev');
            const nextBtn = document.getElementById('heroNext');
            if (!slides.length || !dotsContainer || !prevBtn || !nextBtn) return;

            let current = 0;
            let timer;

            const setActive = (idx) => {
                slides.forEach((s, i) => s.classList.toggle('is-active', i === idx));
                Array.from(dotsContainer.children).forEach((d, i) => d.classList.toggle('is-active', i === idx));
                current = idx;
            };

            slides.forEach((_, i) => {
                const b = document.createElement('button');
                b.type = 'button';
                b.setAttribute('aria-label', '배너 ' + (i + 1));
                b.addEventListener('click', () => {
                    clearInterval(timer);
                    setActive(i);
                    start();
                });
                dotsContainer.appendChild(b);
            });

            const next = () => setActive((current + 1) % slides.length);
            const prev = () => setActive((current - 1 + slides.length) % slides.length);
            const start = () => {
                timer = setInterval(next, 4500);
            };

            prevBtn.addEventListener('click', () => {
                clearInterval(timer);
                prev();
                start();
            });

            nextBtn.addEventListener('click', () => {
                clearInterval(timer);
                next();
                start();
            });

            setActive(0);
            start();
        })();

        // Products slider - TRUE INFINITE LOOP (2 sets with boundary jump)
        (function() {
            const track = document.getElementById('productsTrack');
            if (!track) {
                alert('Track element not found!');
                return;
            }

            // Context path for building servlet URLs
            var CP = '${pageContext.request.contextPath}';

            // Get products from server-side attribute
            const products = [
                <c:forEach var="p" items="${newArrivals}" varStatus="status">
                {
                    id: ${p.productId},
                    name: '<c:out value="${p.name}"/>',
                    image: '<c:out value="${p.imageFileName}"/>',
                    price: '<fmt:formatNumber value="${p.price}" pattern="#,##0" /> 원'
                }${!status.last ? ',' : ''}
                </c:forEach>
            ];

            if (products.length === 0) {
                track.innerHTML = '<div style="padding: 40px; text-align: center; color: #666;">등록된 신상품이 없습니다.</div>';
                return;
            }

            const CARD_WIDTH = 300;
            const TOTAL = products.length; // 8
            let position = 0;
            let isDragging = false;
            let startPos = 0;
            let currentTranslate = 0;
            let prevTranslate = 0;
            let animationID = 0;
            let autoPlayInterval = null;

            // Render 2 sets (each card wrapped with anchor to product-detail servlet)
            function renderCards() {
                track.innerHTML = '';
                for (let copy = 0; copy < 2; copy++) {
                    products.forEach(function(p) {
                        const a = document.createElement('a');
                        a.className = 'product-link';
                        a.draggable = false;
                        a.href = CP + '/product-detail?id=' + p.id;
                        
                        let html = '<div class="product-image">';
                        if (p.image) {
                            html += '<img src="' + p.image + '" alt="' + p.name + '" onerror="this.src=\'https://d29tuqwuufoa2l.cloudfront.net/logo.png\'">';
                        } else {
                            html += '<img src="https://d29tuqwuufoa2l.cloudfront.net/logo.png" alt="' + p.name + '">';
                        }
                        html += '</div><div class="product-info">';
                        html += '<div class="product-name">' + p.name + '</div>';
                        html += '<div class="product-price">';
                        html += '<span class="sale-price">' + p.price + '</span>';
                        html += '</div></div>';
                        
                        const card = document.createElement('div');
                        card.className = 'product-card';
                        card.draggable = false;
                        card.innerHTML = html;
                        a.appendChild(card);
                        track.appendChild(a);
                    });
                }
            }

            renderCards();
            currentTranslate = -position * CARD_WIDTH;
            prevTranslate = currentTranslate;
            setSliderPosition();

            function setSliderPosition() {
                track.style.transform = 'translateX(' + currentTranslate + 'px)';
            }

            function animation() {
                setSliderPosition();
                if (isDragging) requestAnimationFrame(animation);
            }

            function checkAndWrap() {
                // Wrap to first set when reaching end of first set
                if (position >= TOTAL) {
                    track.style.transition = 'none';
                    position = 0;
                    currentTranslate = 0;
                    prevTranslate = currentTranslate;
                    setSliderPosition();
                    requestAnimationFrame(function() {
                        track.style.transition = '';
                    });
                }
                // Wrap to first set when going below 0
                else if (position < 0) {
                    track.style.transition = 'none';
                    position = TOTAL - 1;
                    currentTranslate = -position * CARD_WIDTH;
                    prevTranslate = currentTranslate;
                    setSliderPosition();
                    requestAnimationFrame(function() {
                        track.style.transition = '';
                    });
                }
            }

            function autoSlide() {
                position += 1;
                currentTranslate = -position * CARD_WIDTH;
                prevTranslate = currentTranslate;
                
                track.style.transition = 'transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
                setSliderPosition();
                
                setTimeout(checkAndWrap, 600);
            }

            function startAutoPlay() {
                if (autoPlayInterval) clearInterval(autoPlayInterval);
                autoPlayInterval = setInterval(autoSlide, 3000);
            }

            function stopAutoPlay() {
                if (autoPlayInterval) clearInterval(autoPlayInterval);
            }

            // Click vs Drag discrimination
            let allowClick = true;

            function touchStart(event) {
                isDragging = true;
                startPos = getPositionX(event);
                animationID = requestAnimationFrame(animation);
                track.style.transition = 'none';
                stopAutoPlay();
                allowClick = true;
            }

            function touchMove(event) {
                if (isDragging) {
                    const currentPosition = getPositionX(event);
                    currentTranslate = prevTranslate + currentPosition - startPos;
                    if (Math.abs(currentTranslate - prevTranslate) > 10) {
                        allowClick = false;
                    }
                }
            }

            function touchEnd() {
                isDragging = false;
                cancelAnimationFrame(animationID);

                const movedBy = currentTranslate - prevTranslate;

                if (movedBy < -50) {
                    // Swipe left: next slide
                    position += 1;
                } else if (movedBy > 50) {
                    // Swipe right: previous slide
                    position -= 1;
                }

                currentTranslate = -position * CARD_WIDTH;
                prevTranslate = currentTranslate;
                
                track.style.transition = 'transform 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
                setSliderPosition();
                
                setTimeout(checkAndWrap, 400);
                startAutoPlay();
            }

            function getPositionX(event) {
                return event.type.includes('mouse') ? event.pageX : event.touches[0].clientX;
            }

            // Event listeners
            track.addEventListener('mousedown', touchStart);
            track.addEventListener('touchstart', touchStart, { passive: true });
            track.addEventListener('mousemove', touchMove);
            track.addEventListener('touchmove', touchMove, { passive: true });
            track.addEventListener('mouseup', touchEnd);
            track.addEventListener('touchend', touchEnd);
            track.addEventListener('mouseleave', function() {
                if (isDragging) touchEnd();
            });

            // Prevent link navigation when it was a drag
            track.addEventListener('click', function(e) {
                if (!allowClick) {
                    e.preventDefault();
                    e.stopPropagation();
                }
            }, true);

            // Start autoplay
            setTimeout(startAutoPlay, 500);
        })();
    </script>
</body>
</html>
