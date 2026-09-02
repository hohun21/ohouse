<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    /*
     * 신상 추천 화면 확인용 임시 데이터
     * 순서: 브랜드, 상품명, 할인율, 가격, 평점, 리뷰 수, 이미지 URL
     *
     * 나중에는 RankHandler가 아니라 원하는날도착 전용 Handler에서
     * 최신 등록순 20개를 newProductList로 전달하면 됩니다.
     */
    String[][] newProducts = {
        {"한샘", "포레 릴렉스 4인 패브릭 소파", "31", "799,000", "4.9", "리뷰 128", "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=700&q=85"},
        {"리바트", "뉴트 저상형 퀸 침대 프레임", "28", "459,000", "4.8", "리뷰 94", "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=700&q=85"},
        {"까사미아", "브루노 원목 6인 식탁", "22", "689,000", "4.9", "리뷰 76", "https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=700&q=85"},
        {"일룸", "로이모노 1200폭 책상 세트", "18", "529,000", "4.8", "리뷰 203", "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?auto=format&fit=crop&w=700&q=85"},
        {"마켓비", "SIMPLIE 수납장 3문형", "35", "129,000", "4.7", "리뷰 315", "https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=700&q=85"},
        {"우드레이", "라운드 원목 거실 테이블", "24", "149,000", "4.9", "리뷰 87", "https://images.unsplash.com/photo-1532372320572-cda25653a694?auto=format&fit=crop&w=700&q=85"},
        {"잉글랜더", "엘리 템바보드 높은 거실장", "42", "219,000", "4.7", "리뷰 164", "https://images.unsplash.com/photo-1615874694520-474822394e73?auto=format&fit=crop&w=700&q=85"},
        {"삼익가구", "클로이 아쿠아텍스 3인 소파", "47", "319,000", "4.8", "리뷰 526", "https://images.unsplash.com/photo-1550254478-ead40cc54513?auto=format&fit=crop&w=700&q=85"},
        {"동서가구", "편백나무 수납형 침대 Q", "39", "389,000", "4.8", "리뷰 248", "https://images.unsplash.com/photo-1505693314120-0d443867891c?auto=format&fit=crop&w=700&q=85"},
        {"에넥스", "모던 슬라이딩 붙박이장 2400", "34", "759,000", "4.7", "리뷰 119", "https://images.unsplash.com/photo-1558997519-83ea9252edf8?auto=format&fit=crop&w=700&q=85"},
        {"보루네오", "루나 5단 와이드 서랍장", "36", "179,000", "4.6", "리뷰 182", "https://images.unsplash.com/photo-1595514535215-75fcb1e50d0b?auto=format&fit=crop&w=700&q=85"},
        {"모던하우스", "오슬로 내추럴 벤치 식탁 세트", "27", "399,000", "4.9", "리뷰 141", "https://images.unsplash.com/photo-1604578762246-41134e37f9cc?auto=format&fit=crop&w=700&q=85"},
        {"데스커", "모션데스크 플러스 1400", "15", "649,000", "4.9", "리뷰 338", "https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=700&q=85"},
        {"레이디가구", "멜로우 천연가죽 4인 소파", "41", "899,000", "4.8", "리뷰 97", "https://images.unsplash.com/photo-1540574163026-643ea20d25b5?auto=format&fit=crop&w=700&q=85"},
        {"지누스", "스마트베이스 엘리트 침대 프레임", "30", "209,000", "4.9", "리뷰 764", "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=700&q=85"},
        {"블루밍홈", "비엔나 패브릭 라운지 체어", "33", "89,900", "4.7", "리뷰 221", "https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=700&q=85"},
        {"벤트리", "원목 접이식 확장형 식탁", "29", "269,000", "4.8", "리뷰 156", "https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=700&q=85"},
        {"아이엔지홈", "킨포크 800 옷장 행거형", "38", "199,000", "4.6", "리뷰 109", "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?auto=format&fit=crop&w=700&q=85"},
        {"무니토", "클라우드 모듈 패브릭 소파", "20", "1,280,000", "4.9", "리뷰 68", "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=700&q=85"},
        {"두닷", "콰트로 에어 데스크 1600", "25", "249,000", "4.8", "리뷰 412", "https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?auto=format&fit=crop&w=700&q=85"}
    };

    String[] roomNames = {"침실", "파우더룸", "거실", "서재", "주방", "드레스룸"};

    /*
     * 공간별 상품 묶음 화면 확인용 데이터
     * 순서: 공간명, 해시태그, 배너 문구, 예비 배너 이미지, 카테고리 ID,
     *       아래 상품 index 10개, 대표 이미지 상품 index 3개
     * 여러 카테고리는 categoryIds에 쉼표로 보관합니다.
     * 현재 덤프에서 확인되지 않은 ID는 숫자를 추측하지 않고 빈 값으로 두었습니다.
     */
    String[][] roomGroups = {
        {"침실", "#매트리스", "편안한 잠을 위한 매트리스", "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1200&q=88", "10130001", "8,14,1,9,10,17,4,6", "8,14,1"},
        {"침실", "#침대프레임", "오늘의집이 고른 침대 프레임", "https://images.unsplash.com/photo-1505693314120-0d443867891c?auto=format&fit=crop&w=1200&q=88", "10120001", "1,8,14,9,17,10,4,6", "1,8,14"},
        {"파우더룸", "#수납가구 #화장대", "가구의정석 파우더룸", "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=1200&q=88", "13050000", "4,10,9,5,6,17,3,12", "4,10,9"},
        {"거실", "#소파", "편안한 휴식을 위한 소파", "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=88", "", "0,7,13,18,5,6,15,4", "0,7,13"},
        {"거실", "#수납장 #테이블", "거실을 완성하는 수납장과 테이블", "https://images.unsplash.com/photo-1615874694520-474822394e73?auto=format&fit=crop&w=1200&q=88", "10150001", "4,5,6,10,2,11,16,3", "5,6,4"},
        {"서재", "#책상 #책장 #의자", "집중이 잘 되는 나만의 서재", "https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1200&q=88", "", "3,12,15,19,4,6,10,5", "3,12,15"},
        {"주방", "#식탁 #의자", "함께하는 시간을 위한 식탁", "https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=1200&q=88", "", "2,11,16,15,5,3,12,4", "2,11,16"},
        {"주방", "#주방수납장", "깔끔한 주방을 위한 수납가구", "https://images.unsplash.com/photo-1556912167-f556f1f39fdf?auto=format&fit=crop&w=1200&q=88", "", "4,6,10,9,5,2,11,16", "4,6,10"},
        {"드레스룸", "#붙박이장 #옷장", "옷과 소품을 한곳에 정리하는 드레스룸", "https://images.unsplash.com/photo-1558997519-83ea9252edf8?auto=format&fit=crop&w=1200&q=88", "13020000", "9,17,10,4,6,3,12,15", "9,17,10"}
    };

    /* 프리미엄 대표 브랜드 3개: 브랜드명, 영문명, 대표 상품명, 이미지 */
    String[][] premiumTopBrands = {
        {"더리빙", "The Lane", "아레스 사이드보드 슬라이드 수납장", "https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=1200&q=88"},
        {"플랫포인트", "flat point", "오브제 라운드 미러 콘솔", "https://images.unsplash.com/photo-1615874694520-474822394e73?auto=format&fit=crop&w=1200&q=88"},
        {"잭슨카멜레온", "JACKSON CHAMELEON", "Kante 소파 테이블", "https://images.unsplash.com/photo-1532372320572-cda25653a694?auto=format&fit=crop&w=1200&q=88"}
    };

    /* 위 3개 브랜드의 원하는날도착 상품 */
    String[][] premiumProducts = {
        {"더리빙", "아레스 사이드보드 슬라이드 수납장", "24", "860,000", "4.9", "리뷰 36", "https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=700&q=85"},
        {"더리빙", "오크 원목 높은 거실장", "18", "690,000", "4.8", "리뷰 42", "https://images.unsplash.com/photo-1615874694520-474822394e73?auto=format&fit=crop&w=700&q=85"},
        {"더리빙", "내추럴 월넛 다이닝 테이블", "12", "1,190,000", "4.9", "리뷰 28", "https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=700&q=85"},
        {"플랫포인트", "틴트 미러 S/M/L", "20", "320,000", "4.9", "리뷰 67", "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=700&q=85"},
        {"플랫포인트", "오브제 라운드 콘솔 테이블", "15", "320,000", "4.8", "리뷰 196", "https://images.unsplash.com/photo-1532372320572-cda25653a694?auto=format&fit=crop&w=700&q=85"},
        {"플랫포인트", "세리즈 원형 다이닝 테이블", "29", "584,000", "4.8", "리뷰 364", "https://images.unsplash.com/photo-1577140917170-285929fb55b7?auto=format&fit=crop&w=700&q=85"},
        {"잭슨카멜레온", "Kante Sofa Table", "16", "737,000", "4.9", "리뷰 172", "https://images.unsplash.com/photo-1532372320572-cda25653a694?auto=format&fit=crop&w=700&q=85"},
        {"잭슨카멜레온", "Clay 라운지 체어", "22", "390,000", "4.9", "리뷰 90", "https://images.unsplash.com/photo-1567538096630-e0c55bd6374c?auto=format&fit=crop&w=700&q=85"},
        {"잭슨카멜레온", "Pebble 모듈 패브릭 소파", "19", "1,240,000", "4.9", "리뷰 69", "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?auto=format&fit=crop&w=700&q=85"}
    };

    /* 브랜드 큐레이션 6개: 한글명, 영문명, 이미지 */
    String[][] premiumCurationBrands = {
        {"오늘의집 레이어", "layer", "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=85"},
        {"프라토", "FRKT", "https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=800&q=85"},
        {"더리빙", "The Lane", "https://images.unsplash.com/photo-1595428774223-ef52624120d2?auto=format&fit=crop&w=800&q=85"},
        {"플랫포인트", "flat point", "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=800&q=85"},
        {"잭슨카멜레온", "JACKSON CHAMELEON", "https://images.unsplash.com/photo-1532372320572-cda25653a694?auto=format&fit=crop&w=800&q=85"},
        {"바이헤이데이", "BYHEYDEY", "https://images.unsplash.com/photo-1540574163026-643ea20d25b5?auto=format&fit=crop&w=800&q=85"}
    };

    /* 판매상품 전체보기: 공간명, 상품 종류, 화면 확인용 상품 index */
    String[][] allProductGroups = {
        {"거실", "선반·수납장", "4,6,10,9,17,3"},
        {"거실", "소파테이블", "5,16,2,11,12,19"},
        {"거실", "소파", "0,7,13,18,15,5"},
        {"침실", "매트리스·토퍼", "8,14,1,9,10,17"},
        {"침실", "침대프레임", "1,8,14,9,17,10"},
        {"주방", "식탁·의자", "2,11,16,15,5,3"},
        {"주방", "주방수납장", "4,6,10,9,17,2"},
        {"드레스룸", "붙박이장·옷장", "9,17,10,4,6,3"},
        {"서재", "책상·책장·의자", "3,12,15,19,4,6"},
        {"파우더룸", "수납장·화장대", "4,10,9,5,6,17"}
    };
