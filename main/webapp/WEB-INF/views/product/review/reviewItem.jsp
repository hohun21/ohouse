<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="review-container-wrapper">
	<div class="review-list">
		<c:choose>
			<c:when test="${empty reviewList}">
				<div style="text-align: center; padding: 50px 0; color: #757575;">등록된
					리뷰가 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="review" items="${reviewList}">
					<div class="review-item"
						style="padding: 16px 0; border-bottom: 1px solid #f0f0f0;">
						<div class="user-profile">
							<span class="user-name"
								style="font-weight: bold; font-size: 13px;">${review.writerName}</span>
						</div>
						<div class="review-meta"
							style="font-size: 12px; color: #9e9e9e; margin-top: 2px;">
							<span class="stars" style="color: #35c5f0;"> <c:forEach
									begin="1" end="${review.rating}">★</c:forEach>
							</span> <span>${review.regDate}</span>
						</div>

						<!-- 임시 데이터 확인용 (문제 해결 후 삭제) -->


						<c:choose>
							<c:when test="${review.isPurchased eq 1}">
								<span class="badge-purchased"
									style="color: #35c5f0; font-weight: bold; background: #e8f7fc; padding: 2px 6px; border-radius: 4px; font-size: 12px;">
									오늘의집 구매자 </span>
							</c:when>
							<c:otherwise>
								<span class="badge-purchased"
									style="color: #757575; background: #f5f5f5; padding: 2px 6px; border-radius: 4px; font-size: 12px;">
									비구매자 </span>
							</c:otherwise>
						</c:choose>


						<c:if test="${not empty review.optionName}">
							<div class="review-option"
								style="font-size: 12px; color: #757575; margin-top: 4px;">
								선택옵션: ${review.optionName}</div>
						</c:if>


						<!-- 리뷰 이미지 출력 영역 -->
						<c:if
							test="${not empty review.reviewImage and not empty review.reviewImage.imageUrl}">
							<div class="review-image-wrap" style="margin-top: 10px;">
								<c:choose>
									<%-- 1. 이미지가 숨김 상태(1)인 경우 --%>
									<c:when test="${review.isHideImage == 1}">
										<%-- 관리자에게는 블라인드 안내 상자와 원본 이미지를 함께 표시 --%>
										<c:if test="${isAdmin}">
											<div class="blind-image-box">
												<span>⚠️ 관리자에 의해 숨김 처리된 이미지입니다.</span>
											</div>
											<img
												src="${pageContext.request.contextPath}${review.reviewImage.imageUrl}"
												alt="리뷰 이미지" class="review-img-thumb blind-preview" />
										</c:if>

										<%-- 일반 유저에게는 안내 상자만 표시 --%>
										<c:if test="${not isAdmin}">
											<div class="blind-image-box">
												<span>⚠️ 관리자에 의해 숨김 처리된 이미지입니다.</span>
											</div>
										</c:if>
									</c:when>

									<%-- 2. 이미지가 정상 노출 상태(0)인 경우 --%>
									<c:otherwise>
										<img
											src="${pageContext.request.contextPath}${review.reviewImage.imageUrl}"
											alt="리뷰 이미지" class="review-img-thumb" />
									</c:otherwise>
								</c:choose>
							</div>
						</c:if>

						<!-- 관리자 전용 토글 버튼 -->
						<c:if test="${isAdmin}">
							<div class="admin-control-wrap" style="margin-top: 5px;">
								<button type="button" class="btn-admin-hide"
									onclick="toggleHideImage(${review.reviewId}, ${review.isHideImage})">
									<c:choose>
										<c:when test="${review.isHideImage == 1}">사진 숨김 해제</c:when>
										<c:otherwise>사진 숨기기</c:otherwise>
									</c:choose>
								</button>
							</div>
						</c:if>


						<div class="review-content"
							style="font-size: 14px; margin-top: 8px; line-height: 1.5;">${review.content}
						</div>


						<!-- 💥 관리자 답변 표시 및 관리 영역 -->
						<div class="admin-reply-container" style="margin-top: 12px;">

							<%-- 1. 답변이 존재하는 경우 --%>
							<c:if test="${not empty review.adminReply}">
								<div class="admin-reply-box"
									style="padding: 12px; background-color: #f7f9fa; border-radius: 6px; border-left: 3px solid #35c5f0;">
									<div
										style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
										<span
											style="font-weight: bold; font-size: 12px; color: #35c5f0;">ㄴ
											판매자 답변</span>

										<%-- 💥 [수정] 문자열 "true"도 인식하도록 조건 통일 --%>
										<c:if test="${isAdmin eq true or isAdmin eq 'true'}">
											<div style="font-size: 11px;">
												<a href="javascript:void(0);"
													onclick="toggleReplyForm(${review.reviewId})"
													style="color: #757575; margin-right: 6px;">수정</a> <a
													href="javascript:void(0);"
													onclick="deleteAdminReply(${review.reviewId})"
													style="color: #f44336;">삭제</a>
											</div>
										</c:if>
									</div>
									<div style="font-size: 13px; color: #424242; line-height: 1.4;">${review.adminReply}</div>
								</div>
							</c:if>

							<%-- 2. 답변이 없고 관리자인 경우: [답변 달기] 버튼 노출 --%>
							<%-- 💥 [수정] isAdmin 조건 통일 --%>
							<c:if
								test="${empty review.adminReply and (isAdmin eq true or isAdmin eq 'true')}">
								<button type="button"
									onclick="toggleReplyForm(${review.reviewId})"
									style="padding: 4px 8px; font-size: 11px; color: #35c5f0; border: 1px solid #35c5f0; background: #fff; border-radius: 4px; cursor: pointer;">
									+ 답변 작성</button>
							</c:if>

							<%-- 3. 관리자 전용 답변 작성/수정 폼 (기본 숨김) --%>
							<c:if test="${isAdmin eq true or isAdmin eq 'true'}">
								<div id="reply-form-${review.reviewId}"
									style="display: none; margin-top: 8px; background: #f9f9f9; padding: 10px; border-radius: 4px;">
									<textarea id="reply-input-${review.reviewId}" rows="3"
										style="width: 100%; box-sizing: border-box; padding: 8px; border: 1px solid #ccc; border-radius: 4px; resize: vertical;"
										placeholder="답변 내용을 입력하세요.">${review.adminReply}</textarea>
									<div style="text-align: right; margin-top: 6px;">
										<button type="button"
											onclick="toggleReplyForm(${review.reviewId})"
											style="padding: 4px 8px; font-size: 12px; background: #ccc; border: none; border-radius: 3px; cursor: pointer;">취소</button>
										<button type="button"
											onclick="saveAdminReply(${review.reviewId})"
											style="padding: 4px 8px; font-size: 12px; background: #35c5f0; color: #fff; border: none; border-radius: 3px; cursor: pointer;">저장</button>
									</div>
								</div>
							</c:if>
						</div>

						<!-- 💥 [누락된 코드 추가] 도움이 돼요 버튼 및 카운트 영역 -->
						<div class="review-footer" style="margin-top: 12px;">
							<button type="button"
								class="btn-like js-review-like ${review.liked ? 'active' : ''}"
								data-review-id="${review.reviewId}"
								style="background: ${review.liked ? '#e8f7fc' : '#ffffff'}; 
								               border: 1px solid ${review.liked ? '#35c5f0' : '#e0e0e0'}; 
								               border-radius: 4px; padding: 6px 12px; font-size: 12px; 
								               color: ${review.liked ? '#35c5f0' : '#424242'}; 
								               cursor: pointer; display: inline-flex; align-items: center; gap: 4px;">
								<span>도움돼요</span> <span class="count"
									style="font-weight: bold; color: #35c5f0;">${not empty review.helpCount ? review.helpCount : 0}</span>
							</button>
						</div>
					</div>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>

	<!-- 동적 페이징 영역 -->
	<c:if test="${not empty pageDTO and pageDTO.totalPages > 0}">
		<div class="pagination"
			style="display: flex; justify-content: center; align-items: center; gap: 8px; margin-top: 24px;">
			<c:if test="${pageDTO.prev}">
				<a href="javascript:void(0);" data-page="${pageDTO.currentPage - 1}"
					data-sort="${currentSort}" class="page-btn js-review-action"
					style="padding: 6px 12px; border: 1px solid #e0e0e0; border-radius: 4px; color: #424242; text-decoration: none;">&lt;</a>
			</c:if>

			<c:forEach var="i" begin="${pageDTO.startPage}"
				end="${pageDTO.endPage}">
				<a href="javascript:void(0);" data-page="${i}"
					data-sort="${currentSort}"
					class="page-btn js-review-action ${pageDTO.currentPage eq i ? 'active' : ''}"
					style="padding: 6px 12px; border-radius: 4px; text-decoration: none; ${pageDTO.currentPage eq i ? 'background-color: #35c5f0; color: #fff; font-weight: bold;' : 'color: #424242;'}">
					${i} </a>
			</c:forEach>

			<c:if test="${pageDTO.next}">
				<a href="javascript:void(0);" data-page="${pageDTO.currentPage + 1}"
					data-sort="${currentSort}" class="page-btn js-review-action"
					style="padding: 6px 12px; border: 1px solid #e0e0e0; border-radius: 4px; color: #424242; text-decoration: none;">&gt;</a>
			</c:if>
		</div>
	</c:if>
	
</div>	