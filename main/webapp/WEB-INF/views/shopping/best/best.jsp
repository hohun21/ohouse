<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>베스트 | 오늘의집 쇼핑</title>
<style>
    * { box-sizing: border-box; }
    html { scroll-behavior: smooth; }
    body { margin: 0; color: #2f3438; background: #fff; font-family: Pretendard, -apple-system, BlinkMacSystemFont, "Segoe UI", "Noto Sans KR", sans-serif; }
    button, input { font: inherit; }
    button { border: 0; background: none; cursor: pointer; }
    a { color: inherit; text-decoration: none; }
    .page { max-width: 1060px; margin: 0 auto; padding: 79px 20px 100px; }
    .rank-tabs { width: 310px; height: 40px; display: flex; margin: 0 auto 69px; border: 1px solid #dadde0; border-radius: 4px; overflow: hidden; }
    .rank-tab { flex: 1; color: #2f3438; background: #fff; font-size: 14px; font-weight: 700; }
    .rank-tab + .rank-tab { border-left: 1px solid #dadde0; }
    .rank-tab.active { color: #fff; background: #0aa5ef; }
    .history-categories { position: sticky; top: var(--ranks-sticky-top, 80px); z-index: 900; display: none; margin: -37px 0 42px; padding: 0; background: #fff; border-bottom: 1px solid #eaedef; box-shadow: 0 1px 0 rgba(0,0,0,.02); }
    .history-categories.show { display: block; }
    .category-scroll { display: flex; align-items: center; gap: 23px; height: 50px; overflow-x: auto; overflow-y: hidden; white-space: nowrap; scrollbar-width: thin; scrollbar-color: #9e9e9e transparent; }
    .category-scroll::-webkit-scrollbar { height: 7px; }
    .category-scroll::-webkit-scrollbar-thumb { background: #9e9e9e; border-radius: 10px; }
    .category-scroll::-webkit-scrollbar-track { background: transparent; }
    .category-button { flex: 0 0 auto; height: 43px; padding: 0; color: #2f3438; font-size: 13px; font-weight: 600; }
    .category-button.active { color: #0aa5ef; font-weight: 800; }
    .product-grid { display: grid; grid-template-columns: repeat(4, minmax(0,1fr)); gap: 31px 20px; }
    .product-card { min-width: 0; }
    .image-wrap { position: relative; overflow: hidden; width: 100%; aspect-ratio: 1/1; border-radius: 2px; background: #f5f5f5; }
    .image-wrap img { width: 100%; height: 100%; display: block; object-fit: cover; transition: transform .25s ease; }
    .product-card:hover img { transform: scale(1.045); }
    .rank { position: absolute; left: 10px; top: 0; width: 25px; height: 29px; padding-bottom: 4px; display: grid; place-items: center; color: #fff; background: #c2c8cc; clip-path: polygon(0 0,100% 0,100% 100%,50% 82%,0 100%); font-size: 13px; line-height: 1; font-weight: 800; }
    .rank.rank-top { background: #35bbed; }
    .rank.rank-normal { background: #c2c8cc; }
    .info { padding: 10px 2px 0 0; }
    .brand { margin-bottom: 2px; color: #828c94; font-size: 11px; line-height: 16px; font-weight: 400; letter-spacing: -.2px; }
    .name { margin: 0; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; color: #2f3438; font-size: 13px; line-height: 18px; font-weight: 400; letter-spacing: -.3px; }
    .product-card:hover .name { color: #828c94; }
    .price { display: flex; align-items: baseline; gap: 3px; margin-top: 0; color: #000; font-size: 18px; line-height: 23px; font-weight: 800; letter-spacing: -.5px; }
    .discount { margin-right: 0; color: #35c5f0; font-size: 20px; font-weight: 800; }
    .rating { margin-top: 0; color: #828c94; font-size: 11px; line-height: 16px; font-weight: 400; letter-spacing: -.2px; }
    .star { margin-right: 2px; color: #35c5f0; font-size: 11px; }
    .score { color: #424242; font-weight: 700; }
    .review-count { margin-left: 2px; color: #828c94; font-weight: 400; }
    .empty { display: none; grid-column: 1/-1; padding: 100px 0; color: #828c94; text-align: center; }
    .product-price { margin: 5px 0; }
    .product-card .price { margin: 5px 0; }
    @media (max-width: 1000px) {
        .product-grid { grid-template-columns: repeat(3, minmax(0,1fr)); }
    }
    @media (max-width: 720px) {
        .page { padding: 74px 16px 70px; }
        .rank-tabs { width: 100%; margin-bottom: 35px; }
        .history-categories { margin-top: -12px; margin-bottom: 28px; }
        .category-scroll { gap: 19px; }
        .rank-tab { font-size: 16px; }
        .product-grid { grid-template-columns: repeat(2, minmax(0,1fr)); gap: 32px 12px; }
        .image-wrap { border-radius: 6px; }
        .rank { left: 8px; width: 25px; height: 29px; font-size: 13px; }
        .info { padding-top: 11px; }
        .name { font-size: 13px; line-height: 18px; }
        .price { font-size: 16px; }
    }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<main class="page">
    <div class="rank-tabs" role="tablist" aria-label="베스트 유형">
        <button class="rank-tab active" data-tab="실시간" role="tab" aria-selected="true">실시간 베스트</button>
    </div>
    <section class="product-grid" id="productGrid" aria-live="polite">
    <c:forEach var="product" items="${ bestProducts }">
      <article class="product-card">
            <a href="#" aria-label="${ product.productName }">
                <div class="image-wrap">
                    <img src="${ product.imageUrl }" alt="${ product.productName }" loading="lazy">
                    <c:choose>
                        <c:when test="${product.rank <= 3}">
                            <span class="rank rank-top">${product.rank}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="rank rank-normal">${product.rank}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="info">
                    <div class="brand">${ product.brandName }</div>
                    <p class="name">${ product.productName }</p>
                    <div class="price"><span class="discount">${ product.discountRate }%</span>${ product.price }</div>
                    <div class="rating">
                        <span class="star">★</span><span class="score">${ product.reviewScore }</span><span class="review-count">${ product.reviewCount }</span>
                    </div>
                </div>
            </a>
        </article>
    </c:forEach>
        
        <c:if test="${empty bestProducts}">
            <p class="empty" style="display:block;">등록된 베스트 상품이 없습니다.</p>
        </c:if>
    </section>
</main>
<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
</body>
</html>

