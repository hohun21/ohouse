<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
     main.container {
        width: calc(100% - 80px);
        margin: 0 auto;
        box-sizing: border-box;
    }
    /* --- ★ 추가된 홈 전용 서브 메뉴 (LNB) CSS --- */
    .home-sub-nav-area {
        border-bottom: 1px solid #EAEDEF;
        background: #fff;
        margin: 0 auto 30px;
    }

    .home-sub-nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .sub-nav-list {
        display: flex;
        gap: 24px;
        font-size: 15px;
        font-weight: 700;
        color: #424242;
    }

    .sub-nav-list a {
        padding: 12px 0;
        position: relative;
    }

    .sub-nav-list a.active {
        color: #00A6EA;
    }

    .sub-nav-list a.active::after {
        content: "";
        position: absolute;
        bottom: -1px;
        left: 0;
        width: 100%;
        height: 2px;
        background-color: #00A6EA;
    }

    /* --- 여기서부터 메인 페이지 전용 CSS --- */
    .hero-section {
        display: grid;
        grid-template-columns: 2fr 1fr;
        gap: 20px;
        margin: 0 auto 30px;
        height: 400px;
    }

    .hero-banner {
        background-color: #EAEDEF;
        border-radius: 8px;
        position: relative;
        overflow: hidden;
        cursor: pointer;
    }

    .hero-banner:hover {
        opacity: 0.9;
    }

    .hero-text-overlay {
        position: absolute;
        bottom: 30px;
        left: 30px;
        color: white;
        font-size: 28px;
        font-weight: 700;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
    }

    .hero-bg-left {
        background: linear-gradient(rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80') center/cover;
    }

    .hero-bg-right {
        background: url('https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=400&q=80') center/cover;
    }

    .icon-nav {
        display: flex;
        justify-content: space-between;
        margin: 40px auto 60px;
        padding: 0 20px;
    }

    .icon-item {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        cursor: pointer;
    }

    .icon-circle {
        width: 64px;
        height: 64px;
        border-radius: 50%;
        background-color: #F7F9FA;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 24px;
        transition: transform 0.2s;
    }

    .icon-item:hover .icon-circle {
        transform: translateY(-3px);
    }

    .icon-text {
        font-size: 13px;
        font-weight: 600;
        color: #424242;
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        margin-bottom: 20px;
    }

    .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #000;
    }

    .more-link {
        font-size: 15px;
        font-weight: 700;
        color: #35C5F0;
    }

    .grid-6 {
        display: grid;
        grid-template-columns: repeat(6, 1fr);
        gap: 16px;
        margin-bottom: 60px;
    }

    .photo-card {
        border-radius: 8px;
        overflow: hidden;
        aspect-ratio: 1 / 1.2;
        background-color: #EAEDEF;
        position: relative;
        cursor: pointer;
    }

    .photo-card:hover {
        opacity: 0.9;
    }

    .grid-4 {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 60px;
    }

    .story-card {
        cursor: pointer;
    }

    .story-img {
        width: 100%;
        aspect-ratio: 4 / 3;
        border-radius: 8px;
        background-color: #EAEDEF;
        margin-bottom: 12px;
    }

    .story-title {
        font-size: 15px;
        font-weight: 700;
        line-height: 1.4;
        margin-bottom: 8px;
    }

    .story-profile {
        font-size: 12px;
        color: #757575;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .profile-img {
        width: 22px;
        height: 22px;
        border-radius: 50%;
        background-color: #CCC;
    }

    .product-card {
        cursor: pointer;
    }

    .product-img-wrap {
        width: 100%;
        aspect-ratio: 1 / 1;
        border-radius: 8px;
        background-color: #F7F9FA;
        margin-bottom: 12px;
        overflow: hidden;
        position: relative;
    }

    .product-img-wrap img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.2s;
    }

    .product-card:hover .product-img-wrap img {
        transform: scale(1.05);
    }

    .time-badge {
        position: absolute;
        top: 10px;
        left: 10px;
        background: #FF7777;
        color: white;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: 700;
    }

    .brand-name {
        font-size: 11px;
        color: #757575;
        font-weight: 600;
        margin-bottom: 4px;
    }

    .product-name {
        font-size: 13px;
        color: #2F3438;
        line-height: 1.4;
        margin-bottom: 8px;
        font-weight: 400;
    }

    .price-area {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 17px;
        font-weight: 700;
    }

    .discount {
        color: #35C5F0;
    }

    .price {
        color: #000;
    }

    .review-area {
        font-size: 12px;
        color: #757575;
        margin-top: 6px;
        font-weight: 700;
    }

    .star {
        color: #35C5F0;
        margin-right: 2px;
    }

    .grid-3 {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
        margin-bottom: 60px;
    }

    .banner-card {
        width: 100%;
        aspect-ratio: 16 / 9;
        border-radius: 8px;
        background-color: #EAEDEF;
        margin-bottom: 12px;
        cursor: pointer;
    }

    .tab-menu {
        display: flex;
        gap: 12px;
        margin-bottom: 20px;
    }

    .tab-btn {
        padding: 8px 16px;
        background-color: #F7F9FA;
        border: 1px solid #EAEDEF;
        border-radius: 20px;
        font-size: 14px;
        font-weight: 600;
        color: #424242;
        cursor: pointer;
    }

    .tab-btn.active {
        background-color: #35C5F0;
        color: white;
        border-color: #35C5F0;
    }


</style>



<!-- 메인 컨텐츠 영역 시작 -->
<main class="container">
    <!-- 메인 히어로 배너 -->
    <section class="hero-section">
        <div class="hero-banner hero-bg-left">
            <div class="hero-text-overlay">60년 된 구옥, 서까래와 파벽돌로<br>빈티지 무드를 살린 반셀프</div>
        </div>
        <div class="hero-banner hero-bg-right"></div>
    </section>

    <!-- 아이콘 메뉴 -->
    <div class="icon-nav">
        <div class="icon-item">
            <div class="icon-circle">🛍️</div>
            <span class="icon-text">쇼핑하기</span></div>
        <div class="icon-item">
            <div class="icon-circle">⚡</div>
            <span class="icon-text">오딜</span></div>
        <div class="icon-item">
            <div class="icon-circle">🚚</div>
            <span class="icon-text">빠른배송</span></div>
        <div class="icon-item">
            <div class="icon-circle">🏢</div>
            <span class="icon-text">아파트</span></div>
        <div class="icon-item">
            <div class="icon-circle">🛠️</div>
            <span class="icon-text">시공/수리</span></div>
        <div class="icon-item">
            <div class="icon-circle">📦</div>
            <span class="icon-text">이사</span></div>
        <div class="icon-item">
            <div class="icon-circle">🎁</div>
            <span class="icon-text">기획전</span></div>
        <div class="icon-item">
            <div class="icon-circle">🐶</div>
            <span class="icon-text">반려동물</span></div>
        <div class="icon-item">
            <div class="icon-circle">🪑</div>
            <span class="icon-text">프리미엄</span></div>
        <div class="icon-item">
            <div class="icon-circle">✨</div>
            <span class="icon-text">새로운</span></div>
    </div>

    <!-- 이런 사진 찾고 있나요? -->
    <section>
        <div class="section-header">
            <h2 class="section-title">이런 사진 찾고 있나요?</h2>
            <a href="#" class="more-link">더보기</a>
        </div>
        <div class="grid-6">
            <div class="photo-card"
                 style="background: url('https://images.unsplash.com/photo-1513694203232-719a280e022f?w=300') center/cover;"></div>
            <div class="photo-card"
                 style="background: url('https://images.unsplash.com/photo-1540932239986-30128078f3c5?w=300') center/cover;"></div>
            <div class="photo-card"
                 style="background: url('https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=300') center/cover;"></div>
            <div class="photo-card"
                 style="background: url('https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=300') center/cover;"></div>
            <div class="photo-card"
                 style="background: url('https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=300') center/cover;"></div>
            <div class="photo-card"
                 style="background: url('https://images.unsplash.com/photo-1484154218962-a197022b5858?w=300') center/cover;"></div>
        </div>
    </section>

    <!-- 오늘의 인기 집들이 -->
    <section>
        <div class="section-header">
            <h2 class="section-title">오늘의 인기 집들이 🏠</h2>
            <a href="#" class="more-link">더보기</a>
        </div>
        <div class="grid-4">
            <div class="story-card">
                <div class="story-img"
                     style="background: url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=400') center/cover;"></div>
                <div class="story-title">베이지와 블랙으로 완성한 30평대 미니멀 아파트</div>
                <div class="story-profile">
                    <div class="profile-img"></div>
                    인테리어러버
                </div>
            </div>
            <div class="story-card">
                <div class="story-img"
                     style="background: url('https://images.unsplash.com/photo-1554995207-c18c203602cb?w=400') center/cover;"></div>
                <div class="story-title">로맨틱한 무드가 가득, 제주의 작은 렌탈하우스</div>
                <div class="story-profile">
                    <div class="profile-img"></div>
                    제주살이
                </div>
            </div>
            <div class="story-card">
                <div class="story-img"
                     style="background: url('https://images.unsplash.com/photo-1583847268964-b28ce8f30321?w=400') center/cover;"></div>
                <div class="story-title">거실은 넓게, 방은 아늑하게! 20평대 리모델링</div>
                <div class="story-profile">
                    <div class="profile-img"></div>
                    집꾸미기달인
                </div>
            </div>
            <div class="story-card">
                <div class="story-img"
                     style="background: url('https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?w=400') center/cover;"></div>
                <div class="story-title">평범함을 특별함으로! 화이트 우드 스타일링</div>
                <div class="story-profile">
                    <div class="profile-img"></div>
                    오늘의집유저
                </div>
            </div>
        </div>
    </section>

    <!-- 오늘의 딜 -->
    <section>
        <div class="section-header">
            <h2 class="section-title">오늘의 딜</h2>
            <a href="#" class="more-link">더보기</a>
        </div>
        <div class="grid-4">
            <div class="product-card">
                <div class="product-img-wrap">
                    <span class="time-badge">남은시간 11:24:59</span>
                    <img src="https://images.unsplash.com/photo-1595515106969-1ce29566ff1c?w=400" alt="상품">
                </div>
                <div class="brand-name">리바트</div>
                <div class="product-name">[오늘의딜] 뉴 라비나 4인용 패브릭 소파 (스툴포함)</div>
                <div class="price-area"><span class="discount">45%</span><span class="price">499,000 외</span></div>
                <div class="review-area"><span class="star">★</span> 4.8 리뷰 1,204</div>
            </div>
            <div class="product-card">
                <div class="product-img-wrap">
                    <span class="time-badge">남은시간 05:10:22</span>
                    <img src="https://images.unsplash.com/photo-1623387641168-d9804dd9dc5a?w=400" alt="상품">
                </div>
                <div class="brand-name">위닉스</div>
                <div class="product-name">[쿠폰할인] 뽀송 10L 제습기 / 장마철 필수템</div>
                <div class="price-area"><span class="discount">21%</span><span class="price">209,000</span></div>
                <div class="review-area"><span class="star">★</span> 4.9 리뷰 3,120</div>
            </div>
            <div class="product-card">
                <div class="product-img-wrap">
                    <img src="https://images.unsplash.com/photo-1616627547584-bf28cee262db?w=400" alt="상품">
                </div>
                <div class="brand-name">데스커</div>
                <div class="product-name">컴퓨터 데스크 1200x600 (색상택1)</div>
                <div class="price-area"><span class="discount">20%</span><span class="price">114,000</span></div>
                <div class="review-area"><span class="star">★</span> 4.7 리뷰 850</div>
            </div>
            <div class="product-card">
                <div class="product-img-wrap">
                    <img src="https://images.unsplash.com/photo-1540574163026-643ea20d25b5?w=400" alt="상품">
                </div>
                <div class="brand-name">일룸</div>
                <div class="product-name">쿠시노 침대 프레임+매트리스 세트</div>
                <div class="price-area"><span class="discount">15%</span><span class="price">680,000</span></div>
                <div class="review-area"><span class="star">★</span> 4.9 리뷰 2,410</div>
            </div>
        </div>
    </section>

    <!-- 인테리어 시공 사례 -->
    <section>
        <div class="section-header">
            <h2 class="section-title">인테리어/시공 사례</h2>
            <a href="#" class="more-link">더보기</a>
        </div>
        <div class="grid-3">
            <div>
                <div class="banner-card"
                     style="background: url('https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=400') center/cover;"></div>
                <div class="story-title">주방의 재발견, ㄷ자형 싱크대의 마법</div>
            </div>
            <div>
                <div class="banner-card"
                     style="background: url('https://images.unsplash.com/photo-1484154218962-a197022b5858?w=400') center/cover;"></div>
                <div class="story-title">낡은 화장실 비포앤애프터 확실한 시공기</div>
            </div>
            <div>
                <div class="banner-card"
                     style="background: url('https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400') center/cover;"></div>
                <div class="story-title">우드톤으로 통일한 침실 인테리어 노하우</div>
            </div>
        </div>
    </section>

    <!-- 베스트 영역 -->
    <section>
        <div class="section-header">
            <h2 class="section-title">베스트</h2>
            <a href="#" class="more-link">더보기</a>
        </div>
        <div class="tab-menu">
            <button class="tab-btn active">전체</button>
            <button class="tab-btn">가구</button>
            <button class="tab-btn">패브릭</button>
            <button class="tab-btn">가전</button>
            <button class="tab-btn">주방용품</button>
            <button class="tab-btn">식품</button>
        </div>
        <div class="grid-4">
            <div class="product-card">
                <div class="product-img-wrap"><img
                        src="https://images.unsplash.com/photo-1583847268964-b28ce8f30321?w=400" alt="베스트상품"></div>
                <div class="brand-name">마틸라</div>
                <div class="product-name">차렵이불 세트 SS/Q/K 4계절용</div>
                <div class="price-area"><span class="discount">50%</span><span class="price">39,900</span></div>
            </div>
            <div class="product-card">
                <div class="product-img-wrap"><img
                        src="https://images.unsplash.com/photo-1540574163026-643ea20d25b5?w=400" alt="베스트상품"></div>
                <div class="brand-name">퀵슬립</div>
                <div class="product-name">Q3 유로탑 롤팩 매트리스</div>
                <div class="price-area"><span class="discount">35%</span><span class="price">189,000</span></div>
            </div>
            <div class="product-card">
                <div class="product-img-wrap"><img
                        src="https://images.unsplash.com/photo-1513694203232-719a280e022f?w=400" alt="베스트상품"></div>
                <div class="brand-name">데코뷰</div>
                <div class="product-name">100% 암막 커튼 2장 세트 (레일포함)</div>
                <div class="price-area"><span class="discount">40%</span><span class="price">55,000</span></div>
            </div>
            <div class="product-card">
                <div class="product-img-wrap"><img
                        src="https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=400" alt="베스트상품"></div>
                <div class="brand-name">샘키즈</div>
                <div class="product-name">수납장 1305 모던 색상</div>
                <div class="price-area"><span class="discount">28%</span><span class="price">124,000</span></div>
            </div>
        </div>
    </section>
</main>


<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>