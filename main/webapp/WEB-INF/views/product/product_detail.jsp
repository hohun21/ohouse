<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<style>
/* 기본적으로 내용 다 숨기기 */
.tab-content {
    display: none;
    margin-bottom: 80px;
}

/* active 붙은 내용만 보이기 */
.tab-content.active {
    display: block;
}
    html,
    body {
        min-width: 1200px;
    }

    #wrap {
        min-width: 1200px;
    }

    @media (max-width: 900px) {
        .product-main {
            grid-template-columns: 1fr;
        }

        .gallery {
            width: 100%;
        }

        .product-info {
            width: 100%;
        }

        .product-info-detail {
            grid-column: 1;
        }
    }

    .product-main {
        display: grid;
        grid-template-columns: 550px minmax(0, 1fr);
        gap: 60px;
    }

    .product-info-detail {
        grid-column: 1 / -1;
        width: 100%;
    }

    .product-info-detail .tabs {
        width: 100%;
    }

    .product-info-detail .detail-section {
        width: 100%;
        margin: 50px 0 0;
    }

.breadcrumb {
	display: flex;
	gap: 8px;
	margin-bottom: 24px;
	color: #828c94;
	font-size: 13px;
	padding-top: 50px;
}
    .product-detail {
        width: 100%;
        max-width: 1100px;
        min-width: 700px;
        margin: 0 auto;
        padding: 30px 20px 100px;
        box-sizing: border-box;
        color: #2f3438;
        font-family: Arial, sans-serif;
    }

    .product-detail * {
        box-sizing: border-box;
    }

    .breadcrumb span {
        color: #b0b7bd;
    }

    .product-main {
        display: grid;
        grid-template-columns: 550px 1fr;
        gap: 60px;
    }

    .gallery {
        display: flex;
        gap: 12px;
    }

    .thumbs {
        width: 64px;
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .thumb {
        width: 64px;
        height: 64px;
        border: 2px solid transparent;
        border-radius: 5px;
        overflow: hidden;
        cursor: pointer;
    }

    .thumb.active {
        border-color: #35c5f0;
    }

    .thumb img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .main-image {
        width: 474px;
        height: 600px;
        overflow: hidden;
        border-radius: 6px;
        background: #f5f5f5;
    }

    .main-image img {
        max-width: 100%;
        height: auto;
    }

    .main-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .product-info {
        min-width: 0;
    }

    .brand {
        margin-bottom: 10px;
        color: #828c94;
        font-size: 13px;
    }

    .title {
        margin: 0 0 18px;
        font-size: 24px;
        line-height: 1.45;
        font-weight: 500;
        letter-spacing: -0.4px;
    }

    .price-box {
        padding-bottom: 20px;
        border-bottom: 1px solid #eeeeee;
    }

    .discount {
        margin-right: 7px;
        color: #b0b7bd;
        font-size: 14px;
        font-weight: 700;
    }

    .original-price {
        color: #b0b7bd;
        font-size: 14px;
        text-decoration: line-through;
    }

    .price {
        margin-top: 2px;
        font-size: 32px;
        font-weight: 700;
        letter-spacing: -1px;
    }

    .won {
        margin-left: 2px;
        font-size: 18px;
    }

    .info {
        padding: 18px 0;
        border-bottom: 1px solid #eeeeee;
    }

    .info-row {
        display: grid;
        grid-template-columns: 70px 1fr;
        gap: 15px;
        margin-bottom: 10px;
        font-size: 14px;
    }

    .info-row:last-child {
        margin-bottom: 0;
    }

    .info-label {
        color: #828c94;
    }

    .category-list {
        display: flex;
        flex-wrap: wrap;
        gap: 5px;
    }

    .option-area {
        margin-top: 22px;
    }

    .option-select {
        width: 100%;
        height: 50px;
        margin-bottom: 8px;
        padding: 0 15px;
        border: 1px solid #dadde0;
        border-radius: 4px;
        background: #fff;
        color: #424242;
        font-size: 14px;
    }

    .selected-list {
        margin-top: 12px;
    }

    .selected-option {
        padding: 15px;
        margin-bottom: 8px;
        border-radius: 4px;
        background: #f7f9fa;
    }

    .selected-name {
        margin-bottom: 14px;
        font-size: 14px;
        font-weight: 600;
        line-height: 1.5;
    }

    .selected-bottom {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .quantity {
        display: flex;
        height: 32px;
        border: 1px solid #dadde0;
        border-radius: 4px;
        background: #fff;
    }

    .quantity button {
        width: 30px;
        border: 0;
        background: #fff;
        cursor: pointer;
    }

    .quantity span {
        width: 30px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 13px;
    }

    .selected-price {
        font-size: 16px;
        font-weight: 700;
    }

    .remove {
        margin-left: 8px;
        border: 0;
        background: none;
        color: #999;
        cursor: pointer;
    }

    .total {
        display: flex;
        align-items: baseline;
        justify-content: space-between;
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid #eeeeee;
    }

    .total-label {
        font-size: 13px;
        font-weight: 700;
    }

    .total-price {
        color: #35c5f0;
        font-size: 26px;
        font-weight: 700;
    }

    .buttons {
        display: flex;
        gap: 8px;
        margin-top: 12px;
    }

    .buttons button {
        flex: 1;
        height: 55px;
        border-radius: 4px;
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
    }

    .cart {
        border: 1px solid #35c5f0;
        background: #fff;
        color: #35c5f0;
    }

    .buy {
        border: 1px solid #35c5f0;
        background: #35c5f0;
        color: #fff;
    }

    .tabs {
        display: flex;
        height: 60px;
        margin-top: 70px;
        border-top: 1px solid #eeeeee;
        border-bottom: 1px solid #eeeeee;
    }

    .tabs a {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        border-bottom: 3px solid transparent;
        color: #424242;
        text-decoration: none;
        font-size: 14px;
        font-weight: 700;
    }

    .tabs a.active {
        color: #35c5f0;
        border-bottom-color: #35c5f0;
    }

    .body .product-info-detail {
        width: 100%;
    }

    .detail-section {
        width: 760px;
        margin: 50px auto 0;
    }

    .detail-section h2 {
        margin-bottom: 20px;
        font-size: 20px;
    }

    .detail-empty {
        height: 700px;
        background: #fafafa;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #9aa1a7;
    }

    #optionToast {
        display: none;
        position: fixed;
        left: 50%;
        bottom: 30px;
        transform: translateX(-50%);
        padding: 12px 20px;
        background: #333;
        color: white;
        border-radius: 4px;
        font-size: 14px;
        z-index: 9999;
    }
</style>

<div class="product-detail">

    <!-- 카테고리 경로: DB 데이터만 사용 -->
    <div class="breadcrumb">
        <c:forEach var="category" items="${pdto.categoryDTOList}" varStatus="s">
            <button class="link-category" data-category_id="${category.category_id}">
                <span>${category.category_name}</span>
            </button>
            <c:if test="${!s.last}">
                <span>›</span>
            </c:if>
        </c:forEach>
    </div>

    <div class="product-main">

        <!-- 왼쪽 이미지 -->
        <div class="gallery">

            <div class="thumbs">
                <c:forEach var="image" items="${pdto.imageDTOList}" varStatus="s">
                    <div class="thumb ${s.first ? 'active' : ''}"
                         onmouseover="changeImage(this)">
                        <img src="${image.image_url}"
                             alt="${pdto.productDTO.product_name}">
                    </div>
                </c:forEach>
            </div>

            <div class="main-image">
                <c:if test="${not empty pdto.imageDTOList}">
                    <img id="mainProductImage"
                         src="${pdto.imageDTOList[0].image_url}"
                         alt="${pdto.productDTO.product_name}">
                </c:if>
            </div>

        </div>

        <!-- 오른쪽 상품 정보 -->
        <div class="product-info">

            <div class="brand" data-brand-id="${pdto.productDTO.brand_id}" data-brand-name="${pdto.productDTO.brand_name}">
                ${pdto.productDTO.brand_name}
            </div>
            <div class="product-name">
                <h1 class="title">
                    ${pdto.productDTO.product_name}
                </h1>
            </div>

            <div class="price-box">
                <span class="discount">
                    ${pdto.productDTO.discount_rate}%
                </span>

                <span class="original-price">
                   <fmt:formatNumber value="${pdto.productDTO.original_price}" pattern="#,###"/>원
                </span>

                <div>
                    <span class="price">
                        <fmt:formatNumber value="${pdto.productDTO.price}" pattern="#,###"/>원
                    </span>

                </div>
            </div>

            <div class="info">

                <div class="info-row">
                    <div class="info-label">카테고리</div>
                    <div class="category-list">
                        <c:forEach var="category"
                                   items="${pdto.categoryDTOList}">
                            <span>${category.category_name}</span>
                        </c:forEach>
                    </div>
                </div>

                <div class="info-row">
                    <div class="info-label">상품번호</div>
                    <div>${param.product_id}</div>
                </div>

            </div>

            <!-- 옵션 -->
            <div class="option-area">

                <c:set var="lastGroupId" value="-1"/>
                <c:set var="requiredGroupCount" value="0"/>

                <c:forEach var="option"
                           items="${pdto.optionDTOList}">

                    <c:if test="${lastGroupId != option.option_group_id}">

                        <c:set var="lastGroupId"
                               value="${option.option_group_id}"/>

                        <c:if test="${option.required == '1'}">

                            <c:set var="requiredGroupCount"
                                   value="${requiredGroupCount + 1}"/>

                        </c:if>

                        <select class="option-select"
                                data-group_id="${option.option_group_id}"
                                data-group_name="${option.group_name}"
                                data-required="${option.required}"

                                <c:if test="${option.required == '1' && requiredGroupCount > 1}">
                                    disabled
                                </c:if>
                        >

                            <option value=""
                                    selected
                                    disabled>
                                    ${option.group_name}을 선택해주세요
                            </option>

                            <c:forEach var="value"
                                       items="${pdto.optionDTOList}">


								<c:if test="${value.option_group_id == option.option_group_id}">

									<option value="${value.option_value_id}">
										${value.option_name}</option>

								</c:if>

							</c:forEach>

                        </select>

                    </c:if>

                </c:forEach>
                <div id="optionToast"></div>
                <span id="optionWarning">
                         옵션을 선택해주세요
                    </span>

                <div id="selectedList"></div>

                <div class="total">
                    <span>주문금액</span>
                    <span id="totalPrice">0원</span>
                </div>


                <div class="buttons">

                    <button type="button"
                            class="cart">
                        장바구니
                    </button>

                    <button type="button"
                            class="buy">
                        바로구매
                    </button>

                </div>
            </div>
        </div>
        <div class="product-info-detail">
            <div class="tabs">
                <a class="active" href="#detail">상품정보</a>
                <a href="#detail-review">리뷰</a>
                <a href="#qna">문의</a>
                <a href="#delivery">배송/환불</a>
            </div>
<!-- 1. 상품정보 (기본으로 보임: active) -->
    <section id="detail" class="tab-content active">
        <h2>상품정보</h2>
        <div class="detail-empty">상품 상세 정보 내용</div>
    </section>

    <!-- 2. 리뷰 -->
    <section id="detail-review" class="tab-content">
        <jsp:include page="/WEB-INF/views/product/review/reviewList.jsp">
            <jsp:param name="product_id" value="${pdto.productDTO.product_id}" />
            <jsp:param name="member_id" value="${memberId != null ? memberId : 2}" />
        </jsp:include>
    </section>

    <!-- 3. 문의 -->
    <section id="qna" class="tab-content">
        <h2>문의</h2>
    </section>

    <!-- 4. 배송/환불 -->
    <section id="delivery" class="tab-content">
        <h2>배송/환불</h2>
    </section>
        </div>
        

    </div>
</div>
<script src="${pageContext.request.contextPath}/js/productDetail.js"></script>
<jsp:include page="/WEB-INF/views/product/review/reviewFormModal.jsp" >
	<jsp:param name="productId" value="${pdto.productDTO.product_id}" />
</jsp:include>
<jsp:include page="/WEB-INF/views/product/review/reviewEditModal.jsp">
    <jsp:param name="productId" value="${pdto.productDTO.product_id}" />
</jsp:include>

<script>
    $(".link-category").on("click", function (e) {
        const category_id = $(this).data("category_id");
        location.href = `${pageContext.request.contextPath}/category.htm?category_id=\${category_id}`;
    })
</script>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>