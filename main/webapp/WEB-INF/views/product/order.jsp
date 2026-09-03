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
                         data-cart-items-id="${item.cart_items_id}"
                         data-img-url="${item.image_url}"
                         data-brand-id="${item.brand_id}"
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

                            <div class="brand-name">
                                ${item.brand_name}<br>
                            </div>
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
            <!-- 배송지  -->
            <!-- ========================= -->
            <section class="section">
                <h2 class="section-title">배송지</h2>

                <c:choose>
                    <c:when test="${not empty addressList}">
                        <c:set var="addr" value="${addressList[0]}" />
                        
                        <input type="hidden" id="selectedAddressId" value="${addr.address_id}">

                        <div class="address-box">
                            <div class="address-top">
                                <div>
                                    <span class="address-name">${addr.recipient_name}</span>
                                    <c:if test="${addr.is_default == 'Y'}">
                                        <span class="default-label">기본배송지</span>
                                    </c:if>
                                </div>
                                <button type="button" class="change-btn" id="btnOpenAddressModal">
                                    변경
                                </button>
                            </div>

                            <div class="address">
                                [${addr.zip_code}] ${addr.base_address}<br>
                                ${addr.detail_address}<br>
                                ${addr.phone}
                            </div>

                            <div class="delivery-row">
                                <label>배송 요청사항</label>
                                <select id="orderRequestMsg">
                                    <option value="" ${empty addr.request_msg ? 'selected' : ''}>배송 요청사항을 선택해주세요.</option>
                                    <option value="부재시 문 앞에 놓아주세요." ${addr.request_msg == '부재시 문 앞에 놓아주세요.' ? 'selected' : ''}>부재시 문 앞에 놓아주세요.</option>
                                    <option value="부재시 경비실에 맡겨주세요." ${addr.request_msg == '부재시 경비실에 맡겨주세요.' ? 'selected' : ''}>부재시 경비실에 맡겨주세요.</option>
                                    <option value="부재시 전화 또는 문자주세요." ${addr.request_msg == '부재시 전화 또는 문자주세요.' ? 'selected' : ''}>부재시 전화 또는 문자주세요.</option>
                                    <option value="택배함에 넣어주세요." ${addr.request_msg == '택배함에 넣어주세요.' ? 'selected' : ''}>택배함에 넣어주세요.</option>
                                    <option value="직접입력" ${addr.request_msg == '직접입력' ? 'selected' : ''}>직접입력</option>
                                </select>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="address-box" style="text-align: center; padding: 40px 0;">
                            <p style="color: #757575; font-size: 15px; margin-bottom: 15px;">등록된 배송지가 없습니다.</p>
                            <button type="button" class="change-btn" style="padding: 10px 20px; font-size: 14px;" onclick="location.href='${pageContext.request.contextPath}/addressList.htm'">
                                배송지 추가하기
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>

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

            <script src="https://js.tosspayments.com/v2/standard"></script>
            <button class="pay-btn" id="paymentButton" onclick="payment()">
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


    <!-- ========================= -->
    <!-- 💡 배송지 목록 모달창 -->
    <!-- ========================= -->
    <div class="modal-overlay" id="addressModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>배송지 목록</h2>
                <button type="button" class="btn-close-modal" id="btnCloseModal">✕</button>
            </div>
            
            <div class="modal-body">
                <c:choose>
                    <c:when test="${empty addressList}">
                        <div class="empty-msg" style="text-align: center; padding: 40px 0; color: #757575;">등록된 배송지가 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="addr" items="${addressList}">
                            <div class="address-item" style="background: #fff; border: 1px solid #dbdbdb; border-radius: 6px; padding: 20px; margin-bottom: 12px;">
                                <div class="item-head" style="margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                                    <span class="name" style="font-weight: bold; font-size: 16px; color: #292929;">
                                        ${addr.recipient_name}
                                        <c:if test="${not empty addr.address_name}"> (${addr.address_name})</c:if>
                                    </span>
                                    <c:if test="${addr.is_default == 'Y'}">
                                        <span class="badge" style="font-size: 11px; color: #35c5f0; background: #f0f8fb; padding: 3px 6px; border-radius: 4px; font-weight: bold;">기본배송지</span>
                                    </c:if>
                                </div>
                                <div class="item-body">
                                    <p style="font-size: 14px; color: #424242; margin-bottom: 6px;">[${addr.zip_code}] ${addr.base_address}</p>
                                    <p style="font-size: 14px; color: #424242; margin-bottom: 6px;">${addr.detail_address}</p>
                                    <p style="font-size: 14px; color: #424242; margin-bottom: 6px;">${addr.phone}</p>
                                    <c:if test="${not empty addr.request_msg}">
                                        <div class="req-msg" style="margin-top: 12px; padding-top: 12px; border-top: 1px solid #ededed; color: #757575; font-size: 13px;">배송 요청사항: ${addr.request_msg}</div>
                                    </c:if>
                                </div>
                                <div class="item-footer" style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 15px;">
                                    <button type="button" class="btn-item select-address-btn" 
                                            data-id="${addr.address_id}"
                                            data-name="${addr.recipient_name}"
                                            data-zip="${addr.zip_code}"
                                            data-base="${addr.base_address}"
                                            data-detail="${addr.detail_address}"
                                            data-phone="${addr.phone}"
                                            data-msg="${addr.request_msg}"
                                            data-isdefault="${addr.is_default}"
                                            style="padding: 6px 14px; font-size: 13px; border: 1px solid #35c5f0; background: #35c5f0; color: #fff; border-radius: 4px; cursor: pointer; font-weight: bold;">
                                        이 배송지 선택
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                
                <div style="text-align: center; margin-top: 15px;">
                    <button type="button" onclick="location.href='${pageContext.request.contextPath}/addressList.htm'" style="padding: 10px; width: 100%; background: #fff; border: 1px solid #dbdbdb; border-radius: 4px; font-weight: bold; cursor: pointer; color: #424242;">
                        배송지 관리 (추가/수정) 하러 가기
                    </button>
                </div>
            </div>
        </div>
    </div>

</main>

<script>
    const member_id = "${sessionScope.authUser.id}";
</script>
<script src="${pageContext.request.contextPath}/js/order.js"></script>

</body>
</html>