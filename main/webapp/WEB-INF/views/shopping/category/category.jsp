<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/category.css" />

<!-- 2단 분할 메인 컨텐츠 시작 -->
<main class="container category-layout">
    
   <!-- 좌측 사이드바 -->
<aside class="sidebar">

    <!-- =========================
         현재 선택된 대분류 영역
         ========================= -->

    <div class="selected-category-area">

        <c:forEach var="main" items="${categories}">

            <!-- 대분류만 -->
            <c:if test="${main.parentId == null}">

                <c:set var="mainOpen" value="false" />

                <!-- 현재 선택된 카테고리가 대분류 자신인지 -->
                <c:if test="${selectedCategoryId == main.category_id}">
                    <c:set var="mainOpen" value="true" />
                </c:if>
                
                <!-- 현재 선택된 카테고리가
                     이 대분류의 중분류인지 확인 -->
                <c:forEach var="middle" items="${categories}">

                    <c:if test="${middle.parentId == main.category_id}">

                        <c:if test="${selectedCategoryId == middle.category_id}">
                            <c:set var="mainOpen" value="true" />
                        </c:if>
                        
                        <!-- 현재 선택된 카테고리가
                             이 대분류의 소분류인지 확인 -->
                        <c:forEach var="sub" items="${categories}">

                            <c:if test="${sub.parentId == middle.category_id}">

                                <c:if test="${selectedCategoryId == sub.category_id}">
                                    <c:set var="mainOpen" value="true" />
                                </c:if>

                            </c:if>

                        </c:forEach>

                    </c:if>

                </c:forEach>


                <!-- 현재 선택된 대분류 -->
                <c:if test="${mainOpen}">

                    <div class="category-panel">

                        <h2 class="sidebar-selected">
                            ${main.category_name}
                        </h2>


                        <div class="sidebar-menu">

                            <!-- 공통 고정 메뉴 -->
                            <div class="sidebar-item">
                                 <a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${main.category_id}&view=only"
							       class="middle-category">
							        오늘의집 Only
							    </a>
                            </div>


                            <!-- =========================
                                 중분류
                                 ========================= -->

                            <c:forEach var="middle" items="${categories}">

                                <c:if test="${middle.parentId == main.category_id}">

                                    <!--
                                        현재 중분류의 자식 존재 여부
                                        = DB에서 소분류가 있는지 확인
                                    -->
                                    <c:set var="hasSub" value="false" />

                                    <c:forEach var="subCheck" items="${categories}">

                                        <c:if test="${subCheck.parentId == middle.category_id}">
                                            <c:set var="hasSub" value="true" />
                                        </c:if>

                                    </c:forEach>


                                    <!-- =========================
                                         DB에 소분류가 있는 중분류
                                         ========================= -->

                                    <c:if test="${hasSub}">

                                        <div class="sidebar-item">

                                            <a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${middle.category_id}"
                                               class="middle-category ${selectedCategoryId == middle.category_id ? 'selected' : ''}">

                                                ${middle.category_name}

                                            </a>

                                            <!-- 소분류가 있으므로 화살표 -->
                                            <span class="sidebar-arrow">∨</span>

                                        </div>


                                        <!-- 소분류 열림 여부 -->
                                        <c:set var="middleOpen" value="false" />

                                        <!-- 중분류 자체가 선택된 경우 -->
                                        <c:if test="${selectedCategoryId == middle.category_id}">
                                            <c:set var="middleOpen" value="true" />
                                        </c:if>


                                        <!-- 소분류가 선택된 경우 -->
                                        <c:forEach var="subCheck" items="${categories}">

                                            <c:if test="${subCheck.parentId == middle.category_id
                                                       && selectedCategoryId == subCheck.category_id}">

                                                <c:set var="middleOpen" value="true" />

                                            </c:if>

                                        </c:forEach>


                                        <!-- 소분류 -->
                                        <div class="sidebar-submenu ${middleOpen ? 'open' : ''}">

                                            <c:forEach var="sub" items="${categories}">

                                                <c:if test="${sub.parentId == middle.category_id}">

                                                    <a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${sub.category_id}"
                                                       class="subcategory ${selectedCategoryId == sub.category_id ? 'selected' : ''}"
                                                       data-category-id="${sub.category_id}">

                                                        ${sub.category_name}

                                                    </a>

                                                    <br>

                                                </c:if>

                                            </c:forEach>

                                        </div>

                                    </c:if>


                                    <!-- =========================
                                         DB에 소분류가 없는 중분류
                                         ========================= -->

                                    <c:if test="${!hasSub}">

                                        <div class="sidebar-item">

                                            <!--
                                                아직 구현하지 않은 메뉴.
                                                링크 없음 / 화살표 없음
                                            -->
                                            <span class="middle-category">
                                                ${middle.category_name}
                                            </span>

                                        </div>

                                    </c:if>

                                </c:if>

                            </c:forEach>


                            <!-- =========================
                                 UI 전용 중분류
                                 ========================= -->

                            <c:if test="${main.category_id == 10000000}">

                                <div class="sidebar-item">
                                    <span class="middle-category">소파</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">서랍/수납장</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">거실장/TV장</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">선반</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">진열장/책장</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">의자</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">행거/옷장</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">거울</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">화장대/콘솔</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">유아동가구</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">야외가구</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">가벽/파티션</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">공간별가구</span>
                                </div>

                            </c:if>


                            <c:if test="${main.category_id == 16000000}">

                                <div class="sidebar-item">
                                    <span class="middle-category">O!PLATING</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">수저/커트러리</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">주방수납/정리</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">식기건조대</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">보관/용기/도시락</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">주방잡화</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">조리도구</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">칼/도마/커팅기구</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">주방패브릭</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">주방일회용품</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">커피/티용품</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">와인/칵테일용품</span>
                                </div>

                            </c:if>


                            <c:if test="${main.category_id == 13000000}">

                                <div class="sidebar-item">
                                    <span class="middle-category">행거</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">선반</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">옷걸이</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">옷정리/이불정리</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">화장대/테이블정리</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">현관/신발정리</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">후크/수납걸이</span>
                                </div>

                                <div class="sidebar-item">
                                    <span class="middle-category">공간별수납정리</span>
                                </div>

                            </c:if>

                        </div>

                    </div>

                </c:if>

            </c:if>

        </c:forEach>

    </div>


    <!-- =========================
         좌측 사이드바 접기 / 열기
         ========================= -->

    <script>

        $(".sidebar-arrow").click(function (e) {

            e.stopPropagation();

            $(this)
                .closest(".sidebar-item")
                .next(".sidebar-submenu")
                .slideToggle();

        });

    </script>


    <!-- =========================
         선택되지 않은 대분류
         ========================= -->

    <div class="sidebar-notselected">

        <!-- DB에서 구현된 대분류 -->
        <c:forEach var="main" items="${categories}">

            <c:if test="${main.parentId == null
                       && selectedCategoryId != main.category_id}">

                <a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${main.category_id}"
                   class="sidebar-other category-enabled">

                    ${main.category_name}

                </a>

            </c:if>

        </c:forEach>


        <!-- =========================
             아직 구현하지 않은 대분류
             ========================= -->

        <div class="sidebar-other">폭염대비</div>
        <div class="sidebar-other">패브릭</div>
        <div class="sidebar-other">가전·디지털</div>
        <div class="sidebar-other">식품</div>
        <div class="sidebar-other">생활용품</div>
        <div class="sidebar-other">생필품</div>
        <div class="sidebar-other">유아.아동</div>
        <div class="sidebar-other">반려동물</div>
        <div class="sidebar-other">캠핑.레저</div>
        <div class="sidebar-other">공구.DIY</div>
        <div class="sidebar-other">인테리어시공</div>
        <div class="sidebar-other">렌탈.구독</div>
        <div class="sidebar-other">장보기</div>

    </div>

