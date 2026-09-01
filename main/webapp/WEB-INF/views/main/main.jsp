<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오늘의집 - 인테리어 플랫폼</title>
<style>
/* 기본 리셋 및 폰트 */
body {
	margin: 0;
	padding: 0;
	font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
	background-color: #fff;
	color: #292929;
	box-sizing: border-box;
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
.container {
	max-width: 1136px;
	margin: 0 auto;
	padding: 0 20px;
	box-sizing: border-box;
}
/* --- 서브 네비게이션 --- */
.home-sub-nav-area {
	border-bottom: 1px solid #EAEDEF;
	background: #fff;
	margin-bottom: 30px;
}
.home-sub-nav {
	max-width: 1136px;
	margin: 0 auto;
	padding: 0 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	box-sizing: border-box;
}
.sub-nav-list {
	display: flex;
	gap: 24px;
	font-size: 15px;
	font-weight: 700;
	color: #424242;
}
.sub-nav-list a {
	padding: 12px 0;
	position: relative;
	transition: color 0.2s;
}
.sub-nav-list a:hover, .sub-nav-list a.active {
	color: #1496f4;
}
.sub-nav-list a.active::after {
	content: "";
	position: absolute;
	bottom: -1px;
	left: 0;
	width: 100%;
	height: 2px;
	background-color: #1496f4;
}
/* --- 상단 더블 배너 --- */
.top-banners {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
	margin-bottom: 40px;
}
.banner-img {
	width: 100%;
	aspect-ratio: 16/9;
	border-radius: 8px;
	background-color: #EAEDEF;
	object-fit: cover;
	cursor: pointer;
	transition: opacity 0.2s;
}
.banner-img:hover {
	opacity: 0.9;
}
/* --- 카테고리 슬라이더 --- */
.category-section {
	margin-bottom: 50px;
	position: relative;
}
.category-title {
	font-size: 20px;
	font-weight: 700;
	margin-bottom: 20px;
	color: #000;
}
.category-slider {
	position: relative;
}
.category-viewport {
	overflow: hidden;
	scrollbar-width: none;
}
.category-viewport::-webkit-scrollbar { display: none; }
.category-section .category-menu {
	display: flex;
	gap: 16px;
	overflow: visible;
	scrollbar-width: none;
	transition: transform 0.35s ease;
	will-change: transform;
}
.category-section .category-menu::-webkit-scrollbar { display: none; }
.category-section .category-menu > li {
	flex: 0 0 calc((100% - 176px) / 12);
	min-width: 0;
}
.category-section .category-menu > li > a {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 8px;
	text-align: center;
	font-size: 13px;
	font-weight: 500;
	color: #424242;
	white-space: nowrap;
}
.category-section .category-menu img {
	width: 72px;
	height: 72px;
	border-radius: 24px;
	background-color: #F7F9FA;
	object-fit: contain;
	transition: transform 0.2s;
}
.category-section .category-menu a:hover img {
	transform: translateY(-3px);
}
.category-arrow {
	position: absolute;
	top: 50%;
	z-index: 2;
	width: 44px;
	height: 44px;
	border: 1px solid #EAEDEF;
	border-radius: 50%;
	background: #fff;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.14);
	display: flex;
	align-items: center;
	justify-content: center;
	transform: translateY(-50%);
	cursor: pointer;
	color: #2F3438;
}
.category-arrow.prev { left: -22px; }
.category-arrow.next { right: -22px; }
.category-arrow:disabled {
	display: none;
}
.category-arrow svg {
	width: 20px;
	height: 20px;
	fill: none;
	stroke: currentColor;
	stroke-width: 2;
	stroke-linecap: round;
	stroke-linejoin: round;
}
/* --- 추천상품 그리드 (DB 연동 영역) --- */
.recommend-section {
	margin-bottom: 60px;
}
.recommend-title {
	font-size: 20px;
	font-weight: 700;
	margin-bottom: 20px;
	color: #000;
}
.grid-4 {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 24px 20px;
}
.product-card {
	cursor: pointer;
	display: block;
}
.product-img-wrap {
	width: 100%;
	aspect-ratio: 1/1;
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
	word-break: keep-all;
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
</style>
</head>
<body>
	<!-- 헤더 Include -->
	<jsp:include page="../layout/header.jsp" />
	<main class="container">
		<!-- 상단 더블 배너 (하드코딩 유지) -->
		<section class="top-banners">
			<img
				src="https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=800&q=80"
				alt="집요한세일 배너" class="banner-img"> <img
				src="https://images.unsplash.com/photo-1490644658840-3f2e3f8c5625?w=800&q=80"
				alt="특별한 플레이트 배너" class="banner-img">
		</section>
		<!-- 카테고리 영역 (아이콘 하드코딩 유지) -->
		<section class="category-section">
			<h2 class="category-title">카테고리</h2>
			<div class="category-slider">
				<button type="button" class="category-arrow prev" aria-label="이전 카테고리" disabled>
					<svg viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6" /></svg>
				</button>
				<div class="category-viewport">
				<ul class="category-menu">
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-533660207636544.png?w=1280" /><span>집요한세일</span></a></li>
				<li><a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${furnitureCategory.category_id}"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634278838272.png?w=1280" /><span>${furnitureCategory.category_name}</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634298495104.png?w=1280" /><span>가전·디지털</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634315501568.png?w=1280" /><span>패브릭</span></a></li>
				<li><a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${kitchenCategory.category_id}"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634333909120.png?w=1280" /><span>${kitchenCategory.category_name}</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634353033280.png?w=1280" /><span>식품</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634373091328.png?w=1280" /><span>데코·식물</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-485389660414080.png?w=1280" /><span>조명</span></a></li>
				<li><a href="${pageContext.request.contextPath}/shopping/category/category.htm?category_id=${storageCategory.category_id}"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634412826752.png?w=1280" /><span>${storageCategory.category_name}</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634428547136.png?w=1280" /><span>생활용품</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634451369984.png?w=1280" /><span>생필품</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634472935424.png?w=1280" /><span>유아·아동</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-485353010577408.png?w=1280" /><span>반려동물</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634521288768.png?w=1280" /><span>캠핑·레저</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634541781120.png?w=1280" /><span>공구·DIY</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634560954368.png?w=1280" /><span>인테리어시공</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634580844544.png?w=1280" /><span>렌탈·구독</span></a></li>
				<li><a href="#"><img src="https://prs.ohouse.com/apne2/commerce/uploads/category/store_hamburger_categories/v1-484634600026240.png?w=1280" /><span>장보기</span></a></li>
				</ul>
				</div>
				<button type="button" class="category-arrow next" aria-label="다음 카테고리">
					<svg viewBox="0 0 24 24"><path d="M9 6l6 6-6 6" /></svg>
				</button>
			</div>
		</section>
		<section class="recommend-section">
			<h2 class="recommend-title">추천상품</h2>
			<div class="grid-4">
				<c:forEach var="product" items="${randomProductList}">
					<a href="/productDetail.htm?product_id=${product.productId}"
						class="product-card">
						<div class="product-img-wrap">
							<img src="${product.imageUrl}" alt="${product.productName}">
						</div>
						<div class="brand-name">${product.brandName}</div>
						<div class="product-name">${product.productName}</div>
						<div class="price-area">
							<c:if test="${product.discountRate > 0}">
								<span class="discount">${product.discountRate}%</span>
							</c:if>
							<span class="price"><fmt:formatNumber
									value="${product.price}" pattern="#,###" /></span>
						</div>
						<div class="review-area">
							<span class="star">★</span> 4.8 리뷰 1,200
						</div>
					</a>
				</c:forEach>
				<c:if test="${empty randomProductList}">
					<div
						style="grid-column: span 4; text-align: center; padding: 50px 0; color: #757575;">
						등록된 추천 상품이 없습니다.</div>
				</c:if>
			</div>
		</section>
	</main>
	<script>
	document.addEventListener("DOMContentLoaded", function () {
		const slider = document.querySelector(".category-slider");
		if (!slider) return;
		const viewport = slider.querySelector(".category-viewport");
		const menu = slider.querySelector(".category-menu");
		const prevButton = slider.querySelector(".category-arrow.prev");
		const nextButton = slider.querySelector(".category-arrow.next");
		let currentPosition = 0;
		function getMaxPosition() {
			return Math.max(0, menu.scrollWidth - viewport.clientWidth);
		}
		function updateSlider() {
			const maxPosition = getMaxPosition();
			currentPosition = Math.min(currentPosition, maxPosition);
			menu.style.transform = "translateX(-" + currentPosition + "px)";
			prevButton.disabled = currentPosition <= 0;
			nextButton.disabled = currentPosition >= maxPosition - 1;
		}
		prevButton.addEventListener("click", function () {
			currentPosition = 0;
			updateSlider();
		});
		nextButton.addEventListener("click", function () {
			currentPosition = getMaxPosition();
			updateSlider();
		});
		window.addEventListener("resize", updateSlider);
		updateSlider();
	});
	</script>
	<jsp:include page="../layout/footer.jsp" />
</body>
</html>
