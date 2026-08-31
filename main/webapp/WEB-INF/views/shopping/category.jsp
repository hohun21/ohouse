<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    /* --- 스토어 전용 서브 네비게이션 --- */
    .store-sub-nav-area { border-bottom: 1px solid #EAEDEF; background: #fff; margin-bottom: 30px; position: sticky; top: 0; z-index: 90; }
    .store-sub-nav { display: flex; justify-content: space-between; align-items: center; }
    .sub-menu-list { display: flex; gap: 24px; font-size: 15px; font-weight: 700; color: #424242; }
    .sub-menu-list a { padding: 12px 0; position: relative; }
    .sub-menu-list a.active { color: #00A6EA; border-bottom: 2px solid #00A6EA; }

    /* --- 2단 분할 레이아웃 --- */
    .category-layout { display: flex; gap: 40px; margin-bottom: 100px; }

    /* 1. 좌측 사이드바 (카테고리 메뉴) */
    .sidebar { width: 200px; flex-shrink: 0; }
    .sidebar-title { font-size: 20px; font-weight: 700; color: #2F3438; margin-bottom: 20px; padding-bottom: 10px; }
    
    .sidebar-menu { display: flex; flex-direction: column; gap: 4px; }
    .sidebar-item { display: flex; justify-content: space-between; align-items: center; padding: 5px 0; font-size: 15px; color: black; cursor: pointer; font-weight: 500; }
    .sidebar-item:hover, .sidebar-item.active { color: #757575; font-weight: 700; }
    .sidebar-arrow { font-size: 12px; color: #757575; }

    /* 다른 대분류 카테고리들 */
    .other-categories { margin-top: 40px; border-top: 1px solid #EAEDEF; padding-top: 20px; display: flex; flex-direction: column; gap: 10px; font-size: 25px; font-weight: 700; color: #2F3438; }
    .other-item { cursor: pointer; }
    .other-item:hover { color:#757575; }

    /* 2. 우측 메인 컨텐츠 영역 */
    .main-content { flex-grow: 1; min-width: 0; }

    .banner-header { font-size: 14px; font-weight: 700; margin-bottom: 15px; }
    .category-banners { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 50px; }
    .banner-box { border-radius: 6px; overflow: hidden; background-color: #EAEDEF; aspect-ratio: 1/1; cursor: pointer; }
    .banner-box img { width: 100%; height: 100%; object-fit: cover; }

    .filter-section { margin-bottom: 30px; }
    .filter-row { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 10px; }
    .filter-btn { padding: 6px 12px; border: 1px solid #DADCE0; background: #fff; border-radius: 4px; font-size: 13px; font-weight: 500; color: #424242; cursor: pointer; display: flex; align-items: center; gap: 4px; }
    .filter-btn:hover { background: #F7F9FA; }
    .filter-btn.active { border-color: #35C5F0; color: #35C5F0; background: #F4FBFE; font-weight: 700; }

    .list-header { display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #424242; margin-bottom: 20px; }
    .list-count { font-weight: 500; }
    .sort-select { border: none; font-size: 13px; color: #424242; font-weight: 700; cursor: pointer; outline: none; }

    .product-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px 20px; }
    
    /* ★ 상품 카드 영역 (Only 뱃지 탈출 방지!) ★ */
    .product-card { cursor: pointer; display: flex; flex-direction: column; }
    .product-img-wrap { width: 100%; aspect-ratio: 1 / 1; border-radius: 8px; overflow: hidden; margin-bottom: 12px; position: relative; background-color: #F7F9FA; }
    .product-img-wrap img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.2s; }
    .product-card:hover .product-img-wrap img { transform: scale(1.05); }
    .only-badge { position: absolute; top: 10px; left: 10px; background: #2F3438; color: white; padding: 4px 6px; border-radius: 4px; font-size: 10px; font-weight: 700; z-index: 10; }
    
    .brand { font-size: 11px; color: #757575; font-weight: 600; margin-bottom: 4px; }
    .title { font-size: 13px; color: #2F3438; line-height: 1.4; margin-bottom: 8px; }
    .price-wrap { display: flex; align-items: center; gap: 6px; font-size: 17px; font-weight: 700; margin-bottom: 6px; }
    .discount { color: #35C5F0; }
    .price { color: #000; }
    .review-wrap { font-size: 12px; font-weight: 700; color: #424242; display: flex; align-items: center; gap: 4px; margin-bottom: 8px; }
    .star { color: #35C5F0; font-size: 14px; }
    
    .badge-wrap { display: flex; flex-wrap: wrap; gap: 4px; }
    .badge { padding: 3px 6px; font-size: 10px; font-weight: 700; border-radius: 3px; }
    .badge-free { background-color: #EAEDEF; color: #757575; }
    .badge-special { background-color: #FF7777; color: white; }
</style>

<!-- 스토어 전용 서브 메뉴 -->
<div class="store-sub-nav-area">
    <div class="container store-sub-nav">
        <div class="sub-menu-list">
            <a href="#">쇼핑홈</a>
            <a href="#" class="active">카테고리</a>
            <a href="#">베스트</a>
            <a href="#">오늘의딜</a>
            <a href="#">단독상품</a>
            <a href="#">오마트</a>
            <a href="#">원하는날도착</a>
        </div>
    </div>
</div>

<!-- 2단 분할 메인 컨텐츠 시작 -->
<main class="container category-layout">
    
    <!-- 좌측 사이드바 -->
    <aside class="sidebar">
        <h2 class="sidebar-title">가구</h2>
        <div class="sidebar-menu">
            <div class="sidebar-item">오늘의집 Only</div>
            <div class="sidebar-item active">침대 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">매트리스·토퍼 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">테이블·식탁·책상 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">소파 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">서랍·수납장 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">거실장·TV장 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">선반 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">진열장·책장 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">의자 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">행거.옷장 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">거울 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">화장대.콘솔 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">유아동가구 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">야외가구 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">가벽.파티션 <span class="sidebar-arrow">∨</span></div>
            <div class="sidebar-item">공간별가구 <span class="sidebar-arrow">∨</span></div>
        </div>

        <div class="other-categories">
            <div class="other-item">폭염대비</div>
            <div class="other-item">패브릭</div>
            <div class="other-item">가전·디지털</div>
            <div class="other-item">주방용품</div>
            <div class="other-item">식품</div>
            <div class="other-item">수납·정리</div>
            <div class="other-item">생활용품</div>
            <div class="other-item">생필품</div>
            <div class="other-item">유아.아동</div>
            <div class="other-item">반려동물</div>
            <div class="other-item">캠핑.레저</div>
            <div class="other-item">공구.DIY</div>
            <div class="other-item">인테리어시공</div>
            <div class="other-item">렌탈.구독</div>
            <div class="other-item">장보기</div>
        </div>
    </aside>

    <!-- 우측 메인 컨텐츠 -->
    <div class="main-content">
        
        <div class="banner-header">가구</div>
        <div class="category-banners">
            <div class="banner-box"><img src="https://images.unsplash.com/photo-1554995207-c18c203602cb?w=400" alt="가구배너1"></div>
            <div class="banner-box"><img src="https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=400" alt="가구배너2"></div>
            <div class="banner-box"><img src="https://images.unsplash.com/photo-1583847268964-b28ce8f30321?w=400" alt="가구배너3"></div>
        </div>

        <div class="filter-section">
            <div class="filter-row">
                <button class="filter-btn active" style="color:#00A6EA; border-color:#00A6EA;">% 오세일특가</button>
                <button class="filter-btn" style="color:#00A6EA; font-weight:700;">🚚 원하는날도착</button>
                <button class="filter-btn" style="color:#FF7777;">📦 패키지 할인</button>
                <button class="filter-btn">색상 ∨</button>
                <button class="filter-btn">주요 소재 ∨</button>
                <button class="filter-btn">우드톤 ∨</button>
                <button class="filter-btn">바이너리샵 ∨</button>
                <button class="filter-btn">사용 인원 ∨</button>
            </div>
            <div class="filter-row">
                <button class="filter-btn">리퍼 상품 ∨</button>
                <button class="filter-btn">패키지 할인 ∨</button>
                <button class="filter-btn">상품 유형 ∨</button>
                <button class="filter-btn">브랜드 ∨</button>
                <button class="filter-btn">특가 ∨</button>
                <button class="filter-btn">오늘의집only ∨</button>
                <button class="filter-btn">가격 ∨</button>
                <button class="filter-btn">배송 ∨</button>
            </div>
        </div>

        <div class="list-header">
            <span class="list-count">전체 311,647개</span>
            <select class="sort-select">
                <option>추천순 ∨</option>
                <option>인기순</option>
                <option>최신순</option>
                <option>가격 낮은순</option>
            </select>
        </div>
        <%--상품 정보 썸네일 이나 이름 클릭 시 a태그로 상세페이지 리다이렉트--%>
        <a href="${pageContext.request.contextPath}/productDetail.htm?product_id=10001"
   class="product-card">
        <div class="product-grid">
            
            <div class="product-card">
                <div class="product-img-wrap">
                    <span class="only-badge">Only</span>
                    <img src="https://images.unsplash.com/photo-1505693314120-0d443867891c?w=400" alt="침대1">
                </div>
                <div class="brand">휴도</div>
                <div class="title">지정일배송/무료설치 | 편안한 제주 25cm 본넬스프링 침대</div>
                <div class="price-wrap"><span class="discount">30%</span><span class="price">429,000</span></div>
                <div class="review-wrap"><span class="star">★</span> 4.8 <span style="color:#9E9E9E; font-weight:400;">리뷰 310</span></div>
                <div class="badge-wrap">
                    <span class="badge badge-free">무료배송</span><span class="badge badge-special">특가</span>
                </div>
            </div>

            <div class="product-card">
                <div class="product-img-wrap">
                    <span class="only-badge">Only</span>
                    <img src="https://images.unsplash.com/photo-1584622781564-1d987f7333c1?w=400" alt="침대2">
                </div>
                <div class="brand">지누스</div>
                <div class="title">[오늘의집 단독] 컴피 토퍼 분리형 포켓 스프링 매트리스 28cm</div>
                <div class="price-wrap"><span class="discount">50%</span><span class="price">259,000</span></div>
                <div class="review-wrap"><span class="star">★</span> 4.9 <span style="color:#9E9E9E; font-weight:400;">리뷰 94</span></div>
                <div class="badge-wrap">
                    <span class="badge badge-free">무료배송</span><span class="badge badge-special">특가</span>
                </div>
            </div>

            <div class="product-card">
                <div class="product-img-wrap">
                    <img src="https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=400" alt="침대3">
                </div>
                <div class="brand">수면밀도</div>
                <div class="title">허리 디스크 환자가 만든 매트리스 S/SS/Q/K/LK 미디엄하드</div>
                <div class="price-wrap"><span class="discount">37%</span><span class="price">499,000</span></div>
                <div class="review-wrap"><span class="star">★</span> 4.9 <span style="color:#9E9E9E; font-weight:400;">리뷰 114</span></div>
                <div class="badge-wrap">
                    <span class="badge badge-free" style="color:#00A6EA; background:#F4FBFE; border:1px solid #00A6EA;">🚚 원하는날도착</span>
                </div>
            </div>

            <div class="product-card">
                <div class="product-img-wrap">
                    <img src="https://images.unsplash.com/photo-1505691938895-1758d7feb511?w=400" alt="소파">
                </div>
                <div class="brand">데일리리빙</div>
                <div class="title">[쿠폰가 48.4만][오늘의집 단독] 팬텀 4인용 프리미엄 타워 스프링 소파</div>
                <div class="price-wrap"><span class="discount">35%</span><span class="price">189,000</span></div>
                <div class="review-wrap"><span class="star">★</span> 4.8 <span style="color:#9E9E9E; font-weight:400;">리뷰 2,017</span></div>
                <div class="badge-wrap">
                    <span class="badge badge-free">조건부 무료배송</span>
                </div>
            </div>

            <div class="product-card">
                <div class="product-img-wrap">
                    <img src="https://images.unsplash.com/photo-1540574163026-643ea20d25b5?w=400" alt="책상">
                </div>
                <div class="brand">플랫포인트</div>
                <div class="title">[BEST] 플랫포인트 의자/수납/식탁 인기가구 BIG SALE 모음전</div>
                <div class="price-wrap"><span class="discount">42%</span><span class="price">8,300 외</span></div>
                <div class="review-wrap"><span class="star">★</span> 4.9 <span style="color:#9E9E9E; font-weight:400;">리뷰 2,973</span></div>
            </div>

        </div>
        </a>
    </div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />