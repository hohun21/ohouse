<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - 오늘의집</title>
    <style>
        /* 기본 리셋 및 폰트 */
        body {
            margin: 0;
            padding: 0;
            font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
            background-color: #fff;
            color: #292929;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        /* 상단 네비게이션 탭 (프로필, 나의 쇼핑 등) */
        .top-nav {
            display: flex;
            justify-content: center;
            border-bottom: 1px solid #ededed;
            padding: 15px 0;
        }

        .top-nav a {
            margin: 0 15px;
            font-size: 16px;
            font-weight: bold;
            color: #424242;
        }

        .top-nav a.active {
            color: #35c5f0;
        }

        /* 서브 네비게이션 탭 (모두보기, 사진 등) */
        .sub-nav {
            display: flex;
            justify-content: center;
            border-bottom: 1px solid #ededed;
            padding: 15px 0;
            margin-bottom: 40px;
        }

        .sub-nav a {
            margin: 0 15px;
            font-size: 15px;
            font-weight: bold;
            color: #757575;
            position: relative;
            padding-bottom: 15px;
            transition: color 0.2s ease;
        }

        .sub-nav a:hover {
            color: #35c5f0;
        }

        .sub-nav a.active {
            color: #35c5f0;
        }

        .sub-nav a.active::after {
            content: "";
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #35c5f0;
        }

        /* 메인 레이아웃 (좌측 프로필, 우측 컨텐츠) */
        .mypage-layout {
            max-width: 1136px;
            margin: 0 auto;
            display: flex;
            gap: 30px;
            padding: 0 20px 100px 20px;
        }

        /* 좌측 프로필 카드 */
        .profile-sidebar {
            width: 280px;
            flex-shrink: 0;
        }

        .profile-card {
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            padding: 30px 20px;
            text-align: center;
            position: relative;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
        }

        .share-icon {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 24px;
            height: 24px;
            cursor: pointer;
            color: #757575;
        }

        /* 프로필 이미지 */
        .profile-img {
            width: 120px;
            height: 120px;
            background-color: #dbdbdb;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: white;
        }

        .profile-name {
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .profile-stats {
            font-size: 13px;
            color: #757575;
            margin-bottom: 15px;
        }

        .profile-setting-btn {
            display: inline-block;
            padding: 6px 12px;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            font-size: 13px;
            color: #424242;
            font-weight: bold;
        }

        /* 프로필 하단 요약 (스크랩북, 좋아요, 내쿠폰) */
        .profile-summary {
            display: flex;
            justify-content: space-around;
            border-top: 1px solid #ededed;
            border-bottom: 1px solid #ededed;
            padding: 20px 0;
            margin: 25px 0;
        }

        .summary-item {
            text-align: center;
            font-size: 13px;
            color: #424242;
            display: flex;
            flex-direction: column;
            gap: 8px;
            font-weight: bold;
        }

        .summary-item span {
            font-size: 16px;
        }

        /* 활동 대시보드 버튼 스타일 (링크용) */
        .dashboard-btn {
            display: block;
            width: 100%;
            padding: 12px 0;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            color: #424242;
            background: white;
            cursor: pointer;
            text-align: center;
            box-sizing: border-box;
            text-decoration: none;
        }

        .dashboard-btn:hover {
            background-color: #f7f9fa;
        }

        /* 우측 컨텐츠 영역 */
        .content-area {
            flex: 1;
        }

        .content-section {
            margin-bottom: 40px;
        }

        .content-title {
            font-size: 18px;
            font-weight: bold;
            color: #292929;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .content-title span {
            color: #35c5f0;
            margin-left: 5px;
        }

        /* 점선 빈 화면 박스 */
        .empty-box {
            border: 1px dashed #dbdbdb;
            background-color: #fafafa;
            height: 160px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #757575;
            font-size: 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .empty-box:hover {
            background-color: #f5f5f5;
        }

        /* 배지 */
        .role-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            color: white;
            font-size: 12px;
            margin-bottom: 10px;
        }

        .badge-admin {
            background-color: #ff4d4f;
        }

        .badge-seller {
            background-color: #35c5f0;
        }

        .order-page {
            background: #fff;
            min-height: 100vh;
            padding: 40px 0 80px;
        }

        .order-container {
            width: 1000px;
            margin: 0 auto;
        }

        .order-container h1 {
            margin: 0 0 30px;
            font-size: 24px;
        }

        .order-tabs {
            display: flex;
            border-bottom: 1px solid #ddd;
            margin-bottom: 30px;
        }

        .order-tabs a {
            flex: 1;
            padding: 18px 0;
            text-align: center;
            color: #777;
            font-size: 15px;
            text-decoration: none;
        }

        .order-tabs a.active {
            color: #35c5f0;
            font-weight: 700;
            border-bottom: 2px solid #35c5f0;
        }

        .order-item {
            border: 1px solid #e5e5e5;
            border-radius: 8px;
            margin-bottom: 20px;
            overflow: hidden;
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            padding: 18px 20px;
            background: #fafafa;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }

        .order-header a {
            color: #555;
            text-decoration: none;
        }

        .order-product {
            display: flex;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #eee;
        }

        .order-product img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 6px;
            margin-right: 20px;
        }

        .product-info {
            flex: 1;
        }

        .product-info strong {
            display: block;
            margin-bottom: 5px;
            font-size: 13px;
            color: #555;
        }

        .product-info h3 {
            margin: 0 0 8px;
            font-size: 15px;
        }

        .product-info p {
            margin: 0 0 8px;
            color: #888;
            font-size: 13px;
        }

        .product-info span {
            color: #777;
            font-size: 13px;
        }

        .product-price {
            width: 150px;
            text-align: center;
        }

        .product-price strong {
            font-size: 16px;
        }

        .order-status {
            display: inline-block;
            padding: 18px 0 18px 20px;
            text-align: left;
            color: #000000;
        }

        .order-status strong {
            font-size: 15px;
            font-weight: 600;
        }

        .delivery-date {
            display: inline-block;
            padding: 18px 20px 18px 8px;
            text-align: left;
            color: #000000;
            font-size: 15px;
            font-weight: 400;
        }

        .benefit-box {
            width: 100%;
            height: 80px;
            border: 1px solid #ddd;
            border-radius: 8px;
            display: flex;
            align-items: center;
            margin-bottom: 30px;
            box-sizing: border-box;
        }

        .benefit-item {
            flex: 1;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 16px;
        }

        .benefit-divider {
            width: 1px;
            height: 60px;
            background: #ddd;
        }

        .benefit-icon {
            width: 44px;
            height: 32px;
            border: 2px solid #999;
            color: #777;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            box-sizing: border-box;
        }

        .coupon-icon {
            border-radius: 4px;
            font-size: 18px;
        }

        .grade-icon {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            font-size: 14px;
        }

        .benefit-info {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }

        .benefit-title {
            color: #333;
        }

        .benefit-info strong {
            color: #0099ff;
            font-size: 14px;
        }

        .order-status-box {
            width: 100%;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            margin-bottom: 30px;
        }

        .order-status-title {
            display: flex;
            align-items: center;
            gap: 5px;
            margin: 0 0 25px 0;
            font-size: 16px;
        }

        .order-status-title strong {
            color: #222;
        }

        .order-status-title span {
            color: #999;
            font-weight: 400;
        }

        .order-status-list {
            display: flex;
            align-items: center;
            justify-content: space-around;
        }

        .order-status-item {
            min-width: 80px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .order-status-item span {
            color: #333;
            font-size: 15px;
            white-space: nowrap;
        }

        .order-status-item strong {
            color: #0099ff;
            font-size: 18px;
            font-weight: 400;
        }

        .order-status-arrow {
            color: #bbb;
            font-size: 38px;
            font-weight: 200;
            line-height: 1;
            margin: 0 5px;
        }


        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-header > div {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .order-toggle {
            border: 0;
            background: none;
            cursor: pointer;
            color: #555;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .order-details {
            display: block;
        / / 화살표
        }

        .order-details.open {
            display: block;
        }

        .order-buttons button {
            display: block;
            margin-bottom: 8px;
        }

        .order-buttons {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-left: 10px;
        }

        .order-buttons button {
            width: 120px;
            height: 40px;
            padding: 0;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: #fff;
            color: #333;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .order-buttons button:hover {
            background: #f7f7f7;
        }
    </style>

</head>
<body>

<!-- 헤더 Include -->
<jsp:include page="/WEB-INF/views/layout/header.jsp">
    <jsp:param name="showSubHeaderAtTop" value="false"/>
</jsp:include>

<div class="top-nav">
    <a href="${pageContext.request.contextPath}/member/myPage.htm">프로필</a>
    <a href="${pageContext.request.contextPath}/member/myShopping.htm" class="active">나의 쇼핑</a>
    <a href="#">나의 리뷰</a>
    <!-- 💡 수정 1: 상단 설정 버튼 경로 연결 -->
    <a href="${pageContext.request.contextPath}/changePwd.htm">설정</a>
</div>
<div class="sub-nav">
    <a href="#" class="active">모두보기</a>
    <a href="#">사진</a>
    <a href="#">집들이</a>
    <a href="#">노하우</a>
    <a href="#">스크랩북</a>
    <a href="#">좋아요</a>
</div>
<div class="benefit-box">
    <div class="benefit-item">
        <div class="benefit-icon coupon-icon">C</div>
        <div class="benefit-info">
            <span class="benefit-title">쿠폰</span>
            <strong>0</strong>
        </div>
    </div>

    <div class="benefit-divider"></div>

    <div class="benefit-item">
        <div class="benefit-icon grade-icon">W</div>
        <div class="benefit-info">
            <span class="benefit-title">구매등급</span>
            <strong>WELCOME</strong>
        </div>
    </div>
</div>
<div class="order-page">
    <div class="order-container">
        <h1>주문배송내역</h1>


        <div class="order-status-box">
            <div class="order-status-title">
                <strong>진행중인 주문</strong>
            </div>

            <div class="order-status-list">


                <div class="order-status-item">
                    <span>결제완료</span>
                    <strong>${statusCount.paymentCount}</strong>
                </div>

                <div class="order-status-arrow">›</div>

                <div class="order-status-item">
                    <span>배송준비</span>
                    <strong>${statusCount.preparingCount}</strong>
                </div>

                <div class="order-status-arrow">›</div>

                <div class="order-status-item">
                    <span>배송중</span>
                    <strong>${statusCount.shippingCount}</strong>
                </div>

                <div class="order-status-arrow">›</div>

                <div class="order-status-item">
                    <span>배송완료</span>
                    <strong>${statusCount.deliveredCount}</strong>
                </div>

                <div class="order-status-arrow">›</div>

                <div class="order-status-item">
                    <span>구매확정</span>
                    <strong>${statusCount.confirmedCount}</strong>
                </div>
            </div>
        </div>
        <div class="order-list">
            <c:forEach var="order" items="${orderdto}">
                <div class="order-item">
                    <div class="order-header">
                        <div>
                            <span>${order.order_date}</span>
                            <span class="order-name">${order.order_name}</span>
                        </div>
                        <button type="button" class="order-toggle">
                            <span>주문상세</span>
                            <span class="arrow">▼</span>
                        </button>
                    </div>

                    <div class="order-details">
                        <c:forEach var="item" items="${order.orderDetails}">
                            <div class="order-status">
                                <strong>
                                    <c:choose>
                                        <c:when test="${item.delivery_status == 1}">결제완료</c:when>
                                        <c:when test="${item.delivery_status == 2}">배송준비</c:when>
                                        <c:when test="${item.delivery_status == 3}">배송중</c:when>
                                        <c:when test="${item.delivery_status == 4}">배송완료</c:when>
                                        <c:when test="${item.delivery_status == 5 || item.delivery_status == 12}">구매확정</c:when>
                                        <c:when test="${item.delivery_status == 6}">반품요청</c:when>
                                        <c:when test="${item.delivery_status == 7}">반품승인</c:when>
                                        <c:when test="${item.delivery_status == 8}">반품수거중</c:when>
                                        <c:when test="${item.delivery_status == 9}">반품완료</c:when>
                                        <c:when test="${item.delivery_status == 10}">취소요청</c:when>
                                        <c:when test="${item.delivery_status == 11}">취소완료</c:when>
                                    </c:choose>
                                </strong>
                            </div>
                            <c:if test="${item.delivery_status >= 4 && item.delivery_status <= 7}">
                                <div class="delivery-date">
                                    <fmt:formatDate value="${item.delivered_date}" pattern="MM/dd(E)"/> 도착 완료
                                </div>
                            </c:if>
                            <div class="order-product">
                                <img src="${item.image_url}" alt="${item.product_name}">
                                <div class="product-info">
                                    <strong>${item.brand_name}</strong>
                                    <h3>${item.product_name}</h3>
                                    <p>${item.option_name}</p>
                                    <span>${item.quantity}개</span>
                                </div>
                                <div class="product-price">
                                    <strong><fmt:formatNumber value="${item.price}" pattern="#,###"/>원</strong>
                                </div>
                                <c:choose>
                                    <c:when test="${item.delivery_status >= 5 && item.delivery_status <=12}">
                                    </c:when>
                                    <c:when test="${item.delivery_status == 1}">
                                        <div class="order-buttons">
                                            <button type="button" class="cancel-btn" data-id="${item.orders_detail_id}">취소요청</button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="order-buttons">
                                            <button type="button" class="return-btn" data-id="${item.orders_detail_id}">반품요청</button>
                                            <button type="button" class="confirm-btn" data-id="${item.orders_detail_id}">구매확정</button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </c:forEach>
                    </div>


                </div>
            </c:forEach>
        </div>

    </div>
</div>
<script>
    document.querySelectorAll(".order-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            const orderItem = button.closest(".order-item");
            const details = orderItem.querySelector(".order-details");
            const arrow = button.querySelector(".arrow");

            const isOpen = details.classList.toggle("open");
            arrow.textContent = isOpen ? "▲" : "▼";
        });
    });
    document.querySelectorAll(".confirm-btn").forEach(function (button) {
        button.addEventListener("click", async function () {
            const result = confirm("구매확정 처리가 되면 반품이 불가능 합니다. 계속 하시겠습니까?");

            if (!result) {
                return;
            }

            const orderDetailId = this.dataset.id;

            try {
                const response = await fetch(
                    "${pageContext.request.contextPath}/order/confirm.htm?orders_detail_id=" + orderDetailId,
                    {
                        method: "POST"
                    }
                );

                const data = await response.json();

                if (data.success) {
                    alert("구매 확정 되었습니다.");
                }
            } catch (error) {
                console.error(error);
            }
        });
    });
    document.querySelectorAll(".return-btn").forEach(function (button) {
        button.addEventListener("click", async function () {
            const result = confirm("합당한 반품요청이 아닐 시 반품이 거부될 수 있습니다. 계속 하시겠습니까?");

            if (!result) {
                return;
            }

            const orderDetailId = this.dataset.id;

            try {
                const response = await fetch(
                    "${pageContext.request.contextPath}/order/return.htm?orders_detail_id=" + orderDetailId,
                    {
                        method: "POST"
                    }
                );

                const data = await response.json();

                if (data.success) {
                    alert("반품 요청 되었습니다. 승인/거부 까지는 1~2일 소요됩니다.");
                }
            } catch (error) {
                console.error(error);
            }
        });
    });
    document.querySelectorAll(".cancel-btn").forEach(function (button) {
        button.addEventListener("click", async function () {
            const result = confirm("배송이 시작되었을 경우 취소요청이 거부될 수 있습니다. 계속 하시겠습니까?");

            if (!result) {
                return;
            }

            const orderDetailId = this.dataset.id;

            try {
                const response = await fetch(
                    "${pageContext.request.contextPath}/order/cancel.htm?orders_detail_id=" + orderDetailId,
                    {
                        method: "POST"
                    }
                );

                const data = await response.json();

                if (data.success) {
                    alert("취소 요청 되었습니다. 승인/거부까지 1~2일 소요될 수 있습니다.");
                }
            } catch (error) {
                console.error(error);
            }
        });
    });
</script>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

</body>
</html>