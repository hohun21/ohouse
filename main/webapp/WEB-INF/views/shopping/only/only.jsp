<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%
    /*
     * 오늘의집 Only 화면 브랜드 하드 코딩
     */
    String[][] editions = {
        {"오늘의집 비온 에디션", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-529331947487296.png", "https://store.ohou.se/exhibitions/19296"},
        {"오늘의집 레이레이 에디션", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-529332015869952.png", "https://store.ohou.se/exhibitions/17225"},
        {"오늘의집 언커먼하우스 에디션", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-529332140400768.png", "https://store.ohou.se/exhibitions/17622"},
        {"오늘의집 제니퍼룸 에디션", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-516579461410944.png", "https://store.ohou.se/exhibitions/16744"},
        {"오늘의집 OLLY 에디션", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-509156250869888.png", "https://store.ohou.se/exhibitions/17621"}
    };

    String[][] brands = {
        {"무표", "MUPYO", "합리적인 가격의 미학, 본질에 집중한 브랜드", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-526491066241152.png"},
        {"스페이스테일러", "SPACE TAILOR", "쉽게 떼고 부착하는 프리미엄 패브릭 벽지", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-526493303857216.png"},
        {"토노브", "TONOVE", "섬세한 변주로 일상의 감각을 새롭게", "https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-526493773180992.png"}
    };

    /* 브랜드별 단독 상품 4개: 브랜드, 상품명, 할인율, 가격, 평점, 리뷰, 이미지 */
    String[][][] brandProducts = {
        {
            {"무표", "[오늘의집 단독] 국내생산 수건 그대로의 컬러 프리미엄 40수 타올", "42", "29,900", "4.9", "리뷰 2,104", "https://images.unsplash.com/photo-1620626011761-996317b8d101?auto=format&fit=crop&w=600&q=85"},
            {"무표", "[오늘의집 단독] 28cm 프라이팬+궁중팬 2종 세트", "37", "39,900", "4.8", "리뷰 734", "https://images.unsplash.com/photo-1584990347449-a7c49e6a7d5f?auto=format&fit=crop&w=600&q=85"},
            {"무표", "[오늘의집 단독] 국내생산 올 스테인리스 식기건조대", "31", "45,900", "4.9", "리뷰 516", "https://images.unsplash.com/photo-1556911220-bff31c812dba?auto=format&fit=crop&w=600&q=85"},
            {"무표", "[오늘의집 단독] All White 초음파 가습기 4L", "35", "49,900", "4.8", "리뷰 823", "https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=600&q=85"}
        },
        {
            {"스페이스테일러", "[오늘의집 단독] 떼기 쉬운 패브릭 벽지 포스터 에디션", "25", "58,000", "4.9", "리뷰 26", "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?auto=format&fit=crop&w=600&q=85"},
            {"스페이스테일러", "[오늘의집 단독] 떼어지는 유럽 감성 패브릭 벽지", "32", "42,900", "4.8", "리뷰 118", "https://images.unsplash.com/photo-1615529162924-f8605388461d?auto=format&fit=crop&w=600&q=85"},
            {"스페이스테일러", "[오늘의집 단독] 체크 패브릭 포인트 벽지", "28", "39,900", "4.9", "리뷰 84", "https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=600&q=85"},
            {"스페이스테일러", "[오늘의집 단독] 리무버블 패브릭 포스터 모음", "24", "35,900", "4.8", "리뷰 67", "https://images.unsplash.com/photo-1549490349-8643362247b5?auto=format&fit=crop&w=600&q=85"}
        },
        {
            {"토노브", "[오늘의집 단독] 장우산 우양산 UV 99.9 차단 5colors", "34", "26,900", "4.8", "리뷰 194", "https://images.unsplash.com/photo-1534274988757-a28bf1a57c17?auto=format&fit=crop&w=600&q=85"},
            {"토노브", "[오늘의집 단독] 여름 모달 냉감이불 스트라이프 시리즈", "38", "59,900", "4.9", "리뷰 312", "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=600&q=85"},
            {"토노브", "[오늘의집 단독] 익숙하지만 확실한 포인트 커튼 시리즈", "33", "49,900", "4.9", "리뷰 402", "https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=600&q=85"},
            {"토노브", "[오늘의집 단독] 플라워 모달 차렵이불 세트", "29", "69,900", "4.8", "리뷰 276", "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=600&q=85"}
        }
    };

%>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<style>
    .only-page, .only-page * { box-sizing: border-box; }
    .only-page button { font: inherit; }
    .only-page {
        --only-fixed-header-height: 80px;
        width: 1136px;
        margin: 0 auto;
        padding: 0 15px 100px;
        display: grid;
        grid-template-columns: minmax(0, 760px) 306px;
        gap: 40px;
        align-items: start;
        color: #2F3438;
        font-family: Pretendard, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }
    .only-content { min-width: 0; background: #fff; }

    .only-cover {
        overflow: hidden;
        background: #eef2f4;
    }
    .only-cover img {
        display: block;
        width: 100%;
        height: auto;
    }

    .only-tabs {
        position: relative;
        top: auto;
        z-index: 30;
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        height: 72px;
        background: #000;
    }
    .only-tab {
        position: relative;
        border: 0;
        color: #6d6d6d;
        background: #000;
        font-size: 18px;
        line-height: 72px;
        font-weight: 800;
        text-align: center;
        cursor: pointer;
    }
    .only-tab:hover { color: #cfcfcf; }
    .only-tab.active { color: #fff; }
    .only-tab.active::after {
        content: "";
        position: absolute;
        right: 0;
        bottom: 0;
        left: 0;
        height: 4px;
        background: #fff;
    }

    .only-hero {
        min-height: 285px;
        padding: 78px 20px 52px;
        text-align: center;
        background: #fff;
    }
    .only-logo-line { display: flex; justify-content: center; align-items: center; gap: 10px; }
    .only-logo-line strong { color: #111; font-size: 44px; line-height: 1; font-weight: 800; letter-spacing: -2px; }
    .edition-mark {
        display: inline-block;
        padding: 7px 18px 9px;
        color: #fff;
        background: #111;
        font-family: Georgia, serif;
        font-size: 42px;
        line-height: 1;
        font-style: italic;
    }
    .only-hero p { margin: 28px 0 0; color: #2f3438; font-size: 22px; font-weight: 500; letter-spacing: -1px; }

    .main-edition {
        padding: 0 22px 40px;
        background: #fff;
    }
    .main-edition img {
        display: block;
        width: 100%;
        height: auto;
    }

    .other-edition-title {
        margin: 0;
        padding: 34px 22px 42px;
        color: #111;
        font-size: 34px;
        line-height: 1.25;
        font-weight: 900;
        letter-spacing: -1.4px;
    }

    .section-heading { padding: 72px 10px 46px; text-align: center; }
    .section-heading small { display: block; margin-bottom: 8px; color: #656e75; font-size: 15px; font-weight: 500; }
    .section-heading h2 { margin: 0; color: #111; font-size: 40px; line-height: 1.2; font-weight: 900; letter-spacing: -1.8px; }
    .section-heading p { margin: 14px 0 0; color: #5d6267; font-size: 18px; letter-spacing: -0.6px; }

    .edition-stage { position: relative; padding: 0 22px; }
    .edition-card { display: none; position: relative; overflow: hidden; border-radius: 16px; background: #eee; }
    .edition-card.active { display: block; }
    .edition-card img { display: block; width: 100%; aspect-ratio: 2 / 1; object-fit: cover; }
    .edition-card::after { content: ""; position: absolute; inset: 45% 0 0; background: linear-gradient(transparent, rgba(0,0,0,.55)); pointer-events: none; }
    .edition-name { position: absolute; z-index: 2; left: 28px; bottom: 25px; color: #fff; font-size: 22px; font-weight: 700; letter-spacing: -.6px; }
    .round-arrow {
        position: absolute;
        z-index: 5;
        top: 50%;
        width: 44px;
        height: 44px;
        border: 1px solid #EAEDEF;
        border-radius: 50%;
        color: #2F3438;
        background: #fff;
        box-shadow: 0 2px 8px rgba(0,0,0,.12);
        transform: translateY(-50%);
        cursor: pointer;
    }
    .round-arrow.prev { left: 0; }
    .round-arrow.next { right: 0; }
    .round-arrow:disabled { visibility: hidden; }
    .round-arrow::before { content: ""; display: block; width: 10px; height: 10px; margin: auto; border-top: 2px solid currentColor; border-right: 2px solid currentColor; }
    .round-arrow.prev::before { transform: rotate(-135deg); margin-left: 18px; }
    .round-arrow.next::before { transform: rotate(45deg); margin-left: 14px; }
    .edition-dots { display: flex; justify-content: center; gap: 6px; padding: 16px 0 0; }
    .edition-dot { width: 7px; height: 7px; padding: 0; border: 0; border-radius: 50%; background: #d4d7d9; }
    .edition-dot.active { background: #2F3438; }

    .archive-links { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; padding: 52px 22px 80px; }
    .archive-link { min-height: 120px; padding: 28px; border: 1px solid #DADDE0; border-radius: 14px; color: #2F3438; background: #fff; text-decoration: none; }
    .archive-link:first-child { color: #fff; background: #151515; border-color: #151515; }
    .archive-link strong { display: block; margin-bottom: 9px; font-size: 19px; }
    .archive-link span { color: inherit; font-size: 14px; opacity: .75; }

    .brand-section { padding-bottom: 92px; scroll-margin-top: 72px; border-top: 10px solid #F7F9FA; }
    .brand-list { padding: 0 22px; }
    .brand-block { margin-bottom: 78px; }
    .brand-block:last-child { margin-bottom: 0; }
    .brand-card { position: relative; overflow: hidden; display: block; border-radius: 14px; color: #fff; text-decoration: none; background: #ddd; }
    .brand-card img { display: block; width: 100%; aspect-ratio: 2.25 / 1; object-fit: cover; transition: transform .25s ease; }
    .brand-card:hover img { transform: scale(1.025); }
    .brand-card::after { content: ""; position: absolute; inset: 40% 0 0; background: linear-gradient(transparent, rgba(0,0,0,.7)); }
    .brand-copy { position: absolute; z-index: 2; right: 24px; bottom: 22px; left: 24px; }
    .brand-copy strong { display: block; font-size: 21px; line-height: 1.2; }
    .brand-copy span { display: block; margin-top: 5px; font-size: 15px; }
    .brand-products-grid {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 0 12px;
        margin-top: 20px;
    }
    .brand-products-grid .product-name { min-height: 36px; font-size: 13px; line-height: 18px; }
    .brand-products-grid .price { font-size: 16px; }

    .new-section { padding-bottom: 80px; scroll-margin-top: 72px; border-top: 10px solid #F7F9FA; }
    .product-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 44px 16px; padding: 0 2px; }
    .product-card { min-width: 0; }
    .product-image { position: relative; overflow: hidden; margin-bottom: 10px; border-radius: 4px; background: #f5f5f5; }
    .product-image img { display: block; width: 100%; aspect-ratio: 1 / 1; object-fit: cover; transition: transform .25s ease; }
    .product-card:hover .product-image img { transform: scale(1.04); }
    .only-badge { position: absolute; top: 8px; left: 8px; padding: 5px 10px; color: #fff; background: #202326; border-radius: 3px; font-size: 12px; font-weight: 700; }
    .brand-name { margin: 0 0 4px; overflow: hidden; color: #828C94; font-size: 12px; white-space: nowrap; text-overflow: ellipsis; }
    .product-name { min-height: 36px; margin: 0 0 5px; overflow: hidden; color: #2F3438; font-size: 14px; line-height: 18px; font-weight: 400; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
    .price { margin: 5px 0; color: #000; font-size: 17px; line-height: 22px; font-weight: 800; }
    .discount { margin-right: 4px; color: #35C5F0; }
    .rating { color: #828C94; font-size: 12px; }
    .rating b { margin-right: 3px; color: #2F3438; }
    .star { color: #35C5F0; }

    .all-products-filter {
        margin-top: 70px;
        padding: 16px 0 22px;
        border-top: 1px solid #EAEDEF;
    }
    .all-category-btn {
        height: 40px;
        padding: 0 17px;
        border: 1px solid #111;
        border-radius: 20px;
        color: #fff;
        background: #111;
        font-size: 14px;
        font-weight: 700;
        cursor: default;
    }
    .all-products-section { padding-top: 24px; scroll-margin-top: var(--only-fixed-header-height); }
    .all-product-group { margin-bottom: 78px; }
    .all-product-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 48px 16px; }

    .only-side {
        position: -webkit-sticky;
        position: sticky;
        /* 서브 헤더가 닫혀 있을 때: 메인 헤더 80px + 간격 20px */
        top: calc(var(--only-fixed-header-height) + 20px);
		transform: translateY(0);
		transition: transform 0.2s ease;
        align-self: start;
        height: fit-content;
        padding: 23px 4px 0;
        background: #fff;
    }
	/* 서브 헤더가 열리면 왼쪽 본문은 유지하고 오른쪽 메뉴만 52px 아래로 이동한다. */
	.sticky-header.sub-open ~ .only-page .only-side,
	.sticky-header.sub-visible ~ .only-page .only-side {
		transform: translateY(52px);
	}
    .side-title {
        margin: 0 0 18px;
        color: #2F3438;
        font-size: 17px;
        line-height: 24px;
        font-weight: 700;
        letter-spacing: -0.4px;
    }
    .side-actions {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 8px;
    }
    .side-actions button {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 7px;
        height: 48px;
        padding: 0 10px;
        border: 1px solid #DADDE0;
        border-radius: 5px;
        color: #2F3438;
        background: #fff;
        font-size: 15px;
        line-height: 20px;
        font-weight: 500;
        cursor: pointer;
    }
    .side-actions button:hover { background: #F7F9FA; }
    .side-actions svg { width: 17px; height: 17px; flex: none; stroke: currentColor; }
    .view-products {
        width: 100%;
        height: 48px;
        margin-top: 16px;
        border: 0;
        border-radius: 5px;
        color: #fff;
        background: #35C5F0;
        font-size: 15px;
        line-height: 20px;
        font-weight: 700;
        cursor: pointer;
    }
    .view-products:hover { background: #09ADDB; }

    .to-top { position: fixed; z-index: 60; right: 28px; bottom: 28px; width: 46px; height: 46px; border: 1px solid #EAEDEF; border-radius: 50%; color: #2F3438; background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,.12); font-size: 22px; cursor: pointer; }

    @media (max-width: 1000px) {
        .only-page { width: 100%; grid-template-columns: minmax(0, 1fr); padding: 0; }
        .only-side { display: none; }
        .product-grid { padding: 0 15px; }
    }
    @media (max-width: 640px) {
        .only-tab { font-size: 15px; }
        .only-hero { min-height: 220px; padding-top: 60px; }
        .only-logo-line strong { font-size: 31px; }
        .edition-mark { font-size: 29px; }
        .only-hero p { font-size: 17px; }
        .section-heading h2 { font-size: 31px; }
        .product-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        .all-product-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
        .brand-products-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 36px 12px; }
        .archive-links { grid-template-columns: 1fr; }
    }
</style>

<main class="only-page" id="onlyTop">
    <div class="only-content">
        <div class="only-cover">
            <img src="https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-494238398226560.png" alt="오직 오늘의집에서 만나는 Only">
        </div>

        <nav class="only-tabs" aria-label="오늘의집 Only 섹션">
            <button type="button" class="only-tab active" data-target="editionSection">EDITION</button>
            <button type="button" class="only-tab" data-target="brandSection">BRAND</button>
            <button type="button" class="only-tab" data-target="newItemSection">NEW ITEM</button>
        </nav>

        <section id="editionSection">
            <header class="only-hero">
                <div class="only-logo-line"><strong>Ohouse</strong><span class="edition-mark">edition</span></div>
                <p>브랜드의 감성을 담은 오늘의집 에디션</p>
            </header>

            <!-- 현재 메인 에디션: 대표 이미지와 다이드인 상품 4개가 포함된 실제 기획전 영역 -->
            <div class="main-edition">
                <img src="https://prs.ohouse.com/apne2/any/uploads/exhibitions/contents/v1-535646220370048.png"
                     alt="오늘의집 다이드인 에디션과 다이드인 상품 4개">
            </div>

            <h3 class="other-edition-title">다른 에디션 만나보기</h3>
            <div class="edition-stage">
                <% for (int i = 0; i < editions.length; i++) { %>
                    <a class="edition-card <%= i == 0 ? "active" : "" %>" href="<%= editions[i][2] %>" data-edition-index="<%= i %>">
                        <img src="<%= editions[i][1] %>" alt="<%= editions[i][0] %>">
                        <span class="edition-name"><%= editions[i][0] %> &gt;</span>
                    </a>
                <% } %>
                <button type="button" class="round-arrow prev" id="editionPrev" aria-label="이전 에디션"></button>
                <button type="button" class="round-arrow next" id="editionNext" aria-label="다음 에디션"></button>
                <div class="edition-dots">
                    <% for (int i = 0; i < editions.length; i++) { %>
                        <button type="button" class="edition-dot <%= i == 0 ? "active" : "" %>" data-index="<%= i %>" aria-label="<%= i + 1 %>번 에디션"></button>
                    <% } %>
                </div>
            </div>

            <div class="archive-links">
                <a class="archive-link" href="https://store.ohou.se/exhibitions/13578"><strong>EDITION ARCHIVE</strong><span>에디션 전체보기 &gt;</span></a>
                <a class="archive-link" href="https://www.instagram.com/onlyinohouse/"><strong>오늘의집 Only 인스타그램</strong><span>팔로우 하러가기 &gt;</span></a>
            </div>
        </section>

        <section class="brand-section" id="brandSection">
            <header class="section-heading">
                <small>BRAND</small>
                <h2>오늘의집에서만<br>만날 수 있는 상품들</h2>
            </header>
            <div class="brand-list">
                <% for (int i = 0; i < brands.length; i++) { %>
                    <div class="brand-block">
                        <a href="#newItemSection" class="brand-card">
                            <img src="<%= brands[i][3] %>" alt="<%= brands[i][0] %>">
                            <span class="brand-copy"><strong><%= brands[i][1] %></strong><span><%= brands[i][2] %> &gt;</span></span>
                        </a>

                        <div class="brand-products-grid">
                            <% for (int j = 0; j < brandProducts[i].length; j++) {
                                String[] p = brandProducts[i][j];
                            %>
                                <article class="product-card">
                                    <div class="product-image">
                                        <img src="<%= p[6] %>" alt="<%= p[1] %>">
                                        <span class="only-badge">Only</span>
                                    </div>
                                    <p class="brand-name"><%= p[0] %></p>
                                    <p class="product-name"><%= p[1] %></p>
                                    <div class="price"><span class="discount"><%= p[2] %>%</span><%= p[3] %></div>
                                    <div class="rating"><span class="star">★</span> <b><%= p[4] %></b><%= p[5] %></div>
                                </article>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>

        <section class="new-section" id="newItemSection">
            <header class="section-heading">
                <small>NEW ITEM</small>
                <h2>오늘의집 단독 신상품</h2>
                <p>오직 오늘의집에서 먼저 만나는 새로운 상품</p>
            </header>
			<div class="product-grid" id="onlyProductGrid">
			    <c:forEach var="product" items="${ products }" begin="0" end="8">
			      <article class="product-card">
			        <div class="product-image">
                      <img src="${ product.imageUrl }" alt="${ product.productName }">
                      <span class="only-badge">Only</span>
                    </div>
			        <div class="brand-name">${ product.brandName }</div>
			        <p class="product-name">${ product.productName }</p>
			        <div class="price"><span class="discount">${ product.discountRate }%</span><fmt:formatNumber value="${ product.price }" pattern="#,###"/>원</div>
			        <div class="rating"><span class="star">★</span><b>${ product.reviewScore }</b>${ product.reviewCount }</div>
			      </article>
			    </c:forEach>
			</div>

			<div class="all-products-filter" aria-label="상품 카테고리">
			    <button type="button" class="all-category-btn" aria-current="true">전체</button>
			</div>

            <div class="all-products-section" id="allProductsSection">
                <div id="allProductGroups">
                        <section class="all-product-group">
                            <div class="all-product-grid">
                             <c:forEach var="product" items="${ products }" begin="9">
                                    <article class="product-card">
                                        <div class="product-image">
                                            <img src="${ product.imageUrl }" alt="${ product.productName }">
                                            <span class="only-badge">Only</span>
                                        </div>
                                        <p class="brand-name">${ product.brandName }</p>
                                        <p class="product-name">${ product.productName }</p>
                                        <div class="price"><span class="discount">${ product.discountRate }%</span><fmt:formatNumber value="${ product.price }" pattern="#,###"/>원</div>
                                        <div class="rating"><span class="star">★</span> <b>${ product.reviewScore }</b>${ product.reviewCount }</div>
                                    </article>
                              </c:forEach>
                            </div>
                        </section>
                </div>
            </div>
        </section>
    </div>

    <aside class="only-side" aria-label="오늘의집 Only 메뉴">
        <h2 class="side-title">오늘의집 Only</h2>
        <div class="side-actions">
            <button type="button" aria-label="스크랩 3,095개">
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
                    <path d="M6.75 4.75h10.5v14.5L12 16.1l-5.25 3.15V4.75Z" stroke-width="1.7" stroke-linejoin="round"/>
                </svg>
                <span>3,095</span>
            </button>
            <button type="button">
                <svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
                    <circle cx="18" cy="5" r="2.5" stroke-width="1.7"/>
                    <circle cx="6" cy="12" r="2.5" stroke-width="1.7"/>
                    <circle cx="18" cy="19" r="2.5" stroke-width="1.7"/>
                    <path d="m8.2 10.8 7.6-4.5M8.2 13.2l7.6 4.5" stroke-width="1.7"/>
                </svg>
                <span>공유하기</span>
            </button>
        </div>
        <button type="button" class="view-products" id="viewProducts">판매상품 목록보기</button>
    </aside>
</main>

<button type="button" class="to-top" id="toTop" aria-label="맨 위로 이동">↑</button>

<script>
(function () {
    var tabs = Array.prototype.slice.call(document.querySelectorAll('.only-tab'));
    var sections = tabs.map(function (tab) { return document.getElementById(tab.dataset.target); });

    tabs.forEach(function (tab) {
        tab.addEventListener('click', function () {
            var target = document.getElementById(tab.dataset.target);
            if (target) target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
    });

    var editionCards = Array.prototype.slice.call(document.querySelectorAll('.edition-card'));
    var editionDots = Array.prototype.slice.call(document.querySelectorAll('.edition-dot'));
    var editionPrev = document.getElementById('editionPrev');
    var editionNext = document.getElementById('editionNext');
    var editionIndex = 0;

    function showEdition(index) {
        editionIndex = Math.max(0, Math.min(index, editionCards.length - 1));
        editionCards.forEach(function (card, i) { card.classList.toggle('active', i === editionIndex); });
        editionDots.forEach(function (dot, i) { dot.classList.toggle('active', i === editionIndex); });
        editionPrev.disabled = editionIndex === 0;
        editionNext.disabled = editionIndex === editionCards.length - 1;
    }
    editionPrev.addEventListener('click', function () { showEdition(editionIndex - 1); });
    editionNext.addEventListener('click', function () { showEdition(editionIndex + 1); });
    editionDots.forEach(function (dot) { dot.addEventListener('click', function () { showEdition(Number(dot.dataset.index)); }); });
    showEdition(0);

    var viewProducts = document.getElementById('viewProducts');
    viewProducts.addEventListener('click', function () {
        document.getElementById('allProductsSection').scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
    document.getElementById('toTop').addEventListener('click', function () { window.scrollTo({ top: 0, behavior: 'smooth' }); });

    window.addEventListener('scroll', function () {
        var current = 0;
        sections.forEach(function (section, index) {
            if (section.getBoundingClientRect().top <= 110) current = index;
        });
        tabs.forEach(function (tab, index) { tab.classList.toggle('active', index === current); });
    }, { passive: true });
})();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
