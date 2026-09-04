<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>오늘의집 - '${keyword}' 검색결과</title>
<link rel="stylesheet" as="style" crossorigin
    href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Pretendard', sans-serif;
    }

    a {
        color: inherit;
        text-decoration: none;
    }

    ul {
        margin: 0;
        padding: 0;
        list-style: none;
    }

    .container {
        max-width: 1136px;
        margin: 0 auto;
        padding: 0 20px;
        box-sizing: border-box;

    }

    /* 검색결과 탭은 메인 헤더 바로 아래에 고정한다. */
    .search-sub-nav-area {
        position: sticky;
        top: 80px;
        z-index: 900;
        width: 100%;
        height: 52px;
        margin-top: 0;
        margin-bottom: 30px;
        background: #fff;
        border-top: 1px solid #eaedef;
        border-bottom: 1px solid #eaedef;
    }

    .search-sub-nav {
        display: flex;
        align-items: center;
        justify-content: space-between;
        width: 100%;
        max-width: 1136px;
        height: 52px;
        margin: 0 auto;
        padding: 0 20px;
    }

    .sub-nav-list {
        display: flex;
        align-items: center;
        gap: 24px;
        height: 52px;
        color: #424242;
        font-size: 15px;
        font-weight: 700;
        white-space: nowrap;
    }

    .sub-nav-list a {
        position: relative;
        display: flex;
        align-items: center;
        height: 52px;
        transition: color 0.2s;
    }

    .sub-nav-list a:hover,
    .sub-nav-list a.active {
        color: #1496f4;
    }

    .sub-nav-list a.active::after {
        content: "";
        position: absolute;
        right: 0;
        bottom: 0;
        left: 0;
        height: 2px;
        background-color: #1496f4;
    }

    .search-popular-keyword {
        flex: 0 0 auto;
        display: flex;
        align-items: center;
        height: 52px;
        padding-left: 24px;
    }

    .search-result-header {
        margin-bottom: 24px;
    }

    .search-title {
        color: #2f3438;
        font-size: 22px;
        font-weight: 700;
    }

    .search-title span {
        color: #1496f4;
    }

    .result-count {
        margin-top: 6px;
        color: #757575;
        font-size: 14px;
        font-weight: 500;
    }

    .grid-4 {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 20px;
        margin-bottom: 60px;
    }

    .product-card {
        display: block;
        min-width: 0;
        cursor: pointer;
    }

    .product-img-wrap {
        position: relative;
        overflow: hidden;
        width: 100%;
        aspect-ratio: 1 / 1;
        margin-bottom: 12px;
        background-color: #f7f9fa;
        border-radius: 8px;
    }

    .product-img-wrap img {
        display: block;
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.2s;
    }

    .product-card:hover .product-img-wrap img {
        transform: scale(1.05);
    }

    /* 💡 추가: 품절 시 hover 확대 방지 및 커서 기본값 변경 */
    .product-card.sold-out {
        cursor: default;
    }
    
    .product-card.sold-out:hover .product-img-wrap img {
        transform: none; 
    }

    .brand-name {
        margin-bottom: 4px;
        color: #757575;
        font-size: 11px;
        font-weight: 600;
    }

    .product-name {
        display: -webkit-box;
        overflow: hidden;
        margin-bottom: 8px;
        color: #2f3438;
        font-size: 13px;
        font-weight: 400;
        line-height: 1.4;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 2;
    }

    .price-area {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 17px;
        font-weight: 700;
    }

    .discount { color: #1496f4; }
    .price { color: #000; }

    .review-area {
        margin-top: 6px;
        color: #757575;
        font-size: 12px;
        font-weight: 700;
    }

    .star {
        margin-right: 2px;
        color: #1496f4;
    }

    .no-result {
        padding: 80px 0;
        color: #828c94;
        font-size: 16px;
        font-weight: 500;
        text-align: center;
    }

    @media (max-width: 900px) {
        .search-popular-keyword { display: none; }
        .sub-nav-list { gap: 18px; overflow-x: auto; }
        .grid-4 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
    }

    @media (max-width: 720px) {
        .grid-4 { grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 20px 12px; }
    }
</style>
</head>
<body>
    <!-- 헤더 인기 검색어를 숨기면 공통 서브 헤더는 hover 전용으로 동작한다. -->
    <jsp:include page="/WEB-INF/views/layout/header.jsp">
        <jsp:param name="showHeaderPopularKeyword" value="false"/>
    </jsp:include>

    <!-- 검색결과 전용 탭 + 인기 검색어 -->
    <div class="search-sub-nav-area">
        <div class="search-sub-nav">
            <nav class="sub-nav-list" aria-label="검색결과 유형">
                <a href="#">통합</a>
                <a href="#" class="active">쇼핑</a>
                <a href="#">이미지</a>
                <a href="#">콘텐츠</a>
                <a href="#">커뮤니티</a>
                <a href="#">시공업체</a>
                <a href="#">유저</a>
            </nav>

            <div class="search-popular-keyword">
                <jsp:include page="/WEB-INF/views/layout/popular_keyword.jsp"/>
            </div>
        </div>
    </div>

    <main class="container">
        <div class="search-result-header">
            <h1 class="search-title"><span>'${keyword}'</span> 검색결과</h1>
            <p class="result-count">총 <strong>${productList.size()}</strong>개의 상품</p>
        </div>

        <c:choose>
            <c:when test="${not empty productList}">
                <div class="grid-4">
                    <c:forEach var="product" items="${productList}">
                        
                        <!-- 💡 수정: 품절 여부에 따라 class와 href 속성을 동적으로 분기 -->
                        <a class="product-card <c:if test="${product.status == 'SOLD_OUT'}">sold-out</c:if>"
                           <c:choose>
                               <c:when test="${product.status == 'SOLD_OUT'}">
                                   href="javascript:void(0);" onclick="alert('품절된 상품입니다.'); return false;"
                               </c:when>
                               <c:otherwise>
                                   href="${pageContext.request.contextPath}/product/productDetail.htm?product_id=${product.productId}"
                               </c:otherwise>
                           </c:choose>
                        >
                            <div class="product-img-wrap">
                                <img src="${product.imageUrl}" alt="${product.productName}">
                                
                                <c:if test="${product.status == 'SOLD_OUT'}">
                                    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; 
                                                background: rgba(0,0,0,0.5); color: white; display: flex; 
                                                justify-content: center; align-items: center; font-size: 18px; font-weight: bold; z-index: 10;">
                                        품절
                                    </div>
                                </c:if>
                            </div>
                            <div class="brand-name">${product.brandName}</div>
                            <div class="product-name">${product.productName}</div>
                            <div class="price-area">
                                <c:if test="${not empty product.discountRate and product.discountRate > 0}">
                                    <span class="discount">${product.discountRate}%</span>
                                </c:if>
                                <span class="price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</span>
                            </div>
                            <div class="review-area">
                                <span class="star">★</span> 4.8 리뷰 1,204
                            </div>
                        </a>
                        
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-result">
                    <p>원하시는 검색 결과를 찾지 못했어요. 다른 검색어를 입력해 보세요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</body>
</html>