</aside>   

<!-- 우측 메인 컨텐츠 -->
<div class="main-content">

    <c:choose>

        <c:when test="${isOnly}">

<div class="only-breadcrumb">

    <a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${mainCategoryId}">
        ${mainCategoryName}
    </a>

    <span>›</span>

    <span>오늘의집 Only</span>

</div>

    <!-- 오늘의집 Only 홍보 배너 -->
    <div class="only-banner">

        <img src="${pageContext.request.contextPath}/images/category-only-banner.png"
             alt="오늘의집 Only">

    </div>

            <div class="banner-header">
                ONLY 상품
            </div>

            <div class="product-grid">

                <c:forEach var="product" items="${onlyProducts}">

    <div class="product-card"
         onclick="location.href='${pageContext.request.contextPath}/product/productDetail.htm?product_id=${product.productId}'">

        <div class="product-img-wrap">
            <img src="${product.imageUrl}"
                 alt="${product.productName}">
        </div>

        <div class="brand">
            ${product.brandName}
        </div>

        <div class="title">
            ${fn:replace(product.productName, '[오늘의집 단독]', '')}
        </div>

        <div class="only-badge">
            ONLY
        </div>

    </div>

</c:forEach>

            </div>

        </c:when>

        <c:otherwise>

            <div class="banner-header">
                MD's Pick
            </div>

            <div class="category-banners">

                <c:forEach var="banner" items="${bannerProducts}">

                    <div class="banner-box">

                        <a href="${pageContext.request.contextPath}/product/productDetail.htm?product_id=${banner.product_id}">

                            <img src="${banner.image_url}"
                                 alt="${banner.product_name}">

                            <div class="banner-product-info">

                                <div class="banner-brand">
                                    ${banner.brand_name}
                                </div>

                                <div class="banner-name">
                                    ${banner.product_name}
                                </div>

                                <div class="banner-price">

                                    <fmt:formatNumber
                                        value="${banner.price}"
                                        pattern="#,###"/>원

                                </div>

                                <div class="banner-review">

                                    ★
                                    <fmt:formatNumber
                                        value="${banner.avgRating}"
                                        pattern="0.0"/>

                                    <span>
                                        리뷰 ${banner.reviewCount}개
                                    </span>

                                </div>

                            </div>

                        </a>

                    </div>

                </c:forEach>

            </div>

            <div class="list-header">

                <span class="list-count">
                    전체 ${products.size()}개
                </span>

                <form method="get"
                      action="${pageContext.request.contextPath}/shopping/category/category.htm">

                    <input type="hidden"
                           name="category_id"
                           value="${selectedCategoryId}">

                    <select class="sort-select"
                            name="sort"
                            onchange="this.form.submit()">

                        <option value="recommend"
                            ${sort == 'recommend' ? 'selected' : ''}>
                            추천순
                        </option>

                        <option value="popular"
                            ${sort == 'popular' ? 'selected' : ''}>
                            인기순
                        </option>

                        <option value="latest"
                            ${sort == 'latest' ? 'selected' : ''}>
                            최신순
                        </option>

                        <option value="lowprice"
                            ${sort == 'lowprice' ? 'selected' : ''}>
                            가격 낮은순
                        </option>

                    </select>

                </form>

            </div>

            <div class="product-grid">

                <c:forEach var="product" items="${products}">

                    <div class="product-card"
                         onclick="location.href='${pageContext.request.contextPath}/product/productDetail.htm?product_id=${product.product_id}'">

                        <div class="product-img-wrap">

                            <img src="${product.image_url}"
                                 alt="${product.product_name}">

                        </div>

                        <div class="brand">
                            ${product.brand_name}
                        </div>

                        <div class="title">
                            ${product.product_name}
                        </div>

                        <div class="price-wrap">

                            <c:if test="${product.discount_rate > 0}">

                                <span class="discount">
                                    <fmt:formatNumber
                                        value="${product.discount_rate}"
                                        pattern="0"/>%
                                </span>

                            </c:if>

                            <span class="price">
                                <fmt:formatNumber
                                    value="${product.price}"
                                    pattern="#,###"/>원
                            </span>

                        </div>

                        <div class="review-wrap">

                            <span class="star">★</span>
                            ${product.avgRating}

                            <span style="color:#9E9E9E; font-weight:400;">
                                리뷰 ${product.reviewCount}개
                            </span>

                        </div>

                    </div>

                </c:forEach>

            </div>

        </c:otherwise>

    </c:choose>

</div>
</main>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />