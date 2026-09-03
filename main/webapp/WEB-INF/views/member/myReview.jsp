<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<title>오늘의집 - 나의리뷰</title>

<link rel="stylesheet" as="style" crossorigin
	href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />

<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', 'Pretendard',
		sans-serif;
	background-color: #fff;
	color: #292929;
}

a {
	text-decoration: none;
	color: inherit;
}

.container {
	max-width: 1136px;
	margin: 0 auto;
	padding: 0 20px;
	box-sizing: border-box;
}

/* 상단 네비게이션 탭 */
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
	transition: color 0.2s ease;
}

.top-nav a:hover {
	color: #35c5f0;
}

.top-nav a.active {
	color: #35c5f0;
}

/* 서브 하위 탭 */
.sub-nav {
	display: flex;
	justify-content: center;
	border-bottom: 1px solid #ededed;
	padding: 15px 0;
	margin-bottom: 50px;
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

/* 회원탈퇴 영역 */
.withdraw-wrapper {
	max-width: 700px;
	margin: 0 auto 100px;
}

/* 탈퇴 사유 영역 */
.withdraw-reason-area {
	margin-top: 70px;
}

.withdraw-reason-area h2, .withdraw-feedback-area h2 {
	font-size: 18px;
	font-weight: bold;
	color: #292929;
	margin-bottom: 20px;
}

.withdraw-reason-area h2 span, .withdraw-feedback-area h2 span {
	color: #999;
	font-weight: normal;
}

.withdraw-reason-area h2 strong {
	color: #f06060;
	font-size: 14px;
	margin-left: 4px;
}

/* 탈퇴 사유 박스 */
.reason-list {
	border: 1px solid #dbdbdb;
	border-radius: 4px;
	padding: 28px 30px;
}

.reason-item {
	display: flex;
	align-items: center;
	margin-bottom: 18px;
	cursor: pointer;
	font-size: 14px;
	color: #424242;
}

.reason-item:last-child {
	margin-bottom: 0;
}

.reason-item input {
	width: 22px;
	height: 22px;
	margin-right: 10px;
	cursor: pointer;
	accent-color: #35c5f0;
}

/* 불편사항 */
.withdraw-feedback-area {
	margin-top: 42px;
}

.withdraw-feedback-area p {
	font-size: 14px;
	color: #424242;
	margin-bottom: 20px;
}

/* textarea */
.textarea-wrapper {
	position: relative;
	width: 100%;
}

.textarea-wrapper textarea {
	width: 100%;
	height: 200px;
	padding: 16px;
	border: 1px solid #dbdbdb;
	border-radius: 4px;
	resize: none;
	outline: none;
	font-family: inherit;
	font-size: 14px;
	line-height: 1.5;
	color: #424242;
}

.textarea-wrapper textarea:focus {
	border-color: #35c5f0;
}

.textarea-wrapper textarea::placeholder {
	color: #bdbdbd;
}

.text-count {
	position: absolute;
	right: 12px;
	bottom: 10px;
	font-size: 12px;
	color: #999;
}

/* 하단 버튼 */
.withdraw-buttons {
	display: flex;
	justify-content: center;
	gap: 10px;
	margin-top: 42px;
	margin-bottom: 80px;
}

.cancel-withdraw-btn, .withdraw-submit-btn {
	width: 160px;
	height: 46px;
	border-radius: 4px;
	font-size: 14px;
	font-weight: bold;
	cursor: pointer;
}

.cancel-withdraw-btn {
	background-color: #fff;
	border: 1px solid #dbdbdb;
	color: #424242;
}

.withdraw-submit-btn {
	background-color: #35c5f0;
	border: 1px solid #35c5f0;
	color: #fff;
}

.withdraw-submit-btn:disabled {
	background-color: #ededed;
	border-color: #ededed;
	color: #bdbdbd;
	cursor: default;
}

/* 회원탈퇴 제목 */
.withdraw-container h1 {
	font-size: 24px;
	font-weight: 700;
	margin-bottom: 34px;
}

.withdraw-description {
	font-size: 14px;
	font-weight: bold;
	color: #292929;
	margin-bottom: 18px;
}

.withdraw-description.error {
	color: #ff5a5f;
}

/* 회원탈퇴 안내 박스 */
.withdraw-notice {
	border: 1px solid #dbdbdb;
	border-radius: 4px;
	padding: 16px 20px 18px;
	margin-bottom: 18px;
}

.withdraw-notice h2 {
	font-size: 15px;
	font-weight: 700;
	margin-bottom: 12px;
}

.withdraw-notice ul {
	padding-left: 20px;
	margin-bottom: 12px;
}

.withdraw-notice li {
	font-size: 13px;
	line-height: 1.6;
	margin-bottom: 3px;
}

.withdraw-notice p {
	font-size: 13px;
	line-height: 1.7;
	margin: 0 0 14px;
	padding-left: 20px;
}

.withdraw-notice p:last-child {
	margin-bottom: 0;
}

/* 안내 확인 체크 */
.withdraw-check-area {
	margin-bottom: 48px;
}

.check-item {
	display: flex;
	align-items: center;
	gap: 9px;
	cursor: pointer;
	font-size: 13px;
}

.check-item input[type="checkbox"] {
	width: 22px;
	height: 22px;
	cursor: pointer;
}

.check-item strong {
	color: #f06060;
	font-weight: 600;
}

/* 고객센터 */
.withdraw-customer {
	position: absolute;
	right: 0;
	top: 2px;
	font-size: 13px;
	color: #757575;
}

.withdraw-customer strong {
	color: #424242;
}

.withdraw-error {
	display: none;
	margin-top: 8px;
	font-size: 12px;
	color: #f06060;
}

.withdraw-error.show {
	display: block;
}

/* 필수 체크 영역 */
.withdraw-confirm-area {
	position: relative;
	margin-top: 18px;
	margin-bottom: 40px;
}

.check-item {
	display: flex;
	align-items: center;
	cursor: pointer;
	font-size: 14px;
	color: #424242;
}

.check-item input {
	appearance: none;
	width: 20px;
	height: 20px;
	border: 1px solid #dbdbdb;
	border-radius: 4px;
	margin-right: 10px;
	background-color: #fff;
	cursor: pointer;
	position: relative;
}

.check-item input:checked {
	background-color: #35c5f0;
	border-color: #35c5f0;
}

.check-item input:checked::after {
	content: "✓";
	position: absolute;
	color: #fff;
	font-size: 14px;
	font-weight: bold;
	left: 3px;
	top: 0px;
}

.check-item strong {
	color: #ff5a5f;
}

/* 탈퇴 사유 */
.reason-section {
	margin-bottom: 40px;
}

.reason-section h2 {
	font-size: 17px;
	color: #292929;
	margin-bottom: 18px;
}

.reason-section h2 span {
	font-weight: normal;
	color: #757575;
}

.reason-section h2 strong {
	color: #ff5a5f;
	font-size: 14px;
}

/* 탈퇴 사유 박스 */
.reason-box {
	border: 1px solid #dbdbdb;
	border-radius: 4px;
	padding: 24px 30px;
}

.reason-item {
	display: flex;
	align-items: center;
	margin-bottom: 18px;
	font-size: 14px;
	color: #424242;
	cursor: pointer;
}

.reason-item:last-child {
	margin-bottom: 0;
}

.reason-item input {
	appearance: none;
	width: 21px;
	height: 21px;
	border: 1px solid #dbdbdb;
	border-radius: 4px;
	margin-right: 10px;
	background-color: #fff;
	cursor: pointer;
	position: relative;
}

.reason-item input:checked {
	background-color: #35c5f0;
	border-color: #35c5f0;
}

.reason-item input:checked::after {
	content: "✓";
	position: absolute;
	color: #fff;
	font-size: 14px;
	font-weight: bold;
	left: 3px;
	top: 0px;
}

/* 에러 상태 */
.withdraw-error {
	display: none;
	margin-top: 10px;
	color: #ff5a5f;
	font-size: 12px;
}

.withdraw-error.show {
	display: block;
}

/* 체크박스 에러 상태 */
.withdraw-confirm-area.error .check-item input {
	border-color: #ff5a5f;
}

.reason-section.error .reason-item input {
	border-color: #ff5a5f;
}

.reason-section.error .reason-box {
	border-color: #dbdbdb;
}

/* 에러 상태에서 필수 글씨 */
.withdraw-confirm-area.error .check-item strong {
	color: #ff5a5f;
}

.reason-section.error h2 {
	color: #ff5a5f;
}

.reason-section.error h2 span {
	color: #757575;
}

.reason-section.error h2 strong {
	color: #ff5a5f;
}

/* 탈퇴 확인 모달 */
.withdraw-modal {
	display: none;
	position: fixed;
	z-index: 9999;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.35);
	align-items: center;
	justify-content: center;
}

.withdraw-modal-content {
	position: relative;
	width: 270px;
	background-color: #fff;
	border-radius: 6px;
	padding: 24px 12px 12px;
	text-align: center;
}

.withdraw-modal-content h2 {
	font-size: 15px;
	font-weight: bold;
	margin-bottom: 12px;
}

.withdraw-modal-content p {
	font-size: 12px;
	line-height: 1.6;
	color: #424242;
	margin: 0;
}

.withdraw-modal-content .modal-warning {
	margin-top: 2px;
}

.modal-close {
	position: absolute;
	top: 10px;
	right: 12px;
	border: none;
	background: none;
	font-size: 22px;
	color: #292929;
	cursor: pointer;
}

.modal-buttons {
	display: flex;
	gap: 6px;
	margin-top: 18px;
}

.modal-buttons>button, .modal-buttons>form {
	flex: 1;
	width: 0;
}

.modal-buttons form {
	margin: 0;
}

.modal-buttons button {
	width: 100%;
	height: 34px;
	border-radius: 5px;
	font-size: 12px;
	cursor: pointer;
}

.cancel-btn {
	background-color: #fff;
	border: 1px solid #dbdbdb;
	color: #424242;
}

.confirm-withdraw-btn {
	background-color: #35c5f0;
	border: 1px solid #35c5f0;
	color: #fff;
	font-weight: bold;
}
</style>

</head>

<body>

	<jsp:include page="/WEB-INF/views/layout/header.jsp">
		<jsp:param name="showSubHeaderAtTop" value="false" />
	</jsp:include>


	<div class="top-nav">

		<a href="${pageContext.request.contextPath}/member/myPage.htm">프로필</a>
		<a href="${pageContext.request.contextPath}/member/myShopping.htm">나의 쇼핑</a>
        <a href="${pageContext.request.contextPath}/member/myReview.htm" class="active">나의 리뷰</a>
        <a href="${pageContext.request.contextPath}/changePwd.htm">설정</a>
	</div>


	<div class="sub-nav">

		<a href="#" class="active"> 내가 남긴 리뷰 </a>

	</div>


	<div class="container">

		<div class="review-container-wrapper"
			style="max-width: 800px; margin: 0 auto; font-family: sans-serif;">

			<!-- 1. 정렬 탭 (베스트순 / 최신순) -->
			<div class="review-filter-tabs"
				style="display: flex; gap: 8px; margin-bottom: 20px; border-bottom: 1px solid #e0e0e0; padding-bottom: 12px;">

				<!-- 베스트순 버튼 -->
				<button type="button" class="sort-btn" data-sort="best"
					style="padding: 6px 14px; border-radius: 4px; font-size: 13px; cursor: pointer; 
        			${currentSort eq 'best' ? 'background: #fff; border: 1px solid #35c5f0; color: #35c5f0; font-weight: bold;' : 'background: #fff; border: 1px solid #dbdbdb; color: #757575;'}">
					베스트순</button>

				<!-- 최신순 버튼 -->
				<button type="button" class="sort-btn" data-sort="recent"
					style="padding: 6px 14px; border-radius: 4px; font-size: 13px; cursor: pointer; 
        			${currentSort eq 'recent' or empty currentSort ? 'background: #fff; border: 1px solid #35c5f0; color: #35c5f0; font-weight: bold;' : 'background: #fff; border: 1px solid #dbdbdb; color: #757575;'}">
					최신순</button>
			</div>

			<!-- 2. 리뷰 리스트 영역 -->
			<div class="review-list">
				<c:choose>
					<c:when test="${empty reviewList}">
						<div style="text-align: center; padding: 50px 0; color: #757575;">
							작성한 리뷰가 없습니다.</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="review" items="${reviewList}">
							<div class="review-item"
								style="padding: 20px 0; border-bottom: 1px solid #f0f0f0;">

								<div
									style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
									<a
										href="${pageContext.request.contextPath}/product/productDetail.htm?product_id=${review.productId}"
										style="font-weight: bold; font-size: 15px; color: #292929; text-decoration: none;">
										${review.productName} </a>
									<div>
										<a href="javascript:void(0);" class="js-edit-review-btn"
											data-review-id="${review.reviewId}"
											data-rating="${review.rating}"
											data-content="${review.content}"
											data-image-url="${review.reviewImage.imageUrl}"
											data-product-id="${review.productId}"
											style="font-size: 12px; color: #757575; text-decoration: none;">수정</a>
									</div>
								</div>

								<div
									style="display: flex; justify-content: space-between; gap: 16px;">
									<div style="flex: 1;">
										<div
											style="font-size: 12px; color: #9e9e9e; margin-bottom: 6px;">
											<span style="color: #35c5f0; font-size: 14px;"> <c:forEach
													begin="1" end="${review.rating}">★</c:forEach>
											</span> <span style="margin-left: 6px;">${review.regDate}</span> <span
												style="margin-left: 4px; color: #35c5f0; font-weight: bold;">|
												오늘의집 구매</span>
										</div>

										<c:if test="${not empty review.optionName}">
											<div
												style="font-size: 12px; color: #757575; margin-bottom: 8px;">
												${review.optionName}</div>
										</c:if>

										<div
											style="font-size: 14px; color: #424242; line-height: 1.5;">
											${review.content}</div>
									</div>

									<c:if
										test="${not empty review.reviewImage and not empty review.reviewImage.imageUrl}">
										<div style="width: 80px; height: 80px; flex-shrink: 0;">
											<img src="${review.reviewImage.imageUrl}" alt="리뷰 이미지"
												style="width: 100%; height: 100%; object-fit: cover; border-radius: 4px;" />
										</div>
									</c:if>
								</div>

								<c:if test="${not empty review.adminReply}">
									<div
										style="margin-top: 12px; padding: 12px; background-color: #f7f9fa; border-radius: 6px;">
										<div
											style="font-size: 12px; font-weight: bold; color: #424242; margin-bottom: 4px;">
											오늘의집 고객센터</div>
										<div style="font-size: 13px; color: #757575;">
											${review.adminReply}</div>
									</div>
								</c:if>

							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>

			<!-- 3. 페이징 영역 -->
			<c:if test="${not empty pageDTO and pageDTO.totalPages > 0}">
				<div class="pagination"
					style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 24px;">
					<c:if test="${pageDTO.prev}">
						<a href="?page=${pageDTO.currentPage - 1}&sort=${currentSort}"
							style="padding: 6px 12px; border: 1px solid #e0e0e0; border-radius: 4px; text-decoration: none; color: #424242;">&lt;</a>
					</c:if>

					<c:forEach var="i" begin="${pageDTO.startPage}"
						end="${pageDTO.endPage}">
						<a href="?page=${i}&sort=${currentSort}"
							style="padding: 6px 12px; border-radius: 4px; text-decoration: none; ${pageDTO.currentPage eq i ? 'background-color: #35c5f0; color: #fff; font-weight: bold;' : 'color: #424242; border: 1px solid #e0e0e0;'}">
							${i} </a>
					</c:forEach>

					<c:if test="${pageDTO.next}">
						<a href="?page=${pageDTO.currentPage + 1}&sort=${currentSort}"
							style="padding: 6px 12px; border: 1px solid #e0e0e0; border-radius: 4px; text-decoration: none; color: #424242;">&gt;</a>
					</c:if>
				</div>
			</c:if>

		</div>

	</div>




	<jsp:include page="/WEB-INF/views/layout/footer.jsp" />

</body>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const wrapper = document.querySelector(".review-container-wrapper");

        document.addEventListener("click", function (e) {
            if (e.target.classList.contains("sort-btn")) {
                let sortValue = e.target.getAttribute("data-sort");

                fetch(`${pageContext.request.contextPath}/member/myReview.htm?page=1&sort=` + sortValue + `&ajax=true`)
                .then(response => response.text())
                .then(html => {
                    document.querySelector(".review-container-wrapper").innerHTML = html;
                    window.history.pushState({}, "", `?page=1&sort=` + sortValue);
                })
                .catch(error => console.error("정렬 에러:", error));
            }
            
            
         // 2. [여기 추가] 마이페이지에서 '수정' 버튼을 눌렀을 때 상세 페이지로 이동하며 데이터 전달
            if (e.target.classList.contains("js-edit-review-btn")) {
                let reviewId = e.target.getAttribute("data-review-id");
                let productId = e.target.getAttribute("data-product-id");
                let rating = e.target.getAttribute("data-rating");
                let content = e.target.getAttribute("data-content");
                let imageUrl = e.target.getAttribute("data-image-url");

                location.href = `${pageContext.request.contextPath}/product/productDetail.htm?product_id=` + productId + 
                                `&openEdit=true` +
                                `&reviewId=` + reviewId + 
                                `&rating=` + rating + 
                                `&imageUrl=` + encodeURIComponent(imageUrl) + 
                                `&content=` + encodeURIComponent(content);
            }
            
        });
        
        
    });
</script>
</html>