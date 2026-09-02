<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
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

<!-- 2. 리뷰 리스트 영역 (하드코딩 레이아웃) -->
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

					<!-- 상단: 상품명 & 수정/삭제 버튼 -->
					<div
						style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
						<!-- 상품명 클릭 시 해당 상품 상세 페이지로 이동 -->
						<a
							href="${pageContext.request.contextPath}/productDetail.htm?product_id=${review.productId}"
							style="font-weight: bold; font-size: 15px; color: #292929; text-decoration: none;">
							${review.productName} </a>
						<div>
							<!-- 본인이 쓴 리뷰이므로 수정 버튼 노출 -->
							<a href="javascript:void(0);" class="js-edit-review-btn"
								data-review-id="${review.reviewId}"
								data-rating="${review.rating}" data-content="${review.content}"
								data-image-url="${review.reviewImage.imageUrl}"
								data-product-id="${review.productId}"
								style="font-size: 12px; color: #757575; text-decoration: none;">수정</a>
						</div>
					</div>

					<!-- 메인 컨텐츠 레이아웃 -->
					<div
						style="display: flex; justify-content: space-between; gap: 16px;">
						<div style="flex: 1;">
							<!-- 별점 및 작성일/구매여부 -->
							<div style="font-size: 12px; color: #9e9e9e; margin-bottom: 6px;">
								<span style="color: #35c5f0; font-size: 14px;"> <c:forEach
										begin="1" end="${review.rating}">★</c:forEach>
								</span> <span style="margin-left: 6px;">${review.regDate}</span> <span
									style="margin-left: 4px; color: #35c5f0; font-weight: bold;">|
									오늘의집 구매</span>
							</div>

							<!-- 옵션 정보 (있는 경우에만) -->
							<c:if test="${not empty review.optionName}">
								<div
									style="font-size: 12px; color: #757575; margin-bottom: 8px;">
									${review.optionName}</div>
							</c:if>

							<!-- 리뷰 본문 -->
							<div style="font-size: 14px; color: #424242; line-height: 1.5;">
								${review.content}</div>
						</div>

						<!-- 우측 이미지 영역 (있는 경우) -->
						<c:if
							test="${not empty review.reviewImage and not empty review.reviewImage.imageUrl}">
							<div style="width: 80px; height: 80px; flex-shrink: 0;">
								<img src="${review.reviewImage.imageUrl}" alt="리뷰 이미지"
									style="width: 100%; height: 100%; object-fit: cover; border-radius: 4px;" />
							</div>
						</c:if>
					</div>

					<!-- 관리자 답변 영역 (답변이 있는 경우) -->
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

<!-- 페이징 영역 -->
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