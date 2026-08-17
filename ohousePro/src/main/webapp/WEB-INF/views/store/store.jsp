<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    /* --- ★ 스토어 전용 서브 네비게이션 CSS --- */
    .store-sub-nav-area { border-bottom: 1px solid #EAEDEF; background: #fff; margin-bottom: 30px; position: sticky; top: 0; z-index: 90; }
    .store-sub-nav { display: flex; justify-content: space-between; align-items: center; }
    .sub-menu-list { display: flex; gap: 24px; font-size: 15px; font-weight: 700; color: #424242; }
    .sub-menu-list a { padding: 12px 0; position: relative; }
    .sub-menu-list a.active { color: #00A6EA; }
    .sub-menu-list a.active::after { content: ""; position: absolute; bottom: -1px; left: 0; width: 100%; height: 2px; background-color: #00A6EA; }
    .sub-menu-right { font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 6px; cursor: pointer; }

    /* 상단 3분할 배너 */
    .banner-section { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 0 auto 10px; }
    .banner-box { border-radius: 6px; overflow: hidden; background-color: #EAEDEF; aspect-ratio: 4/3; cursor: pointer; position: relative; }
    .banner-box img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
    .banner-box:hover img { transform: scale(1.03); }
    .banner-controls { display: flex; justify-content: flex-end; gap: 8px; margin-bottom: 40px; }
    .btn-mini { width: 28px; height: 28px; border: 1px solid #EAEDEF; background: #fff; border-radius: 4px; cursor: pointer; display: flex; justify-content: center; align-items: center; color: #757575; }

    /* 카테고리 슬라이더 영역 */
    .category-section { margin-bottom: 60px; position: relative; }
    .section-title { font-size: 20px; font-weight: 700; margin-bottom: 20px; color: #000; }
    
    .slider-wrap { position: relative; }
    .category-slider { 
        display: grid; 
        grid-template-rows: repeat(2, 1fr); /* 2줄 슬라이더 */
        grid-auto-flow: column; 
        gap: 20px 0; 
        overflow-x: auto; 
        scroll-behavior: smooth; 
        padding: 5px 0;
        -ms-overflow-style: none; scrollbar-width: none; 
    }
    .category-slider::-webkit-scrollbar { display: none; }
    
    .category-item { width: 80px; display: flex; flex-direction: column; align-items: center; gap: 8px; cursor: pointer; }
    .category-icon { width: 56px; height: 56px; border-radius: 18px; background-color: #F7F9FA; display: flex; justify-content: center; align-items: center; font-size: 28px; transition: background 0.2s; }
    .category-item:hover .category-icon { background-color: #EAEDEF; }
    .category-name { font-size: 12px; font-weight: 600; color: #424242; text-align: center; white-space: nowrap; }

    .slide-btn { position: absolute; top: 50%; transform: translateY(-50%); width: 40px; height: 40px; border-radius: 50%; background: #fff; border: 1px solid #DADCE0; box-shadow: 0 2px 4px rgba(0,0,0,0.1); font-size: 18px; color: #424242; cursor: pointer; display: flex; justify-content: center; align-items: center; z-index: 10; }
    .slide-btn.prev { left: -20px; }
    .slide-btn.next { right: -20px; }
    .slide-btn:hover { background: #F7F9FA; }

    /* 추천 상품 영역 */
    .product-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 30px 20px; }
    .product-card { cursor: pointer; display: flex; flex-direction: column; }
    .product-img-box { width: 100%; aspect-ratio: 1 / 1; border-radius: 8px; overflow: hidden; margin-bottom: 12px; position: relative; background-color: #F7F9FA; }
    .product-img-box img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.2s; }
    .product-card:hover .product-img-box img { transform: scale(1.05); }
    .only-badge { position: absolute; top: 10px; left: 10px; background: #2F3438; color: white; padding: 4px 6px; border-radius: 4px; font-size: 10px; font-weight: 700; z-index: 10; }
    .title { font-size: 13px; color: #2F3438; line-height: 1.4; margin-top: 8px; }
</style>

<!-- ★ 3. 메인 컨텐츠 영역 -->
<!-- 스토어 전용 서브 메뉴 -->
<div class="store-sub-nav-area">
    <div class="container store-sub-nav">
        <div class="sub-menu-list">
            <a href="#" class="active">쇼핑홈</a>
            <a href="category.htm">카테고리</a> <!-- 💡 카테고리로 가는 링크 연결 -->
            <a href="#">베스트</a>
            <a href="#">오늘의딜</a>
            <a href="#">단독상품</a>
            <a href="#">오마트</a>
            <a href="#">원하는날도착</a>
            <a href="#">오!쇼룸</a>
            <a href="#">기획전</a>
        </div>
        <div class="sub-menu-right">
            <span style="font-weight:800; font-size:14px;">7</span> 
            <span style="color:#FF7777; font-size:10px;">NEW</span> 
            다이슨 거치대 ∨
        </div>
    </div>
</div>

<!-- 메인 컨텐츠 영역 시작 -->
<main class="container">
    
    <!-- 3분할 배너 -->
    <section class="banner-section">
        <div class="banner-box">
            <img src="https://images.unsplash.com/photo-1554995207-c18c203602cb?w=600" alt="배너1">
        </div>
        <div class="banner-box">
            <img src="https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=600" alt="배너2">
        </div>
        <div class="banner-box">
            <img src="https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=600" alt="배너3">
        </div>
    </section>
    <div class="banner-controls">
        <button class="btn-mini"><</button>
        <button class="btn-mini">></button>
    </div>

    <!-- 카테고리 슬라이더 -->
    <section class="category-section">
        <h2 class="section-title">카테고리</h2>
        <div class="slider-wrap">
            <!-- JS 제어용 이전 버튼 -->
            <button class="slide-btn prev" id="cat-prev">❮</button>
            
            <div class="category-slider" id="cat-slider">
                <!-- 1열 -->
                <div class="category-item"><div class="category-icon">🍉</div><span class="category-name">폭염대비</span></div>
                <div class="category-item"><div class="category-icon" style="color:#FF7777;">⚡</div><span class="category-name">오늘의딜</span></div>
                <!-- 2열 -->
                <div class="category-item"><div class="category-icon">🪑</div><span class="category-name">가구</span></div>
                <div class="category-item"><div class="category-icon" style="color:#D4AF37;">🏅</div><span class="category-name">BEST</span></div>
                <!-- 3열 -->
                <div class="category-item"><div class="category-icon">🧶</div><span class="category-name">패브릭</span></div>
                <div class="category-item"><div class="category-icon" style="color:#FF7777;">🔴</div><span class="category-name">라이브특가</span></div>
                <!-- 4열 -->
                <div class="category-item"><div class="category-icon">📺</div><span class="category-name">가전·디지털</span></div>
                <div class="category-item"><div class="category-icon" style="color:#FF8A65;">🛒</div><span class="category-name">오마트</span></div>
                <!-- 5열 -->
                <div class="category-item"><div class="category-icon">🍳</div><span class="category-name">주방용품</span></div>
                <div class="category-item"><div class="category-icon" style="color:#00A6EA;">🚚</div><span class="category-name">원하는날도착</span></div>
                <!-- 6열 -->
                <div class="category-item"><div class="category-icon">🍞</div><span class="category-name">식품</span></div>
                <div class="category-item"><div class="category-icon">🏬</div><span class="category-name">바이너리샵</span></div>
                <!-- 7열 -->
                <div class="category-item"><div class="category-icon">🪴</div><span class="category-name">데코·식물</span></div>
                <div class="category-item"><div class="category-icon" style="color:#F06292;">📦</div><span class="category-name">패키지할인</span></div>
                <!-- 8열 -->
                <div class="category-item"><div class="category-icon">💡</div><span class="category-name">조명</span></div>
                <div class="category-item"><div class="category-icon" style="background:#2F3438; color:white; font-size:12px;">Only</div><span class="category-name">단독상품</span></div>
                <!-- 9열 -->
                <div class="category-item"><div class="category-icon">🗄️</div><span class="category-name">수납·정리</span></div>
                <div class="category-item"><div class="category-icon" style="color:#5C6BC0;">🛋️</div><span class="category-name">오!쇼룸</span></div>
                <!-- 10열 -->
                <div class="category-item"><div class="category-icon">🧴</div><span class="category-name">생활용품</span></div>
                <div class="category-item"><div class="category-icon" style="color:#AB47BC;">🏷️</div><span class="category-name">특가/혜택</span></div>
                <!-- 11열 -->
                <div class="category-item"><div class="category-icon">🧻</div><span class="category-name">생필품</span></div>
                <div class="category-item"><div class="category-icon">👶</div><span class="category-name">유아·아동</span></div>
                <!-- 12열 -->
                <div class="category-item"><div class="category-icon">🐶</div><span class="category-name">반려동물</span></div>
                <div class="category-item"><div class="category-icon">🏕️</div><span class="category-name">캠핑·레저</span></div>
            </div>

            <!-- JS 제어용 다음 버튼 -->
            <button class="slide-btn next" id="cat-next">❯</button>
        </div>
    </section>

    <!-- 추천상품 -->
    <section style="margin-bottom: 80px;">
        <h2 class="section-title">추천상품</h2>
        <div class="product-grid">
            <div class="product-card">
                <div class="product-img-box">
                    <span class="only-badge">Only</span>
                    <img src="https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=400" alt="수건">
                </div>
                <div class="title">먼지없는 고중량 호텔수건 10장 세트</div>
            </div>
            <div class="product-card">
                <div class="product-img-box">
                    <span class="only-badge">Only</span>
                    <img src="https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=400" alt="수건2">
                </div>
                <div class="title">프리미엄 뱀부얀 수건 모음전</div>
            </div>
            <div class="product-card">
                <div class="product-img-box">
                    <img src="https://images.unsplash.com/photo-1583847268964-b28ce8f30321?w=400" alt="세제">
                </div>
                <div class="title">친환경 다목적 세정제 1L</div>
            </div>
            <div class="product-card">
                <div class="product-img-box">
                    <span class="only-badge">Only</span>
                    <img src="https://images.unsplash.com/photo-1513694203232-719a280e022f?w=400" alt="커튼">
                </div>
                <div class="title">100% 완벽 암막 커튼 거실용 2장</div>
            </div>
        </div>
    </section>

</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

<!-- 슬라이더 동작 자바스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const slider = document.getElementById('cat-slider');
        const btnPrev = document.getElementById('cat-prev');
        const btnNext = document.getElementById('cat-next');
        
        const scrollAmount = 400; 

        if (btnNext && btnPrev && slider) {
            btnNext.addEventListener('click', () => {
                slider.scrollLeft += scrollAmount;
            });

            btnPrev.addEventListener('click', () => {
                slider.scrollLeft -= scrollAmount;
            });
        }
    });
</script>