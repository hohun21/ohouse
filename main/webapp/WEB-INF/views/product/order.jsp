<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>주문서 | 오늘의집</title>


    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/order.css">
</head>

<body>

<jsp:include page="/WEB-INF/views/layout/header.jsp"></jsp:include>


</div>
<main class="container">

    <h1 class="page-title">주문서</h1>

    <c:set var="productTotal" value="0"/>

    <c:forEach var="item" items="${orderdto}">
        <c:set var="productTotal"
               value="${productTotal + (item.price * item.quantity)}"/>
    </c:forEach>


    <div class="content">

        <!-- ========================= -->
        <!-- 왼쪽 -->
        <!-- ========================= -->
        <div class="left">


            <!-- 주문상품 -->
            <section class="section">

                <h2 class="section-title">주문상품</h2>

                <c:forEach var="item" items="${orderdto}">

                    <div class="product order-item"
                         data-product-id="${item.product_id}"
                         data-product-option-id="${item.product_option_id}"
                         data-price="${item.price}"
                         data-sku="${item.sku}">

                        <div class="product-image">

                            <div class="image-placeholder">
                                <img src="${item.image_url}" alt="${item.product_name}">
                            </div>

                        </div>


                        <div class="product-info">

                            <div class="product-name">
                                    ${item.product_name}
                            </div>

                            <div class="product-option">
                                <c:forEach var="option" items="${item.options}">
                                    ${option.option_group_name}:
                                    ${option.option_value_name}
                                </c:forEach>
                            </div>


                            <!-- 수량 / 옵션 변경 -->
                            <div class="order-option-control">

                                <div class="quantity-control">

                                    <button type="button"
                                            class="quantity-minus">
                                        −
                                    </button>

                                    <span class="quantity-number">
                                            ${item.quantity}
                                    </span>

                                    <button type="button"
                                            class="quantity-plus">
                                        +
                                    </button>

                                </div>


                                <button type="button"
                                        class="option-change-btn">
                                    옵션 변경
                                </button>

                            </div>

                        </div>


                        <!-- 상품 가격 -->
                        <div class="product-price">

                            <span class="item-price">

                                <fmt:formatNumber
                                        value="${item.price * item.quantity}"
                                        pattern="#,###"/>원

                            </span>

                        </div>

                    </div>

                </c:forEach>

            </section>


            <!-- ========================= -->
            <!-- 배송지 -->
            <!-- ========================= -->
            <section class="section">

                <h2 class="section-title">
                    배송지
                </h2>


                <div class="address-box">

                    <div class="address-top">

                        <div>

                            <span class="address-name">
                                류호훈
                            </span>

                            <span class="default-label">
                                기본배송지
                            </span>

                        </div>


                        <button class="change-btn">
                            변경
                        </button>

                    </div>


                    <div class="address">

                        서울특별시 ○○구 ○○로 00<br>
                        ○○아파트 101동 101호<br>
                        010-0000-0000

                    </div>


                    <div class="delivery-row">

                        <label>
                            배송 요청사항
                        </label>

                        <select>

                            <option>
                                배송 요청사항을 선택해주세요.
                            </option>

                            <option>
                                문 앞에 놓아주세요.
                            </option>

                            <option>
                                경비실에 맡겨주세요.
                            </option>

                            <option>
                                배송 전에 연락해주세요.
                            </option>

                            <option>
                                직접 입력
                            </option>

                        </select>

                    </div>

                </div>

            </section>


            <!-- ========================= -->
            <!-- 할인 -->
            <!-- ========================= -->
            <section class="section">

                <h2 class="section-title">
                    할인 및 포인트
                </h2>


                <div class="discount-row">
                    <select id="couponSelect">
                        <option value="" data-type="" data-value="0" data-max="0">
                            쿠폰을 선택해주세요.
                        </option>

                        <c:forEach var="coupon" items="${clist}">
                            <option value="${coupon.coupon_name}"
                                    data-type="${coupon.discount_type}"
                                    data-value="${coupon.discount_value}"
                                    data-max="${coupon.max_discount}"
                                    data-min="${coupon.min_order_price}">
                                    ${coupon.coupon_name}
                            </option>
                        </c:forEach>
                    </select>
                </div>


                <div class="discount-row">

                    <input
                            type="number"
                            placeholder="사용할 포인트">

                    <button class="discount-btn">
                        전액 사용
                    </button>

                </div>


                <div class="point-info">

                    <span>
                        보유 포인트
                    </span>

                    <span>
                        5,000P
                    </span>

                </div>

            </section>


            <!-- ========================= -->
            <!-- 결제수단 -->
            <!-- ========================= -->
            <section class="section">

                <h2 class="section-title">
                    결제수단
                </h2>


                <div class="payment-methods">

                    <button class="payment-method active">
                        신용카드
                    </button>

                    <button class="payment-method">
                        무통장입금
                    </button>

                    <button class="payment-method">
                        네이버페이
                    </button>

                    <button class="payment-method">
                        카카오페이
                    </button>

                    <button class="payment-method">
                        토스페이
                    </button>

                </div>

            </section>

        </div>


        <!-- ========================= -->
        <!-- 오른쪽 결제금액 -->
        <!-- ========================= -->
        <aside>

            <div class="summary-row">
                <span>상품금액</span>
                <span id="productTotal">0원</span>
            </div>

            <div class="summary-row">
                <span>배송비</span>
                <span id="deliveryFee">3,000원</span>
            </div>

            <div class="summary-row discount">
                <span>쿠폰 할인</span>
                <span id="couponDiscount">-3,000원</span>
            </div>

            <div class="summary-row discount">
                <span>포인트 사용</span>
                <span id="pointDiscount">-0원</span>
            </div>

            <div class="summary-total">
                <span>최종 결제금액</span>

                <span class="total-price" id="finalPrice">
        0원
    </span>
            </div>


            <button class="pay-btn"
                    onclick="payment()">
                결제하기

            </button>


            <div class="agreement">

                <label>

                    <input type="checkbox"
                           id="agreement">

                    주문 내용을 확인했으며
                    결제에 동의합니다.

                </label>

                <br>

                위 주문 내용을 확인하였으며,
                결제 진행에 동의합니다.

            </div>

    </div>

    </aside>

    </div>


    <!-- ========================= -->
    <!-- 옵션 변경 모달 -->
    <!-- ========================= -->
    <div id="optionModal"
         class="option-modal">

        <div class="option-modal-content">

            <button type="button"
                    id="optionModalClose"
                    class="option-modal-close">
                ×
            </button>

            <h2>
                옵션 변경
            </h2>

            <div id="changeOptionArea">
                <!-- 옵션 선택 UI -->
            </div>

            <button type="button"
                    id="optionChangeConfirm">
                변경하기
            </button>

        </div>

    </div>

</main>


<script src="${pageContext.request.contextPath}/js/order.js"></script>
<script>
    $(".discount-btn").on("click", function (e) {
        location.href = "/couponlist.htm"
    })
</script>

</body>
</html>