<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!-- 💡 가격 콤마 표시를 위해 fmt 태그라이브러리 추가 -->
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>오늘의집 - '${keyword}' 검색결과</title>
<!-- 프리텐다드 폰트 적용 -->
<link rel="stylesheet" as="style" crossorigin
    href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Pretendard', sans-serif;
    }
    a { text-decoration: none; color: inherit; display: block; }
    ul { list-style: none; padding: 0; margin: 0; }

    /* 핵심 공통 컨테이너 */
    .container {
        max-width: 1136px;
        margin: 0 auto;
        padding: 0 20px;
        box-sizing: border-box;
       	padding-top : 65px;
    }

    /* --- 검색 페이지 전용 서브 메뉴 (LNB) + 실시간 인기 검색어 바 --- */
    .search-sub-nav-area { border-bottom: 1px solid #EAEDEF; background: #fff; margin-bottom: 30px; }
    .search-sub-nav { 
        max-width: 1136px;
        margin: 0 auto; 
        padding: 0 20px; 
        display: flex; 
        justify-content: space-between; 
        align-items: center; 
        box-sizing: border-box; 
    }
    .sub-nav-list { display: flex; gap: 24px; font-size: 15px; font-weight: 700; color: #424242; }
    .sub-nav-list a { padding: 12px 0; position: relative; transition: color 0.2s; }
    .sub-nav-list a:hover { color: #1496f4; }
    .sub-nav-list a.active { color: #1496f4; }
    .sub-nav-list a.active::after { content: ""; position: absolute; bottom: -1px; left: 0; width: 100%; height: 2px; background-color: #1496f4; }

    /* --- 검색 결과 헤더 --- */
    .search-result-header {
        margin-bottom: 24px;
    }
    .search-title {
        font-size: 22px;
        font-weight: 700;
        color: #2F3438;
    }
    .search-title span {
        color: #1496f4;
    }
    .result-count {
        font-size: 14px;
        color: #757575;
        margin-top: 6px;
        font-weight: 500;
    }

    /* --- 상품 그리드 레이아웃 (4열 구조) --- */
    .grid-4 {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 60px;
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
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .price-area {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 17px;
        font-weight: 700;
    }
    .discount {
        color: #1496f4;
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
        color: #1496f4;
        margin-right: 2px;
    }

    .no-result {
        text-align: center;
        padding: 80px 0;
        color: #828C94;
        font-size: 16px;
        font-weight: 500;
    }
</style>
</head>
<body>

    <!-- 1. 공통 헤더 Include -->
    <jsp:include page="../layout/header.jsp" />

    <!-- 3. 메인 검색 결과 컨텐츠 영역 -->
    <main class="container">
        <div class="search-result-header">
            <h1 class="search-title"><span>'${keyword}'</span> 검색결과</h1>
            <p class="result-count">총 <strong>${productList.size()}</strong>개의 상품</p>
        </div>

        <c:choose>
            <c:when test="${not empty productList}">
                <div class="grid-4">
                    <c:forEach var="product" items="${productList}">
                        <!-- 💡 div를 a 태그로 변경하고 상세 페이지로 넘어가는 href 링크 연결! -->
                        <a href="/productDetail.htm?product_id=${product.productId}" class="product-card">
                            <div class="product-img-wrap">
                                <img src="${product.imageUrl}" alt="${product.productName}">
                                
                                <!-- 💡 품절 뱃지 추가 (status가 SOLD_OUT일 경우 노출) -->
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
    <jsp:include page="../layout/footer.jsp" />

</body>
</html>