%>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    .delivery-page * { box-sizing: border-box; }
    .delivery-page button { font: inherit; }

    .delivery-page {
        width: 1136px;
        margin: 0 auto;
        padding: 0 15px 100px;
        display: grid;
        grid-template-columns: minmax(0, 760px) 306px;
        gap: 40px;
        align-items: start;
    }

    .delivery-content { min-width: 0; background: #fff; }

    /* 원하는날도착 섹션 이동 헤더 */
    .delivery-tabs {
        position: relative;
        z-index: 10;
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        height: 72px;
        background: #000;
    }

    .delivery-tab {
        position: relative;
        border: 0;
        color: #777;
        background: #000;
        font-size: 18px;
        font-weight: 800;
        letter-spacing: -0.4px;
        cursor: pointer;
    }

    .delivery-tab:hover { color: #cfcfcf; }
    .delivery-tab.active { color: #fff; }

    .delivery-tab.active::after {
        content: "";
        position: absolute;
        right: 0;
        bottom: 0;
        left: 0;
        height: 3px;
        background: #fff;
    }

    /* 쿠폰 섹션 */
    .coupon-section {
        padding: 110px 32px 70px;
        background: linear-gradient(180deg, #def3ff 0%, #f7fbfe 22%, #fff 48%);
    }

    .coupon-heading { margin-bottom: 70px; text-align: center; }
    .coupon-eyebrow { margin-bottom: 12px; color: #172b3a; font-size: 22px; font-weight: 800; }
    .coupon-heading h1 { margin: 0 0 12px; color: #000; font-size: 44px; line-height: 1.2; font-weight: 900; letter-spacing: -2px; }
    .coupon-heading p { margin: 0; color: #5d6267; font-size: 20px; letter-spacing: -0.6px; }

    .coupon-list { display: flex; flex-direction: column; gap: 12px; }

    .coupon-card {
        display: grid;
        grid-template-columns: 1fr 124px;
        min-height: 174px;
        overflow: hidden;
        color: #fff;
        background: #232323;
        border-radius: 16px;
    }

    .coupon-info { padding: 28px 38px; }
    .coupon-price { margin-bottom: 8px; font-size: 47px; line-height: 1.1; font-weight: 400; letter-spacing: -2px; }
    .coupon-name { margin-bottom: 3px; color: #d8d8d8; font-size: 17px; font-weight: 600; }
    .coupon-condition { color: #eee; font-size: 17px; font-weight: 700; }

    .coupon-download {
        position: relative;
        display: grid;
        place-items: center;
        border: 0;
        border-left: 1px dashed #616161;
        color: #fff;
        background: #232323;
        cursor: pointer;
    }

    .coupon-download::before,
    .coupon-download::after {
        content: "";
        position: absolute;
        left: -11px;
        width: 20px;
        height: 20px;
        background: #fff;
        border-radius: 50%;
    }

    .coupon-download::before { top: -10px; }
    .coupon-download::after { bottom: -10px; }
    .download-icon { font-size: 37px; font-weight: 300; transform: translateY(-3px); }
    .coupon-download:hover { background: #161616; }
    .coupon-download.received { color: #929292; background: #1b1b1b; cursor: default; }

    /* 신상 추천 상품 */
    .new-section {
        padding: 96px 0 90px;
        scroll-margin-top: 95px;
        background: #fff;
        border-top: 10px solid #F7F9FA;
    }

    .new-section-heading {
        margin-bottom: 58px;
        padding: 0 2px;
        text-align: center;
    }

    .new-section-heading h2 {
        margin: 0 0 12px;
        color: #000;
        font-family: Pretendard, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        font-size: 42px;
        line-height: 1.2;
        font-weight: 900;
        letter-spacing: -1.8px;
    }

    .new-section-heading p {
        margin: 0;
        color: #424242;
        font-family: Pretendard, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        font-size: 18px;
        line-height: 1.5;
        font-weight: 400;
        letter-spacing: -0.5px;
    }

    .new-product-grid {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 42px 18px;
    }

    .delivery-product-card {
        min-width: 0;
        cursor: pointer;
    }

    .delivery-product-card > a {
        display: block;
        color: inherit;
        text-decoration: none;
    }

    .delivery-product-card .product-img-wrap {
        position: relative;
        width: 100%;
        aspect-ratio: 1 / 1;
        margin-bottom: 12px;
        overflow: hidden;
        border-radius: 8px;
        background: #F7F9FA;
    }

    .delivery-product-card .product-img-wrap img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.2s;
    }

    .delivery-product-card:hover .product-img-wrap img {
        transform: scale(1.05);
    }

    .delivery-product-card .brand {
        margin-bottom: 4px;
        color: #757575;
        font-size: 11px;
        font-weight: 600;
    }

    .delivery-product-card .title {
        display: -webkit-box;
        margin: 0;
        overflow: hidden;
        color: #2F3438;
        font-size: 13px;
        line-height: 1.4;
        font-weight: 400;
        letter-spacing: -0.3px;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
    }

    .delivery-product-card .price-wrap {
        display: flex;
        align-items: baseline;
        gap: 4px;
        margin: 5px 0;
        color: #000;
        font-size: 17px;
        line-height: 22px;
        font-weight: 700;
    }

    .delivery-product-card .discount { color: #35C5F0; }
    .delivery-product-card .price { color: #000; }

    .delivery-product-card .review-wrap {
        display: flex;
        align-items: center;
        gap: 3px;
        margin: 0;
        color: #424242;
        font-size: 12px;
        line-height: 17px;
        font-weight: 700;
    }

    .delivery-product-card .star { color: #35C5F0; font-size: 12px; }
    .delivery-product-card .review-count { color: #9E9E9E; font-weight: 400; }

    /* 공간별 가구 */
    .space-section {
        padding: 96px 0 92px;
        scroll-margin-top: 95px;
        background: linear-gradient(180deg, #EAF8FF 0, #fff 270px);
        border-top: 10px solid #F7F9FA;
    }

    .space-section-heading {
        margin-bottom: 68px;
        text-align: center;
    }

    .space-section-heading h2 {
        margin: 0 0 12px;
        color: #000;
        font-family: Pretendard, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        font-size: 48px;
        line-height: 1.2;
        font-weight: 900;
        letter-spacing: -1.8px;
    }

    .space-section-heading p {
        margin: 0;
        color: #424242;
        font-size: 21px;
        line-height: 1.5;
        letter-spacing: -0.5px;
    }

    .room-selector {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        margin: 0 28px 78px;
        border-top: 1px solid #EAEDEF;
        border-bottom: 1px solid #EAEDEF;
    }

    .room-selector-btn {
        position: relative;
        height: 72px;
        border: 0;
        color: #9E9E9E;
        background: #fff;
        font-size: 19px;
        line-height: 72px;
        font-weight: 500;
        cursor: pointer;
    }

    .room-selector-btn:nth-child(n + 4) { border-top: 1px solid #EAEDEF; }
    .room-selector-btn:hover { color: #424242; }
    .room-selector-btn.active { color: #111; font-weight: 800; }

    .room-selector-btn.active::after {
        content: "";
        position: absolute;
        right: 0;
        bottom: -1px;
        left: 0;
        height: 4px;
        background: #111;
    }

    .room-group { margin: 0 36px 82px; }
    .room-group:last-child { margin-bottom: 0; }

    .room-group-heading {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
        margin-bottom: 24px;
    }

    .room-group-title h3 {
        margin: 0 0 4px;
        color: #111;
        font-size: 28px;
        line-height: 1.3;
        font-weight: 800;
        letter-spacing: -0.7px;
    }

    .room-group-title p {
        margin: 0;
        color: #757575;
        font-size: 22px;
        line-height: 1.4;
        font-weight: 400;
        letter-spacing: -0.6px;
    }

    .room-more {
        flex: 0 0 auto;
        min-width: 94px;
        height: 46px;
        padding: 0 18px;
        border: 1px solid #DADDE0;
        border-radius: 23px;
        color: #424242;
        background: #fff;
        font-size: 16px;
        line-height: 44px;
        font-weight: 600;
        text-align: center;
        text-decoration: none;
    }

    .room-more:hover { background: #F7F9FA; }

    .room-carousel {
        position: relative;
        width: 100%;
        margin-bottom: 38px;
    }

    .room-hero-viewport {
        position: relative;
        width: 100%;
        aspect-ratio: 1.29 / 1;
        overflow: visible;
        border-radius: 15px;
        background: #F7F9FA;
    }

    .room-hero-slide {
        position: absolute;
        inset: 0;
        overflow: hidden;
        border-radius: 15px;
        visibility: hidden;
        opacity: 0;
        transition: opacity 0.25s ease;
    }

    .room-hero-slide.active { visibility: visible; opacity: 1; }

    .room-hero-slide img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.25s ease;
    }

    .room-hero-slide:hover img { transform: scale(1.02); }

    .room-hero-slide::after {
        content: "";
        position: absolute;
        inset: 48% 0 0;
        background: linear-gradient(180deg, transparent, rgba(0, 0, 0, 0.58));
        pointer-events: none;
    }

    .room-hero-copy {
        position: absolute;
        right: 30px;
        bottom: 28px;
        left: 30px;
        z-index: 2;
        color: #fff;
        text-shadow: 0 1px 5px rgba(0, 0, 0, 0.35);
    }

    .room-hero-brand {
        margin-bottom: 3px;
        font-size: 17px;
        line-height: 1.35;
        font-weight: 700;
    }

    .room-hero-name {
        font-size: 20px;
        line-height: 1.4;
        font-weight: 500;
        text-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);
    }

    .room-hero-prev,
    .room-hero-next,
    .room-products-prev,
    .room-products-next {
        position: absolute;
        z-index: 5;
        display: grid;
        place-items: center;
        width: 46px;
        height: 46px;
        border: 0;
        border-radius: 50%;
        color: #424242;
        background: #fff;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.14);
        font-size: 0;
        cursor: pointer;
    }

    .room-hero-prev::before,
    .room-hero-next::before,
    .room-products-prev::before,
    .room-products-next::before {
        content: "";
        width: 11px;
        height: 11px;
        border-top: 2px solid #2F3438;
        border-right: 2px solid #2F3438;
    }

    .room-hero-prev::before,
    .room-products-prev::before {
        transform: translateX(2px) rotate(-135deg);
    }

    .room-hero-next::before,
    .room-products-next::before {
        transform: translateX(-2px) rotate(45deg);
    }

    .room-hero-prev:hover,
    .room-hero-next:hover,
    .room-products-prev:hover,
    .room-products-next:hover {
        background: #F7F9FA;
        box-shadow: 0 3px 12px rgba(0, 0, 0, 0.18);
    }

    .room-hero-prev { left: -23px; top: calc(50% - 34px); }
    .room-hero-next { right: -23px; top: calc(50% - 34px); }

    .room-hero-prev:disabled,
    .room-hero-next:disabled,
    .room-products-prev:disabled,
    .room-products-next:disabled { display: none; }

    .room-hero-dots {
        display: flex;
        justify-content: center;
        gap: 6px;
        height: 30px;
        padding-top: 13px;
    }

    .room-hero-dot {
        width: 8px;
        height: 8px;
        padding: 0;
        border: 0;
        border-radius: 50%;
        background: #D5D5D5;
        cursor: pointer;
    }

    .room-hero-dot.active { background: #424242; }

    .room-products-wrap { position: relative; }

    .room-product-scroller {
        display: flex;
        gap: 16px;
        overflow-x: auto;
        scroll-behavior: smooth;
        scrollbar-width: none;
    }

    .room-product-scroller::-webkit-scrollbar { display: none; }
    .room-product-scroller .delivery-product-card { flex: 0 0 calc((100% - 48px) / 4); }
    .room-product-scroller .delivery-product-card .product-img-wrap { border-radius: 4px; }
    .room-product-scroller .delivery-product-card .title { font-size: 12px; }
    .room-product-scroller .delivery-product-card .price-wrap { font-size: 15px; }
    .room-products-prev { left: -23px; top: 76px; }
    .room-products-next { right: -23px; top: 76px; }

    /* 다음 단계용 섹션 */
    .planned-section {
        min-height: 380px;
        padding: 90px 32px;
        text-align: center;
        border-top: 1px solid #EAEDEF;
    }

    .planned-section h2 { margin: 0 0 10px; font-size: 30px; }
    .planned-section p { margin: 0; color: #828C94; font-size: 14px; }

    /* 프리미엄 브랜드 */
    .premium-section {
        padding: 96px 28px 0;
        scroll-margin-top: 95px;
        background: linear-gradient(180deg, #EAF8FF 0, #fff 300px);
        border-top: 10px solid #F7F9FA;
    }

    .premium-heading {
        margin-bottom: 62px;
        text-align: center;
    }

    .premium-heading h2,
    .premium-curation-heading h2 {
        margin: 0 0 13px;
        color: #000;
        font-size: 42px;
        line-height: 1.18;
        font-weight: 900;
        letter-spacing: -1.7px;
    }

    .premium-heading p,
    .premium-curation-heading p {
        margin: 0;
        color: #5D6267;
        font-size: 19px;
        line-height: 1.5;
        letter-spacing: -0.5px;
    }

    .premium-carousel { margin: 0 0 20px; }
    .premium-carousel .room-hero-viewport { aspect-ratio: 1.42 / 1; }

    .premium-product-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 46px 18px;
        padding: 0 0 100px;
    }

    .premium-product-grid .delivery-product-card .product-img-wrap { border-radius: 4px; }

    .premium-curation {
        margin: 0 -28px;
        padding: 92px 32px 104px;
        background: #EAF8FF;
    }

    .premium-curation-heading {
        margin-bottom: 54px;
        text-align: center;
    }

    .premium-brand-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        overflow: hidden;
        border-radius: 14px;
        background: #fff;
    }

    .premium-brand-card {
        position: relative;
        display: block;
        aspect-ratio: 1.55 / 1;
        overflow: hidden;
        color: #fff;
        text-decoration: none;
    }

    .premium-brand-card:nth-child(odd) { border-right: 2px solid #fff; }
    .premium-brand-card:nth-child(n + 3) { border-top: 2px solid #fff; }

    .premium-brand-card img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.25s ease;
    }

    .premium-brand-card:hover img { transform: scale(1.04); }

    .premium-brand-card::after {
        content: "";
        position: absolute;
        inset: 0;
        background: rgba(0, 0, 0, 0.25);
    }

    .premium-brand-name {
        position: absolute;
        top: 50%;
        right: 14px;
        left: 14px;
        z-index: 1;
        transform: translateY(-50%);
        text-align: center;
        text-shadow: 0 1px 5px rgba(0, 0, 0, 0.45);
    }

    .premium-brand-name strong {
        display: block;
        margin-bottom: 2px;
        font-size: 19px;
        line-height: 1.3;
        font-weight: 800;
    }

    .premium-brand-name span {
        display: block;
        font-size: 13px;
        line-height: 1.3;
        font-weight: 500;
    }

    .premium-clearance-link {
        display: flex;
        align-items: center;
        justify-content: space-between;
        min-height: 128px;
        margin-top: 42px;
        padding: 24px 36px;
        overflow: hidden;
        border-radius: 14px;
        color: #2F3438;
        background: #CDEEFF;
        text-decoration: none;
        transition: background-color 0.18s ease;
    }

    .premium-clearance-link:hover { background: #BFE8FC; }

    .premium-clearance-copy strong {
        display: block;
        margin-bottom: 8px;
        font-size: 19px;
        line-height: 1.35;
        font-weight: 800;
        letter-spacing: -0.5px;
    }

    .premium-clearance-copy span {
        display: block;
        font-size: 15px;
        line-height: 1.4;
    }

    .premium-clearance-icon {
        flex: 0 0 auto;
        font-size: 68px;
        line-height: 1;
        transform: translateY(2px);
    }

    .all-products {
        min-height: 500px;
        padding: 28px 0 90px;
        scroll-margin-top: 95px;
        background: #fff;
        border-top: 1px solid #EAEDEF;
    }

    .all-products-nav {
        position: sticky;
        top: 80px;
        z-index: 30;
        display: flex;
        align-items: center;
        gap: 6px;
        margin-bottom: 36px;
        padding: 14px 0 20px;
        overflow-x: auto;
        background: #fff;
        border-bottom: 1px solid #EAEDEF;
        scrollbar-width: none;
    }

    .all-products-nav::-webkit-scrollbar { display: none; }

    .all-products-filter {
        flex: 0 0 auto;
        height: 36px;
        padding: 0 14px;
        border: 1px solid #DADDE0;
        border-radius: 18px;
        color: #424242;
        background: #fff;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
    }

    .all-products-filter.active,
    .all-products-filter:hover {
        border-color: #2F3438;
        color: #fff;
        background: #2F3438;
    }

    .all-product-group {
        margin-bottom: 78px;
    }

    .all-product-group:last-child { margin-bottom: 0; }

    .all-product-group[hidden] { display: none; }

    .all-product-type {
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 96px;
        margin-bottom: 38px;
        padding: 26px 16px;
        color: #111;
        background: #FAFBFC;
        font-size: 21px;
        line-height: 1.35;
        font-weight: 800;
        letter-spacing: -0.6px;
        text-align: center;
    }

    .all-product-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 48px 18px;
    }

    .all-product-grid .delivery-product-card .product-img-wrap { border-radius: 4px; }

    .all-products-empty {
        display: none;
        padding: 80px 20px;
        color: #828C94;
        text-align: center;
    }

    /* 오른쪽 고정 안내 패널 */
    .delivery-side {
        position: sticky;
        top: 112px;
        min-height: calc(100vh - 132px);
        padding-top: 12px;
    }

    .side-eyebrow { margin-bottom: 10px; color: #757575; font-size: 13px; }
    .delivery-side h2 { margin: 0 0 20px; color: #2F3438; font-size: 16px; line-height: 1.5; font-weight: 800; }

    .side-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 20px; }
    .side-action {
        height: 44px;
        border: 1px solid #DADDE0;
        border-radius: 6px;
        color: #2F3438;
        background: #fff;
        font-size: 14px;
        cursor: pointer;
    }

    .side-action:hover { background: #F7F9FA; }

    .view-products-btn {
        width: 100%;
        height: 44px;
        border: 0;
        border-radius: 6px;
        color: #fff;
        background: #00A6EA;
        font-size: 14px;
        font-weight: 700;
        cursor: pointer;
    }

    .view-products-btn:hover { background: #0098D7; }

    .top-btn {
        position: fixed;
        right: 28px;
        bottom: 28px;
        z-index: 1100;
        display: none;
        width: 46px;
        height: 46px;
        border: 1px solid #EAEDEF;
        border-radius: 50%;
        color: #424242;
        background: #fff;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.13);
        font-size: 24px;
        cursor: pointer;
    }

    @media (max-width: 1180px) {
        .delivery-page { width: 100%; padding-right: 20px; padding-left: 20px; grid-template-columns: minmax(0, 1fr) 290px; gap: 28px; }
    }

    @media (max-width: 860px) {
        .delivery-page { display: block; padding: 0 0 80px; }
        .delivery-content { width: 100%; }
        .delivery-side { position: relative; top: auto; min-height: 0; padding: 28px 20px; border-top: 8px solid #F7F9FA; }
        .delivery-tab { font-size: 15px; }
        .coupon-section { padding: 75px 18px 55px; }
        .coupon-heading h1 { font-size: 36px; }
        .coupon-price { font-size: 35px; }
        .coupon-card { grid-template-columns: 1fr 90px; min-height: 145px; }
        .coupon-info { padding: 25px 24px; }
        .new-section { padding-right: 16px; padding-left: 16px; }
        .new-section-heading { margin-bottom: 38px; }
        .new-section-heading h2 { font-size: 32px; }
        .new-section-heading p { font-size: 15px; }
        .new-product-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 32px 12px; }
        .space-section { padding: 76px 16px 70px; }
        .space-section-heading { margin-bottom: 38px; }
        .space-section-heading h2 { font-size: 32px; }
        .space-section-heading p { font-size: 15px; }
        .room-selector { margin: 0 0 52px; }
        .room-selector-btn { height: 56px; font-size: 15px; line-height: 56px; }
        .room-group { margin: 0 0 64px; }
        .room-group-title h3 { font-size: 20px; }
        .room-group-title p { font-size: 16px; }
        .room-more { min-width: 72px; height: 38px; padding: 0 13px; border-radius: 19px; font-size: 13px; line-height: 36px; }
        .room-hero-viewport { aspect-ratio: 1.18 / 1; border-radius: 10px; }
        .room-hero-slide { border-radius: 10px; }
        .room-hero-prev { left: 8px; }
        .room-hero-next { right: 8px; }
        .room-product-scroller .delivery-product-card { flex-basis: calc((100% - 12px) / 2); }
        .room-products-prev { left: 8px; }
        .room-products-next { right: 8px; }
        .premium-section { padding: 76px 16px 0; }
        .premium-heading { margin-bottom: 42px; }
        .premium-heading h2,
        .premium-curation-heading h2 { font-size: 32px; }
        .premium-heading p,
        .premium-curation-heading p { font-size: 15px; }
        .premium-product-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 34px 12px; padding-bottom: 76px; }
        .premium-curation { margin: 0 -16px; padding: 70px 16px 78px; }
        .premium-brand-name strong { font-size: 15px; }
        .premium-brand-name span { font-size: 11px; }
        .premium-clearance-link { min-height: 104px; padding: 20px 22px; }
        .premium-clearance-copy strong { font-size: 16px; }
        .premium-clearance-copy span { font-size: 13px; }
        .premium-clearance-icon { font-size: 52px; }
        .all-products { padding: 22px 16px 72px; }
        .all-products-nav { top: 80px; margin-bottom: 30px; }
        .all-product-group { margin-bottom: 58px; }
        .all-product-type { min-height: 84px; margin-bottom: 28px; padding: 22px 14px; font-size: 18px; }
        .all-product-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 34px 12px; }
        .all-products { padding-right: 16px; padding-left: 16px; }
    }
</style>

<div class="delivery-page" id="deliveryTop">
    <main class="delivery-content">
        <nav class="delivery-tabs" aria-label="원하는날도착 기획전 메뉴">
            <button type="button" class="delivery-tab active" data-target="#couponSection">3종 쿠폰</button>
            <button type="button" class="delivery-tab" data-target="#newSection">신상 추천</button>
            <button type="button" class="delivery-tab" data-target="#spaceSection">공간별가구</button>
            <button type="button" class="delivery-tab" data-target="#premiumSection">프리미엄</button>
        </nav>

        <section class="coupon-section" id="couponSection">
            <div class="coupon-heading">
                <div class="coupon-eyebrow">🚚 원하는날도착</div>
                <h1>3종 쿠폰팩</h1>
                <p>가격도 배송도 가볍게!</p>
            </div>

            <div class="coupon-list">
                <article class="coupon-card">
                    <div class="coupon-info">
                        <div class="coupon-price">30,000원</div>
                        <div class="coupon-name">원하는날도착</div>
                        <div class="coupon-condition">100만원 이상 구매 시</div>
                    </div>
                    <button type="button" class="coupon-download" aria-label="3만원 쿠폰 받기"><span class="download-icon">⇩</span></button>
                </article>

                <article class="coupon-card">
                    <div class="coupon-info">
                        <div class="coupon-price">15,000원</div>
                        <div class="coupon-name">원하는날도착</div>
                        <div class="coupon-condition">50만원 이상 구매 시</div>
                    </div>
                    <button type="button" class="coupon-download" aria-label="1만 5천원 쿠폰 받기"><span class="download-icon">⇩</span></button>
                </article>

                <article class="coupon-card">
                    <div class="coupon-info">
                        <div class="coupon-price">5,000원</div>
                        <div class="coupon-name">원하는날도착</div>
                        <div class="coupon-condition">20만원 이상 구매 시</div>
                    </div>
                    <button type="button" class="coupon-download" aria-label="5천원 쿠폰 받기"><span class="download-icon">⇩</span></button>
                </article>
            </div>
        </section>

        <nav class="delivery-tabs" aria-label="원하는날도착 기획전 메뉴">
            <button type="button" class="delivery-tab" data-target="#couponSection">3종 쿠폰</button>
            <button type="button" class="delivery-tab active" data-target="#newSection">신상 추천</button>
            <button type="button" class="delivery-tab" data-target="#spaceSection">공간별가구</button>
            <button type="button" class="delivery-tab" data-target="#premiumSection">프리미엄</button>
        </nav>

        <section class="new-section" id="newSection">
            <div class="new-section-heading">
                <h2>신상품 추천</h2>
                <p>나다운 공간의 변화, 내가 원하는 날에!</p>
            </div>

            <div class="new-product-grid">
                <% for (String[] product : newProducts) { %>
                    <article class="delivery-product-card">
                        <a href="#" aria-label="<%= product[1] %>">
                            <div class="product-img-wrap">
                                <img src="<%= product[6] %>" alt="<%= product[1] %>" loading="lazy">
                            </div>

                            <div class="brand"><%= product[0] %></div>
                            <p class="title"><%= product[1] %></p>

                            <div class="price-wrap">
                                <span class="discount"><%= product[2] %>%</span>
                                <span class="price"><%= product[3] %></span>
                            </div>

                            <div class="review-wrap">
                                <span class="star">★</span>
                                <span><%= product[4] %></span>
                                <span class="review-count"><%= product[5] %></span>
                            </div>
                        </a>
                    </article>
                <% } %>
            </div>
        </section>
        <nav class="delivery-tabs" aria-label="원하는날도착 기획전 메뉴">
            <button type="button" class="delivery-tab" data-target="#couponSection">3종 쿠폰</button>
            <button type="button" class="delivery-tab" data-target="#newSection">신상 추천</button>
            <button type="button" class="delivery-tab active" data-target="#spaceSection">공간별가구</button>
            <button type="button" class="delivery-tab" data-target="#premiumSection">프리미엄</button>
        </nav>

        <section class="space-section" id="spaceSection">
            <div class="space-section-heading">
                <h2>공간별 가구 모아보기</h2>
                <p>묶어서 사면 배송도 한 번에</p>
            </div>

            <%
                String previousRoom = "";
                for (int groupIndex = 0; groupIndex < roomGroups.length; groupIndex++) {
                    String[] group = roomGroups[groupIndex];
                    String roomName = group[0];
                    boolean firstGroupOfRoom = !roomName.equals(previousRoom);

                    if (firstGroupOfRoom) {
            %>
                        <nav class="room-selector" aria-label="공간별 가구 선택">
                            <% for (int roomIndex = 0; roomIndex < roomNames.length; roomIndex++) { %>
                                <button type="button"
                                        class="room-selector-btn <%= roomNames[roomIndex].equals(roomName) ? "active" : "" %>"
                                        data-room-name="<%= roomNames[roomIndex] %>"><%= roomNames[roomIndex] %></button>
                            <% } %>
                        </nav>
            <%
                    }

                    String categoryIds = group[4];
                    String firstCategoryId = categoryIds.isEmpty() ? "" : categoryIds.split(",")[0];
                    String[] productIndexes = group[5].split(",");
                    String[] heroIndexes = group[6].split(",");
            %>
                    <article class="room-group" id="room-<%= roomName %>-<%= groupIndex %>" data-room="<%= roomName %>">
                        <div class="room-group-heading">
                            <div class="room-group-title">
                                <h3><%= roomName %></h3>
                                <p><%= group[1] %></p>
                            </div>

                            <a class="room-more <%= firstCategoryId.isEmpty() ? "category-id-pending" : "" %>"
                               href="<%= firstCategoryId.isEmpty() ? "#" : "category.htm?categoryId=" + firstCategoryId %>"
                               data-category-ids="<%= categoryIds %>">더보기</a>
                        </div>

                        <div class="room-carousel" data-slide-index="0">
                            <div class="room-hero-viewport">
                                <% for (int heroIndex = 0; heroIndex < heroIndexes.length; heroIndex++) {
                                    String[] heroProduct = newProducts[Integer.parseInt(heroIndexes[heroIndex])];
                                %>
                                    <a href="#" class="room-hero-slide <%= heroIndex == 0 ? "active" : "" %>" aria-label="<%= heroProduct[1] %>">
                                        <img src="<%= heroProduct[6] %>" alt="<%= heroProduct[1] %>" loading="lazy">
                                        <div class="room-hero-copy">
                                            <div class="room-hero-brand"><%= heroProduct[0] %></div>
                                            <div class="room-hero-name"><%= heroProduct[1] %></div>
                                        </div>
                                    </a>
                                <% } %>

                                <button type="button" class="room-hero-prev" aria-label="이전 대표 상품" disabled></button>
                                <button type="button" class="room-hero-next" aria-label="다음 대표 상품"></button>
                            </div>

                            <div class="room-hero-dots" aria-label="대표 상품 위치">
                                <% for (int heroIndex = 0; heroIndex < heroIndexes.length; heroIndex++) { %>
                                    <button type="button" class="room-hero-dot <%= heroIndex == 0 ? "active" : "" %>" data-slide="<%= heroIndex %>" aria-label="<%= heroIndex + 1 %>번째 대표 상품"></button>
                                <% } %>
                            </div>
                        </div>

                        <div class="room-products-wrap">
                            <div class="room-product-scroller">
                                <% for (String productIndex : productIndexes) {
                                    String[] product = newProducts[Integer.parseInt(productIndex)];
                                %>
                                    <article class="delivery-product-card">
                                        <a href="#" aria-label="<%= product[1] %>">
                                            <div class="product-img-wrap">
                                                <img src="<%= product[6] %>" alt="<%= product[1] %>" loading="lazy">
                                            </div>
                                            <div class="brand"><%= product[0] %></div>
                                            <p class="title"><%= product[1] %></p>
                                            <div class="price-wrap">
                                                <span class="discount"><%= product[2] %>%</span>
                                                <span class="price"><%= product[3] %></span>
                                            </div>
                                            <div class="review-wrap">
                                                <span class="star">★</span>
                                                <span><%= product[4] %></span>
                                                <span class="review-count"><%= product[5] %></span>
                                            </div>
                                        </a>
                                    </article>
                                <% } %>
                            </div>
                            <button type="button" class="room-products-prev" aria-label="이전 상품 목록" disabled></button>
                            <button type="button" class="room-products-next" aria-label="다음 상품 목록"></button>
                        </div>
                    </article>
            <%
                    previousRoom = roomName;
                }
            %>
        </section>

        <nav class="delivery-tabs" aria-label="원하는날도착 기획전 메뉴">
            <button type="button" class="delivery-tab" data-target="#couponSection">3종 쿠폰</button>
            <button type="button" class="delivery-tab" data-target="#newSection">신상 추천</button>
            <button type="button" class="delivery-tab" data-target="#spaceSection">공간별가구</button>
            <button type="button" class="delivery-tab active" data-target="#premiumSection">프리미엄</button>
        </nav>

        <section class="premium-section" id="premiumSection">
            <div class="premium-heading">
                <h2>국내외<br>프리미엄 브랜드</h2>
                <p>프리미엄 가구도 빠르게! 원하는날도착</p>
            </div>

            <div class="room-carousel premium-carousel" data-slide-index="0">
                <div class="room-hero-viewport">
                    <% for (int brandIndex = 0; brandIndex < premiumTopBrands.length; brandIndex++) {
                        String[] brand = premiumTopBrands[brandIndex];
                    %>
                        <a href="#" class="room-hero-slide <%= brandIndex == 0 ? "active" : "" %>" aria-label="<%= brand[0] %> <%= brand[2] %>">
                            <img src="<%= brand[3] %>" alt="<%= brand[0] %> 대표 상품" loading="lazy">
                            <div class="room-hero-copy">
                                <div class="room-hero-brand"><%= brand[0] %> (<%= brand[1] %>)</div>
                                <div class="room-hero-name"><%= brand[2] %></div>
                            </div>
                        </a>
                    <% } %>

                    <button type="button" class="room-hero-prev" aria-label="이전 프리미엄 브랜드" disabled></button>
                    <button type="button" class="room-hero-next" aria-label="다음 프리미엄 브랜드"></button>
                </div>

                <div class="room-hero-dots" aria-label="프리미엄 브랜드 위치">
                    <% for (int brandIndex = 0; brandIndex < premiumTopBrands.length; brandIndex++) { %>
                        <button type="button" class="room-hero-dot <%= brandIndex == 0 ? "active" : "" %>" data-slide="<%= brandIndex %>" aria-label="<%= brandIndex + 1 %>번째 프리미엄 브랜드"></button>
                    <% } %>
                </div>
            </div>

            <div class="premium-product-grid">
                <% for (String[] product : premiumProducts) { %>
                    <article class="delivery-product-card">
                        <a href="#" aria-label="<%= product[1] %>">
                            <div class="product-img-wrap">
                                <img src="<%= product[6] %>" alt="<%= product[1] %>" loading="lazy">
                            </div>
                            <div class="brand"><%= product[0] %></div>
                            <p class="title"><%= product[1] %></p>
                            <div class="price-wrap">
                                <span class="discount"><%= product[2] %>%</span>
                                <span class="price"><%= product[3] %></span>
                            </div>
                            <div class="review-wrap">
                                <span class="star">★</span>
                                <span><%= product[4] %></span>
                                <span class="review-count"><%= product[5] %></span>
                            </div>
                        </a>
                    </article>
                <% } %>
            </div>

            <section class="premium-curation">
                <div class="premium-curation-heading">
                    <h2>브랜드 큐레이션</h2>
                    <p>추천하는 프리미엄 브랜드 둘러보기</p>
                </div>

                <div class="premium-brand-grid">
                    <% for (String[] brand : premiumCurationBrands) { %>
                        <a href="#" class="premium-brand-card" aria-label="<%= brand[0] %> 브랜드 보기">
                            <img src="<%= brand[2] %>" alt="<%= brand[0] %>" loading="lazy">
                            <div class="premium-brand-name">
                                <strong><%= brand[0] %></strong>
                                <span><%= brand[1] %></span>
                            </div>
                        </a>
                    <% } %>
                </div>

                <a class="premium-clearance-link"
                   href="${pageContext.request.contextPath}/search.htm?keyword=%5B%ED%81%B4%EB%A6%AC%EC%96%B4%EB%9F%B0%EC%8A%A4%5D&amp;categoryId=10000000&amp;desiredDelivery=true">
                    <span class="premium-clearance-copy">
                        <strong>오늘의집배송 클리어런스</strong>
                        <span>할인 상품 보러가기 &gt;</span>
                    </span>
                    <span class="premium-clearance-icon" aria-hidden="true">🚚</span>
                </a>
            </section>
        </section>

        <section class="all-products" id="allProducts">
            <nav class="all-products-nav" aria-label="원하는날도착 상품 공간 필터">
                <button type="button" class="all-products-filter active" data-room="전체">전체</button>
                <button type="button" class="all-products-filter" data-room="거실">거실</button>
                <button type="button" class="all-products-filter" data-room="침실">침실</button>
                <button type="button" class="all-products-filter" data-room="주방">주방</button>
                <button type="button" class="all-products-filter" data-room="드레스룸">드레스룸</button>
                <button type="button" class="all-products-filter" data-room="서재">서재</button>
                <button type="button" class="all-products-filter" data-room="파우더룸">파우더룸</button>
            </nav>

            <div class="all-product-group-list">
                <% for (String[] productGroup : allProductGroups) {
                    String groupRoom = productGroup[0];
                    String productType = productGroup[1];
                    String[] productIndexes = productGroup[2].split(",");
                %>
                    <section class="all-product-group" data-room="<%= groupRoom %>">
                        <div class="all-product-type"><%= productType %></div>

                        <div class="all-product-grid">
                            <% for (String productIndex : productIndexes) {
                                String[] product = newProducts[Integer.parseInt(productIndex)];
                            %>
                                <article class="delivery-product-card">
                                    <a href="#" aria-label="<%= product[1] %>">
                                        <div class="product-img-wrap">
                                            <img src="<%= product[6] %>" alt="<%= product[1] %>" loading="lazy">
                                        </div>
                                        <div class="brand"><%= product[0] %></div>
                                        <p class="title"><%= product[1] %></p>
                                        <div class="price-wrap">
                                            <span class="discount"><%= product[2] %>%</span>
                                            <span class="price"><%= product[3] %></span>
                                        </div>
                                        <div class="review-wrap">
                                            <span class="star">★</span>
                                            <span><%= product[4] %></span>
                                            <span class="review-count"><%= product[5] %></span>
                                        </div>
                                    </a>
                                </article>
                            <% } %>
                        </div>
                    </section>
                <% } %>
            </div>

            <div class="all-products-empty">해당 공간의 상품이 없습니다.</div>
        </section>
    </main>

    <aside class="delivery-side">
        <div class="side-eyebrow">오늘의집 공식 가구 배송/설치 서비스</div>
        <h2>가구 배송도 가볍게, 원하는날도착</h2>

        <div class="side-actions">
            <button type="button" class="side-action">♡ 965</button>
            <button type="button" class="side-action">⌯ 공유하기</button>
        </div>

        <button type="button" class="view-products-btn">판매상품 목록보기</button>
    </aside>
</div>

<button type="button" class="top-btn" aria-label="맨 위로 이동">↑</button>

<script>
$(function () {
    const $window = $(window);
    const $topButton = $(".top-btn");

    function scrollToSection(selector) {
        const $target = $(selector);
        if (!$target.length) return;

        $("html, body").stop().animate({
            scrollTop: $target.offset().top - 88
        }, 450);
    }

    $(".delivery-tab").on("click", function () {
        scrollToSection($(this).attr("data-target"));
    });

    $(".view-products-btn").on("click", function () {
        scrollToSection("#allProducts");
    });

    $(".room-selector-btn").on("click", function () {
        const roomName = $(this).attr("data-room-name");
        const $target = $(".room-group").filter(function () {
            return $(this).attr("data-room") === roomName;
        }).first();

        if ($target.length) {
            $("html, body").stop().animate({
                scrollTop: $target.prevAll(".room-selector").first().offset().top - 88
            }, 450);
        }
    });

    $(".all-products-filter").on("click", function () {
        const selectedRoom = $(this).attr("data-room");
        let visibleCount = 0;

        $(".all-products-filter").removeClass("active");
        $(this).addClass("active");

        $(".all-product-group").each(function () {
            const matched = selectedRoom === "전체" || $(this).attr("data-room") === selectedRoom;
            $(this).prop("hidden", !matched);
            if (matched) visibleCount++;
        });

        $(".all-products-empty").toggle(visibleCount === 0);
    });

    $(".category-id-pending").on("click", function (event) {
        event.preventDefault();
    });

    function showRoomHero($carousel, nextIndex) {
        const $slides = $carousel.find(".room-hero-slide");
        const $dots = $carousel.find(".room-hero-dot");
        const slideCount = $slides.length;
        const safeIndex = (nextIndex + slideCount) % slideCount;

        $carousel.attr("data-slide-index", safeIndex);
        $slides.removeClass("active").eq(safeIndex).addClass("active");
        $dots.removeClass("active").eq(safeIndex).addClass("active");
        $carousel.find(".room-hero-prev").prop("disabled", safeIndex === 0);
        $carousel.find(".room-hero-next").prop("disabled", safeIndex === slideCount - 1);
    }

    $(".room-hero-prev").on("click", function () {
        const $carousel = $(this).closest(".room-carousel");
        const currentIndex = Number($carousel.attr("data-slide-index")) || 0;
        showRoomHero($carousel, currentIndex - 1);
    });

    $(".room-hero-next").on("click", function () {
        const $carousel = $(this).closest(".room-carousel");
        const currentIndex = Number($carousel.attr("data-slide-index")) || 0;
        showRoomHero($carousel, currentIndex + 1);
    });

    $(".room-hero-dot").on("click", function () {
        showRoomHero($(this).closest(".room-carousel"), Number($(this).attr("data-slide")));
    });

    $(".room-products-next, .room-products-prev").on("click", function () {
        const $button = $(this);
        const $wrap = $button.closest(".room-products-wrap");
        const scroller = $wrap.find(".room-product-scroller").get(0);
        if (!scroller) return;

        const showSecondPage = $button.hasClass("room-products-next");
        scroller.scrollTo({
            left: showSecondPage ? scroller.scrollWidth - scroller.clientWidth : 0,
            behavior: "smooth"
        });

        $wrap.find(".room-products-prev").prop("disabled", !showSecondPage);
        $wrap.find(".room-products-next").prop("disabled", showSecondPage);
    });

    $(".room-hero-slide, .room-product-scroller a, .premium-product-grid a, .premium-brand-card, .all-product-grid a").on("click", function (event) {
        if ($(this).attr("href") === "#") event.preventDefault();
    });

    $(".coupon-download").on("click", function () {
        const $button = $(this);
        if ($button.hasClass("received")) return;

        $button.addClass("received").attr("aria-label", "쿠폰 받기 완료");
        $button.find(".download-icon").text("✓");
    });

    $topButton.on("click", function () {
        $("html, body").stop().animate({ scrollTop: 0 }, 450);
    });

    $window.on("scroll", function () {
        $topButton.toggle($window.scrollTop() > 450);
    });
});
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
