<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    /* --- 스토어 전용 서브 네비게이션 --- */
    .store-sub-nav-area { border-bottom: 1px solid #EAEDEF; background: #fff; position: sticky; top: 0; z-index: 90; }
    .store-sub-nav { display: flex; justify-content: space-between; align-items: center; }
    .sub-menu-list { display: flex; gap: 24px; font-size: 15px; font-weight: 700; color: #424242; }
    .sub-menu-list a { padding: 12px 0; position: relative; }
    .sub-menu-list a.active { color: #00A6EA; border-bottom: 2px solid #00A6EA; }
    .sub-menu-right { font-size: 13px; font-weight: 600; display: flex; align-items: center; gap: 6px; cursor: pointer; }

    /* --- 상품 상세 상단 레이아웃 (사진 / 요약 정보) --- */
    .breadcrumb { font-size: 13px; color: #757575; margin: 20px 0 30px; display: flex; align-items: center; gap: 6px; }
    .breadcrumb span.arrow { font-size: 10px; color: #BDBDBD; }

    .product-top-layout { display: flex; gap: 40px; margin-bottom: 50px; align-items: flex-start; }

    /* 좌측: 상품 이미지 영역 */
    .image-section { display: flex; gap: 10px; width: 55%; flex-shrink: 0; }
    .thumbnail-list { display: flex; flex-direction: column; gap: 8px; width: 56px; }
    .thumb-img { width: 56px; height: 56px; border-radius: 4px; border: 2px solid transparent; cursor: pointer; object-fit: cover; opacity: 0.6; }
    .thumb-img.active { border-color: #00A6EA; opacity: 1; }
    .thumb-img:hover { opacity: 1; }

    .main-image-wrap { flex-grow: 1; border-radius: 8px; overflow: hidden; background: #F7F9FA; aspect-ratio: 1/1; position: relative; }
    .main-image-wrap img { width: 100%; height: 100%; object-fit: cover; }
    .brand-logo-badge { position: absolute; top: 20px; left: 20px; background: #fff; padding: 6px 12px; border-radius: 20px; font-size: 16px; font-weight: 800; color: #00A6EA; display: flex; align-items: center; gap: 4px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }

    /* 우측: 상품 요약 정보 영역 */
    .info-section { flex-grow: 1; min-width: 0; }
    
    .brand-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
    .brand-name { font-size: 14px; font-weight: 700; color: #757575; }
    .action-icons { display: flex; gap: 16px; font-size: 24px; color: #424242; cursor: pointer; }
    .scrap-wrap { display: flex; flex-direction: column; align-items: center; gap: 2px; }
    .scrap-count { font-size: 12px; color: #757575; font-weight: 500; }

    .product-title { font-size: 22px; font-weight: 400; color: #2F3438; line-height: 1.4; margin-bottom: 15px; word-break: keep-all; }
    .review-row { display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: 700; color: #00A6EA; margin-bottom: 25px; cursor: pointer; }
    
    /* 가격 영역 */
    .original-price-row { font-size: 14px; margin-bottom: 5px; display: flex; align-items: center; gap: 6px; }
    .discount-rate { color: #757575; }
    .original-price { color: #BDBDBD; text-decoration: line-through; }
    
    .current-price-row { display: flex; align-items: center; gap: 8px; margin-bottom: 5px; }
    .current-price { font-size: 32px; font-weight: 700; color: #000; letter-spacing: -1px; }
    .badge-special { background: #FF7777; color: white; padding: 3px 6px; border-radius: 4px; font-size: 10px; font-weight: 700; }
    .badge-delivery { color: #00A6EA; font-size: 12px; font-weight: 700; display: flex; align-items: center; gap: 2px; }
    
    .coupon-price-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .coupon-price-left { display: flex; align-items: center; gap: 8px; }
    .coupon-price { font-size: 24px; font-weight: 700; color: #FF7777; letter-spacing: -1px; }
    .btn-coupon { padding: 8px 14px; border: 1px solid #EAEDEF; background: #fff; border-radius: 4px; font-size: 13px; font-weight: 700; color: #424242; cursor: pointer; display: flex; align-items: center; gap: 4px; }
    .btn-coupon:hover { background: #F7F9FA; }

    /* 혜택/할인 박스 */
    .benefit-box { background: #F7F9FA; border-radius: 4px; padding: 15px; margin-bottom: 10px; display: flex; gap: 10px; align-items: flex-start; }
    .benefit-box-content { display: flex; flex-direction: column; gap: 4px; }
    .benefit-title { font-size: 14px; font-weight: 700; color: #2F3438; }
    .benefit-desc { font-size: 12px; color: #757575; }
    .package-box { background: #00A6EA; color: #fff; border-radius: 4px; padding: 15px; font-size: 14px; font-weight: 700; display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; cursor: pointer; }

    /* 정보 테이블 */
    .info-grid { display: grid; grid-template-columns: 50px 1fr; gap: 15px 10px; font-size: 14px; border-top: 1px solid #EAEDEF; padding-top: 25px; margin-bottom: 25px; }
    .info-label { color: #757575; }
    .info-value { color: #2F3438; display: flex; flex-direction: column; gap: 4px; }
    .info-sub { font-size: 12px; color: #757575; }

    .brand-shop-box { display: flex; justify-content: space-between; align-items: center; padding: 16px 0; border-top: 1px solid #EAEDEF; border-bottom: 1px solid #EAEDEF; margin-bottom: 25px; cursor: pointer; }
    .brand-shop-left { display: flex; align-items: center; gap: 12px; }
    .brand-logo { width: 44px; height: 44px; border-radius: 50%; border: 1px solid #EAEDEF; background: url('https://images.unsplash.com/photo-1505693314120-0d443867891c?w=100') center/cover; }
    .brand-shop-name { font-size: 15px; font-weight: 700; color: #2F3438; }
    .brand-shop-sub { font-size: 12px; color: #757575; }

    .option-select { width: 100%; padding: 16px 15px; border: 1px solid #DADCE0; border-radius: 4px; font-size: 15px; color: #2F3438; background: #fff; outline: none; cursor: pointer; appearance: none; background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23757575' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e"); background-repeat: no-repeat; background-position: right 15px center; background-size: 16px; }
    
    /* --- 상품 상세 하단 레이아웃 (상세설명 / 리뷰 / 결제바) --- */
    .detail-tab-menu { border-top: 1px solid #EAEDEF; border-bottom: 1px solid #EAEDEF; position: sticky; top: 49px; background: #fff; z-index: 85; margin-bottom: 40px; }
    .detail-tab-inner { display: flex; gap: 30px; font-size: 15px; font-weight: 700; color: #424242; }
    .detail-tab-inner a { padding: 15px 0; }
    .detail-tab-inner a.active { color: #35C5F0; border-bottom: 3px solid #35C5F0; }

    .product-bottom-layout { display: flex; gap: 40px; margin-bottom: 100px; align-items: flex-start; }
    
    /* 좌측: 긴 설명, 리뷰, 유사상품 */
    .bottom-left-content { width: 60%; flex-grow: 1; }
    
    .detail-image-box { width: 100%; min-height: 1500px; background: #FAFAFA; border: 1px dashed #BDBDBD; display: flex; flex-direction: column; align-items: center; padding-top: 100px; margin-bottom: 80px; }
    .detail-image-box img { width: 100%; opacity: 0.5; }

    .section-title { font-size: 20px; font-weight: 700; margin-bottom: 20px; color: #000; }
    
    .review-card { border-bottom: 1px solid #EAEDEF; padding: 20px 0; margin-bottom: 20px; }
    .reviewer-info { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
    .reviewer-profile { width: 32px; height: 32px; border-radius: 50%; background: #EAEDEF; }
    .reviewer-name { font-size: 14px; font-weight: 700; }
    .review-date { font-weight: 400; color: #9E9E9E; font-size: 12px; margin-left: 5px; }
    .review-stars { color: #35C5F0; font-size: 14px; margin-bottom: 10px; }
    .review-text { font-size: 15px; color: #2F3438; line-height: 1.5; margin-bottom: 15px; }
    .review-photo { width: 120px; height: 120px; border-radius: 4px; background: url('https://images.unsplash.com/photo-1505693314120-0d443867891c?w=200') center/cover; }

    /* 유사 상품 그리드 (3열) */
    .similar-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
    .similar-card { cursor: pointer; }
    .similar-img { width: 100%; aspect-ratio: 1/1; border-radius: 8px; background: #F7F9FA; margin-bottom: 10px; }
    .similar-img img { width: 100%; height: 100%; object-fit: cover; border-radius: 8px; }
    .similar-title { font-size: 13px; color: #2F3438; }
    .similar-price { font-size: 17px; font-weight: 700; margin-top: 5px; }

    /* 우측: 스크롤 따라다니는 결제 박스 */
    .sticky-payment-box { width: 35%; flex-shrink: 0; position: sticky; top: 120px; border: 1px solid #EAEDEF; border-radius: 4px; padding: 20px; background: #fff; }
    .payment-title { font-size: 15px; font-weight: 700; margin-bottom: 15px; }
    .total-price-row { display: flex; justify-content: space-between; align-items: center; font-size: 14px; font-weight: 700; margin-top: 20px; margin-bottom: 20px; }
    .total-price { font-size: 24px; color: #000; }
    .btn-group { display: flex; gap: 10px; }
    .btn-cart { flex: 1; padding: 15px 0; border: 1px solid #00A6EA; background: #fff; color: #00A6EA; font-size: 16px; font-weight: 700; border-radius: 4px; cursor: pointer; }
    .btn-buy { flex: 1; padding: 15px 0; border: none; background: #00A6EA; color: #fff; font-size: 16px; font-weight: 700; border-radius: 4px; cursor: pointer; }
</style>

<!-- ★ 3. 메인 컨텐츠 영역 -->
<!-- 스토어 전용 서브 메뉴 -->
<div class="store-sub-nav-area">
    <div class="container store-sub-nav">
        <div class="sub-menu-list">
            <a href="store.htm">쇼핑홈</a>
            <a href="category.htm">카테고리</a>
            <a href="#">베스트</a>
            <a href="#">오늘의딜</a>
            <a href="#">단독상품</a>
            <a href="#">오마트</a>
            <a href="#">원하는날도착</a>
            <a href="#">오!쇼룸</a>
            <a href="#">기획전</a>
        </div>
        <div class="sub-menu-right">
            <span style="font-weight:800; font-size:14px;">7</span> <span style="color:#FF7777; font-size:10px;">NEW</span> 템바보드수납장 ∨
        </div>
    </div>
</div>

<main class="container">
    
    <!-- 브레드크럼 (경로) -->
    <div class="breadcrumb">
        가구 <span class="arrow">❯</span> 침대 <span class="arrow">❯</span> 침대프레임 <span class="arrow">❯</span> 일반침대
    </div>

    <!-- ============================================== -->
    <!-- 1. 상품 상세 상단 (이미지 및 요약 정보) -->
    <!-- ============================================== -->
    <div class="product-top-layout">
        
        <!-- 좌측: 썸네일 & 메인 이미지 -->
        <div class="image-section">
            <div class="thumbnail-list">
                <img src="https://images.unsplash.com/photo-1505693314120-0d443867891c?w=100" class="thumb-img active" alt="썸네일1">
                <img src="https://images.unsplash.com/photo-1584622781564-1d987f7333c1?w=100" class="thumb-img" alt="썸네일2">
                <img src="https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=100" class="thumb-img" alt="썸네일3">
                <img src="https://images.unsplash.com/photo-1554995207-c18c203602cb?w=100" class="thumb-img" alt="썸네일4">
                <img src="https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=100" class="thumb-img" alt="썸네일5">
            </div>
            <div class="main-image-wrap">
                <div class="brand-logo-badge">
                    <span style="background:#00A6EA; color:white; border-radius:50%; width:16px; height:16px; display:inline-block;"></span> layer
                </div>
                <img src="https://images.unsplash.com/photo-1505693314120-0d443867891c?w=800" alt="메인상품이미지">
            </div>
        </div>

        <!-- 우측: 가격, 혜택, 단일 옵션 선택 -->
        <div class="info-section">
            <div class="brand-row">
                <span class="brand-name">오늘의집 layer</span>
                <div class="action-icons">
                    <div class="scrap-wrap">
                        <span>🔖</span>
                        <span class="scrap-count">8,987</span>
                    </div>
                    <span>📤</span>
                </div>
            </div>

            <h1 class="product-title">refine / 다양하게 조합하는 빅수납 호텔 침대, 모던형/템바형, SS/Q/K</h1>

            <div class="review-row">
                ★★★★★ <span>310개 리뷰</span>
            </div>

            <div class="original-price-row">
                <span class="discount-rate">30%</span>
                <span class="original-price">613,000원</span> ⓘ
            </div>
            
            <div class="current-price-row">
                <span class="current-price">429,000</span> 원
                <span class="badge-special">특가</span>
                <span class="badge-delivery">🚚 원하는날도착</span>
            </div>

            <div class="coupon-price-row">
                <div class="coupon-price-left">
                    <span class="coupon-price">409,000</span> <span style="color:#FF7777; font-weight:700; font-size: 14px;">원 쿠폰 할인가</span>
                </div>
                <button class="btn-coupon">쿠폰 받기 ⭳</button>
            </div>

            <div class="benefit-box">
                <span style="font-size:18px;">🛒</span>
                <div class="benefit-box-content">
                    <span class="benefit-title">쿠폰가에서 3만원 더 할인돼요</span>
                    <span class="benefit-desc">100만원 이상 결제시 장바구니 쿠폰 적용 가능</span>
                </div>
            </div>
            
            <div class="package-box">
                <span>📦 패키지할인 받으면 더 할인돼요</span>
                <span>❯</span>
            </div>

            <div class="info-grid">
                <div class="info-label">혜택</div>
                <div class="info-value">
                    <span><b style="color:#35C5F0;">429P</b> 적립 (WELCOME 0.1% 적립)</span>
                    <span>월 71,500원 (6개월) 무이자할부 ></span>
                </div>
                
                <div class="info-label">배송</div>
                <div class="info-value">
                    <span style="font-weight:700;">무료배송</span>
                    <span style="color:#00A6EA; font-weight:700;">🚚 원하는날도착</span>
                    <span class="info-sub">제주도/도서산간 지역 배송 불가</span>
                </div>
            </div>

            <div class="brand-shop-box">
                <div class="brand-shop-left">
                    <div class="brand-logo"></div>
                    <div>
                        <div class="brand-shop-name">오늘의집 layer ></div>
                        <div class="brand-shop-sub">브랜드</div>
                    </div>
                </div>
                <span style="font-size:20px; color:#BDBDBD;">🔖</span>
            </div>

            <select class="option-select">
                <option value="" disabled selected>사이즈, 색상</option>
                <option value="1">슈퍼싱글(SS) / 오크</option>
                <option value="2">퀸(Q) / 오크</option>
                <option value="3">킹(K) / 오크 (+30,000원)</option>
            </select>
        </div>
    </div>

    <!-- ============================================== -->
    <!-- 2. 상품 상세 하단 (상세설명, 리뷰, 고정 결제창) -->
    <!-- ============================================== -->
    
    <!-- 하단 탭 메뉴 -->
    <div class="detail-tab-menu">
        <div class="detail-tab-inner">
            <a href="#detail-info" class="active">상품정보</a>
            <a href="#detail-review">리뷰 <span style="color:#757575; font-size:13px;">310</span></a>
            <a href="#detail-qna">문의 <span style="color:#757575; font-size:13px;">12</span></a>
            <a href="#detail-delivery">배송/환불</a>
        </div>
    </div>

    <!-- 하단 레이아웃 -->
    <div class="product-bottom-layout">
        
        <!-- 좌측: 긴 설명, 리뷰, 유사상품 -->
        <div class="bottom-left-content">
            
            <!-- 상품 상세 긴 이미지 영역 -->
            <div id="detail-info" class="detail-image-box">
                <h2 style="color: #757575; margin-bottom: 20px;">엄청나게 긴 상품 상세 설명 이미지 영역</h2>
                <img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800" alt="더미상세1">
                <img src="https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800" alt="더미상세2">
            </div>
            
            <!-- 리뷰 영역 -->
            <div id="detail-review" style="margin-bottom: 80px;">
                <h3 class="section-title">리뷰 310</h3>
                
                <div class="review-card">
                    <div class="reviewer-info">
                        <div class="reviewer-profile"></div>
                        <div class="reviewer-name">인테리어고수 <span class="review-date">2026.08.01</span></div>
                    </div>
                    <div class="review-stars">★★★★★</div>
                    <p class="review-text">
                        배송도 빠르고 기사님도 친절하셨어요! 침대 프레임 튼튼하고 색상도 화면이랑 똑같이 예쁩니다. 매트리스도 적당히 푹신해서 꿀잠 자고 있어요.
                    </p>
                    <div class="review-photo"></div>
                </div>
            </div>

            <!-- 유사 상품 영역 -->
            <div style="margin-bottom: 80px;">
                <h3 class="section-title">비슷한 상품</h3>
                <div class="similar-grid">
                    <div class="similar-card">
                        <div class="similar-img"><img src="https://images.unsplash.com/photo-1584622781564-1d987f7333c1?w=400" alt="유사상품"></div>
                        <div class="similar-title">[단독] 컴피 토퍼 분리형 매트리스</div>
                        <div class="similar-price">259,000원</div>
                    </div>
                    <div class="similar-card">
                        <div class="similar-img"><img src="https://images.unsplash.com/photo-1540574163026-643ea20d25b5?w=400" alt="유사상품"></div>
                        <div class="similar-title">플랫포인트 의자/수납 기획전</div>
                        <div class="similar-price">8,300원</div>
                    </div>
                    <div class="similar-card">
                        <div class="similar-img"><img src="https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?w=400" alt="유사상품"></div>
                        <div class="similar-title">화이트 우드 스타일링 가구 모음</div>
                        <div class="similar-price">124,000원</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 우측: 따라다니는 고정 결제창 -->
        <div class="sticky-payment-box">
            <h4 class="payment-title">옵션 선택</h4>
            <select class="option-select" style="margin-bottom: 20px;">
                <option>사이즈, 색상을 선택해주세요.</option>
            </select>
            <div class="total-price-row">
                <span>총 결제금액</span>
                <span class="total-price">0 <span style="font-size: 16px; font-weight: 400;">원</span></span>
            </div>
            <div class="btn-group">
                <button class="btn-cart">장바구니</button>
                <button class="btn-buy">바로구매</button>
            </div>
        </div>

    </div>
</main>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />