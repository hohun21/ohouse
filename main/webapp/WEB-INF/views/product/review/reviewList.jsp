<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- CSS 불러오기 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/reviewList.css">

<style>
/* 필터 및 드롭다운 기본 스타일 */
.review-filter-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 12px 0;
	border-bottom: 1px solid #ededed;
}

.filter-tabs {
	display: flex;
	gap: 12px;
}

.filter-tabs button {
	background: none;
	border: none;
	font-size: 14px;
	color: #757575;
	cursor: pointer;
	padding: 0;
}

.filter-tabs button.active {
	font-weight: bold;
	color: #35c5f0;
}

.filter-selects {
	display: flex;
	gap: 8px;
	align-items: center;
	position: relative;
}

.custom-dropdown {
	position: relative;
}

.dropdown-btn {
	padding: 6px 12px;
	border: 1px solid #dbdbdb;
	border-radius: 4px;
	background: #fff;
	font-size: 13px;
	color: #2f3438;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 4px;
}

/* 드롭다운 팝업 공통 */
.dropdown-menu-box {
	display: none;
	position: absolute;
	top: calc(100% + 4px);
	left: 0;
	background: #fff;
	border: 1px solid #dbdbdb;
	border-radius: 6px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
	z-index: 200;
}

/* 별점 드롭다운 UI */
.rating-menu {
	width: 180px;
	padding: 8px 0;
}

.rating-item {
	display: flex;
	align-items: center;
	padding: 8px 16px;
	cursor: pointer;
	font-size: 13px;
	color: #424242;
}

.rating-item:hover {
	background-color: #f7f9fa;
}

.rating-item input {
	margin-right: 8px;
	cursor: pointer;
}

/* 2단 옵션 드롭다운 UI */
.option-menu {
	width: 400px;
}

.option-menu-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 10px 14px;
	border-bottom: 1px solid #ededed;
}

.reset-btn {
	background: none;
	border: none;
	color: #c2c8cc;
	font-size: 12px;
	cursor: not-allowed;
	display: flex;
	align-items: center;
	gap: 4px;
}

.reset-btn.active {
	color: #35c5f0;
	cursor: pointer;
	font-weight: bold;
}

/* 1차 옵션 항목 푸른색 강조 */
.left-tab-item {
	padding: 10px 12px;
	font-size: 13px;
	cursor: pointer;
	display: flex;
	justify-content: space-between;
	align-items: center;
	border-bottom: 1px solid #f0f0f0;
	color: #2f3438;
}

.left-tab-item.active {
	background-color: #fff !important;
	font-weight: bold;
	color: #35c5f0;
}

.left-tab-item.has-selected {
	background-color: #e6f4fd;
	color: #008fcd;
	font-weight: bold;
}

.all-select-label {
	display: flex;
	align-items: center;
	gap: 8px;
	padding-bottom: 8px;
	margin-bottom: 8px;
	border-bottom: 1px dashed #e0e0e0;
	font-size: 13px;
	font-weight: bold;
	cursor: pointer;
	color: #2f3438;
}

/* 태그 영역 스타일 */
.selected-tags-bar {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	padding: 12px 0;
	min-height: 20px;
}

.filter-tag {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	background-color: #f0f9ff;
	color: #008fcd;
	border: 1px solid #c2e5fa;
	border-radius: 16px;
	padding: 4px 10px;
	font-size: 12px;
	font-weight: bold;
}

.filter-tag .btn-remove-tag {
	background: none;
	border: none;
	color: #008fcd;
	font-size: 12px;
	cursor: pointer;
	padding: 0;
	line-height: 1;
	font-weight: normal;
}

.filter-tag .btn-remove-tag:hover {
	color: #005680;
}
</style>

<div class="review-container" id="reviewContainer">

	<!-- Header 영역 -->
	<div class="review-header">
		<h3>
			리뷰 <span class="count">${reviewSummary.totalCount}</span>
		</h3>
		<button type="button" onclick="openReviewModal()">리뷰 남기기</button>
	</div>

	<!-- 별점 요약 카드 -->
	<div class="review-summary-card">
		<div class="summary-score-box">
			<span class="stars"> <c:choose>
					<c:when test="${reviewSummary.avgRating >= 4.5}">★★★★★</c:when>
					<c:when test="${reviewSummary.avgRating >= 3.5}">★★★★☆</c:when>
					<c:when test="${reviewSummary.avgRating >= 2.5}">★★★☆☆</c:when>
					<c:when test="${reviewSummary.avgRating >= 1.5}">★★☆☆☆</c:when>
					<c:otherwise>★☆☆☆☆</c:otherwise>
				</c:choose>
			</span> <span class="score">${reviewSummary.avgRating}</span>
		</div>

		<div class="summary-graph-box">
			<div class="graph-row">
				<span>5점</span>
				<div class="bar-bg">
					<div class="bar-fill" style="width: ${reviewSummary.rate5}%;"></div>
				</div>
				<span>${reviewSummary.count5}</span>
			</div>
			<div class="graph-row">
				<span>4점</span>
				<div class="bar-bg">
					<div class="bar-fill" style="width: ${reviewSummary.rate4}%;"></div>
				</div>
				<span>${reviewSummary.count4}</span>
			</div>
			<div class="graph-row">
				<span>3점</span>
				<div class="bar-bg">
					<div class="bar-fill" style="width: ${reviewSummary.rate3}%;"></div>
				</div>
				<span>${reviewSummary.count3}</span>
			</div>
			<div class="graph-row">
				<span>2점</span>
				<div class="bar-bg">
					<div class="bar-fill" style="width: ${reviewSummary.rate2}%;"></div>
				</div>
				<span>${reviewSummary.count2}</span>
			</div>
			<div class="graph-row">
				<span>1점</span>
				<div class="bar-bg">
					<div class="bar-fill" style="width: ${reviewSummary.rate1}%;"></div>
				</div>
				<span>${reviewSummary.count1}</span>
			</div>
		</div>
	</div>

	<!-- 정렬 및 옵션 필터 -->
	<div class="review-filter-bar">
		<div class="filter-tabs">
			<button type="button"
				class="js-review-action ${currentSort eq 'best' ? 'active' : ''}"
				data-page="1" data-sort="best">베스트순</button>
			<button type="button"
				class="js-review-action ${currentSort eq 'recent' ? 'active' : ''}"
				data-page="1" data-sort="recent">최신순</button>
		</div>

		<div class="filter-selects">
			<!-- 1. 별점 드롭다운 -->
			<div class="custom-dropdown" data-dropdown-id="rating">
				<button type="button" class="dropdown-btn js-dropdown-toggle">
					별점 <span>∨</span>
				</button>
				<div class="dropdown-menu-box rating-menu">
					<c:forEach var="star" begin="1" end="5" step="1">
						<c:set var="score" value="${6 - star}" />
						<label class="rating-item"> <input type="checkbox"
							name="ratings" value="${score}"
							class="js-filter-checkbox js-rating-checkbox"
							<c:if test="${not empty selectedRatings and selectedRatings.contains(score)}">checked</c:if> />
							<span> <c:forEach begin="1" end="${score}">★</c:forEach> <c:forEach
									begin="1" end="${5 - score}">☆</c:forEach>
						</span>
						</label>
					</c:forEach>
				</div>
			</div>

			<!-- 2. 2단 계층 옵션 드롭다운 -->
			<div class="custom-dropdown" data-dropdown-id="option">
				<button type="button" class="dropdown-btn js-dropdown-toggle">
					옵션 <span>∨</span>
				</button>

				<div class="dropdown-menu-box option-menu">
					<div class="option-menu-header">
						<span style="font-size: 13px; font-weight: bold;">옵션 선택</span>
						<button type="button" class="reset-btn js-reset-options">↻
							초기화</button>
					</div>

					<c:choose>
						<c:when test="${not empty optionFilterList}">
							<div style="display: flex; height: 260px;">
								<!-- 좌측: 1차 옵션 목록 -->
								<div class="tier-left"
									style="width: 40%; border-right: 1px solid #ededed; overflow-y: auto; background-color: #f7f9fa;">
									<c:forEach var="parentOpt" items="${optionFilterList}"
										varStatus="status">
										<div class="left-tab-item ${status.first ? 'active' : ''}"
											data-target="sub-group-${parentOpt.optionValueId}">
											<span>${parentOpt.optionValueName}</span> <span
												style="font-size: 10px; color: #bdbdbd;">&gt;</span>
										</div>
									</c:forEach>
								</div>

								<!-- 우측: 2차 옵션 그룹 목록 -->
								<div class="tier-right"
									style="width: 60%; padding: 12px; overflow-y: auto;">
									<c:forEach var="parentOpt" items="${optionFilterList}"
										varStatus="status">
										<div class="sub-option-group"
											id="sub-group-${parentOpt.optionValueId}"
											data-parent-id="${parentOpt.optionValueId}"
											data-parent-name="${parentOpt.optionValueName}"
											style="display: ${status.first ? 'block' : 'none'};">

											<label class="all-select-label"> <input
												type="checkbox" class="js-select-all-group" /> <span>전체선택</span>
											</label>

											<c:forEach var="subOpt" items="${parentOpt.subOptions}">
												<label
													style="display: flex; align-items: center; gap: 8px; margin-bottom: 10px; font-size: 13px; cursor: pointer;">
													<input type="checkbox" name="options"
													value="${subOpt.productOptionId}"
													data-name="${subOpt.subOptionName}"
													class="js-filter-checkbox js-option-checkbox"
													<c:if test="${not empty selectedOptions and selectedOptions.contains(subOpt.productOptionId)}">checked</c:if> />
													<span>${subOpt.subOptionName}</span>
												</label>
											</c:forEach>

										</div>
									</c:forEach>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<div
								style="padding: 16px; font-size: 13px; color: #757575; text-align: center;">선택
								가능한 옵션이 없습니다.</div>
						</c:otherwise>
					</c:choose>

				</div>
			</div>
		</div>
	</div>

	<!-- 선택된 필터 태그 노출 영역 -->
	<!-- <div class="selected-tags-bar" id="js-selected-tags"></div> -->
	<!-- 선택된 필터 태그 및 전체 초기화 버튼 영역 -->
	<div class="selected-tags-container">
		<div class="selected-tags-bar" id="js-selected-tags"></div>
		<button type="button" class="btn-clear-all js-clear-all-filters"
			id="js-btn-clear-all" style="display: none;">↻ 전체 초기화</button>
	</div>
	<div id="reviewListContainer">
		<jsp:include page="/WEB-INF/views/product/review/reviewItem.jsp" />
	</div>
</div>

<script>
(function() {
    var parentContainer = document.getElementById('detail-review') || document.getElementById('reviewContainer') || document.body;

    var activeDropdownId = null; 
    var currentActiveTabTarget = null;
    
    var selectedRatingsSet = new Set();
    var selectedOptionsSet = new Set();

    // UI 동기화 함수
    // UI 동기화 함수
    function syncFilterUIState() {
        if (!currentActiveTabTarget) {
            var firstTab = parentContainer.querySelector('.left-tab-item');
            if (firstTab) {
                currentActiveTabTarget = firstTab.getAttribute('data-target');
            }
        }
    	
        parentContainer.querySelectorAll('.js-rating-checkbox').forEach(function(chk) {
            if (selectedRatingsSet.has(chk.value)) {
                chk.checked = true;
            }
        });

        parentContainer.querySelectorAll('.js-option-checkbox').forEach(function(chk) {
            if (selectedOptionsSet.has(chk.value)) {
                chk.checked = true;
            }
        });

        var tagBar = parentContainer.querySelector('#js-selected-tags');
        var tagHtml = '';
        var hasAnyCheckedOption = false;

        parentContainer.querySelectorAll('.js-rating-checkbox:checked').forEach(function(chk) {
            var val = chk.value;
            tagHtml += '<span class="filter-tag">' + val + '점 ' +
                       '<button type="button" class="btn-remove-tag" data-type="rating" data-val="' + val + '">✕</button></span>';
        });

        parentContainer.querySelectorAll('.sub-option-group').forEach(function(group) {
            var parentId = group.getAttribute('data-parent-id');
            var parentName = group.getAttribute('data-parent-name') || '';
            var tabItem = parentContainer.querySelector('.left-tab-item[data-target="sub-group-' + parentId + '"]');
            
            var optionCheckboxes = group.querySelectorAll('.js-option-checkbox');
            var checkedOptions = group.querySelectorAll('.js-option-checkbox:checked');
            var selectAllCheckbox = group.querySelector('.js-select-all-group');

            checkedOptions.forEach(function(chk) {
                var optId = chk.value;
                var optName = chk.getAttribute('data-name') || '';
                var displayLabel = parentName ? parentName + ' / ' + optName : optName;

                tagHtml += '<span class="filter-tag">' + displayLabel + ' ' +
                           '<button type="button" class="btn-remove-tag" data-type="option" data-val="' + optId + '">✕</button></span>';
            });

            if (tabItem) {
                if (checkedOptions.length > 0) {
                    tabItem.classList.add('has-selected');
                    hasAnyCheckedOption = true;
                } else {
                    tabItem.classList.remove('has-selected');
                }
            }

            if (selectAllCheckbox && optionCheckboxes.length > 0) {
                selectAllCheckbox.checked = (optionCheckboxes.length === checkedOptions.length);
            }
        });

        if (tagBar) tagBar.innerHTML = tagHtml;

        // 전체 필터 초기화 버튼 노출 여부 판정
        var checkedRatingsCount = parentContainer.querySelectorAll('.js-rating-checkbox:checked').length;
        var checkedOptionsCount = parentContainer.querySelectorAll('.js-option-checkbox:checked').length;
        var hasFilter = (checkedRatingsCount > 0 || checkedOptionsCount > 0);

        var clearAllBtn = document.getElementById('js-btn-clear-all');
        if (clearAllBtn) {
            clearAllBtn.style.display = hasFilter ? 'inline-flex' : 'none';
        }
        
        // 옵션 드롭다운 내부 초기화 버튼 활성화 클래스 조작
        var resetBtn = parentContainer.querySelector('.js-reset-options');
        if (resetBtn) {
            if (checkedOptionsCount > 0) {
                resetBtn.classList.add('active');
            } else {
                resetBtn.classList.remove('active');
            }
        }

        if (activeDropdownId) {
            var targetDropdown = parentContainer.querySelector('.custom-dropdown[data-dropdown-id="' + activeDropdownId + '"]');
            if (targetDropdown) {
                var menu = targetDropdown.querySelector('.dropdown-menu-box');
                if (menu) menu.style.display = 'block';
            }
        }

        if (currentActiveTabTarget) {
            var activeTab = parentContainer.querySelector('.left-tab-item[data-target="' + currentActiveTabTarget + '"]');
            if (activeTab) {
                parentContainer.querySelectorAll('.left-tab-item').forEach(function(item) { item.classList.remove('active'); });
                activeTab.classList.add('active');

                parentContainer.querySelectorAll('.sub-option-group').forEach(function(g) { g.style.display = 'none'; });
                var targetGroup = parentContainer.querySelector('#' + currentActiveTabTarget);
                if (targetGroup) targetGroup.style.display = 'block';
            }
        }
    }
    
  	//태그의 [x] (btn-remove-tag) 버튼을 눌렀을 때의 처리 로직
    parentContainer.addEventListener('click', function(e) {
        var removeBtn = e.target.closest('.btn-remove-tag');
        if (!removeBtn) return;

        var type = removeBtn.getAttribute('data-type'); // 'rating' 또는 'option'
        var val = removeBtn.getAttribute('data-val');

        // 1. JS 내부 Set 데이터에서 제거
        if (type === 'rating') {
            selectedRatingsSet.delete(val);
        } else if (type === 'option') {
            selectedOptionsSet.delete(val);
        }

        // 2. 화면에 있는 실제 체크박스 찾아서 체크 해제하기 (핵심!)
        var targetCheckbox = parentContainer.querySelector('input.js-' + type + '-checkbox[value="' + val + '"]');
        if (targetCheckbox) {
            targetCheckbox.checked = false;
            // 체크박스의 change 이벤트나 연동된 데이터 갱신 함수가 있다면 여기서 호출
        }

        // 3. UI 동기화 함수 호출하여 태그바와 체크박스 상태 갱신
        syncFilterUIState();
    });
  	
    // 💥 [통합 이벤트 리스너] document 수준에서 모든 클릭을 감지하도록 보완
    document.addEventListener('click', function(e) {
        
        // 1. 도움돼요(좋아요) 토글 버튼 클릭
        var likeBtn = e.target.closest('.js-review-like');
        if (likeBtn) {
            e.stopPropagation();
            e.preventDefault();

            var reviewId = likeBtn.getAttribute('data-review-id');
            if (!reviewId) return;
            var memberId = ${memberId}; 
            var url = '${pageContext.request.contextPath}/helpCountToggle.htm?review_id=' + reviewId + '&member_id=' + memberId;

            fetch(url, {   method: 'GET',
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(function (response) {
                if (!response.ok) throw new Error('HTTP 에러: ' + response.status);
                return response.json();
            })
            .then(function (data) {
                var countSpan = likeBtn.querySelector('.count');
                if (countSpan) countSpan.textContent = data.helpCount;

                if (data.liked) {
                    likeBtn.classList.add('active');
                    likeBtn.style.background = '#e8f7fc';
                    likeBtn.style.borderColor = '#35c5f0';
                    likeBtn.style.color = '#35c5f0';
                } else {
                    likeBtn.classList.remove('active');
                    likeBtn.style.background = '#ffffff';
                    likeBtn.style.borderColor = '#e0e0e0';
                    likeBtn.style.color = '#424242';
                }
            })
            .catch(function (error) {
                console.error('도움돼요 토글 실패:', error);
                alert('처리에 실패했습니다: ' + error.message);
            });
            return;
        }

        // 2. 페이징 및 정렬 버튼 클릭 (💥 href="javascript:void(0)" 기본 동작 차단 추가!)
        // 2. 페이징 및 정렬 버튼 클릭
       // 2. 페이징 및 정렬 버튼 클릭
        // 2. 페이징 및 정렬 버튼 클릭
        var actionBtn = e.target.closest('.js-review-action');
        if (actionBtn) {
            e.stopPropagation();
            e.preventDefault(); 
            
            // 정렬 탭을 클릭한 경우 (.filter-tabs 내부)
            if (actionBtn.closest('.filter-tabs')) {
                var sortVal = actionBtn.getAttribute('data-sort');
                var sortButtons = parentContainer.querySelectorAll('.filter-tabs .js-review-action');
                sortButtons.forEach(function(btn) {
                    btn.classList.remove('active');
                });
                actionBtn.classList.add('active');
                
                triggerReviewFetch('1', sortVal);
                return;
            }

            // 페이징 번호 버튼을 클릭한 경우 (.pagination 내부)
            if (actionBtn.closest('.pagination')) {
                var pageVal = actionBtn.getAttribute('data-page');
                var sort = getCurrentSort(); // 현재 활성화된 정렬 상태 유지
                
                triggerReviewFetch(pageVal, sort);
                return;
            }
        }
        // 3. 전체 필터 초기화 버튼
        var clearAllBtn = e.target.closest('.js-clear-all-filters');
        if (clearAllBtn) {
            e.stopPropagation();
            selectedRatingsSet.clear();
            selectedOptionsSet.clear();
            parentContainer.querySelectorAll('.js-rating-checkbox, .js-option-checkbox, .js-select-all-group').forEach(function(chk) {
                chk.checked = false;
            });
            triggerReviewFetch('1', getCurrentSort());
            return;
        }

        // 4. 개별 태그 삭제 버튼
        var removeBtn = e.target.closest('.btn-remove-tag');
        if (removeBtn) {
            e.stopPropagation();
            var type = removeBtn.getAttribute('data-type');
            var val = removeBtn.getAttribute('data-val');

            if (type === 'rating') selectedRatingsSet.delete(val);
            else if (type === 'option') selectedOptionsSet.delete(val);

            triggerReviewFetch('1', getCurrentSort());
            return;
        }

        // 5. 드롭다운 토글 버튼
        var toggleBtn = e.target.closest('.js-dropdown-toggle');
        if (toggleBtn) {
            e.stopPropagation();
            var dropdownContainer = toggleBtn.closest('.custom-dropdown');
            var dropdownId = dropdownContainer.getAttribute('data-dropdown-id');
            var menu = toggleBtn.nextElementSibling;
            var isVisible = menu.style.display === 'block';

            parentContainer.querySelectorAll('.dropdown-menu-box').forEach(function(m) { m.style.display = 'none'; });

            if (!isVisible) {
                menu.style.display = 'block';
                activeDropdownId = dropdownId;
            } else {
                activeDropdownId = null;
            }
            return;
        }

        // 6. 1차 옵션 탭 선택
        var tabItem = e.target.closest('.left-tab-item');
        if (tabItem) {
            e.stopPropagation();
            parentContainer.querySelectorAll('.left-tab-item').forEach(function(item) { item.classList.remove('active'); });
            tabItem.classList.add('active');

            var targetId = tabItem.getAttribute('data-target');
            currentActiveTabTarget = targetId;

            parentContainer.querySelectorAll('.sub-option-group').forEach(function(group) { group.style.display = 'none'; });
            var targetGroup = parentContainer.querySelector('#' + targetId);
            if (targetGroup) targetGroup.style.display = 'block';
            return;
        }

        // 7. 옵션 드롭다운 초기화 버튼
        // 7. 옵션 드롭다운 초기화 버튼
        var resetBtn = e.target.closest('.js-reset-options');
        if (resetBtn) {
            e.stopPropagation();
            if (!resetBtn.classList.contains('active')) return;
            
            // 1. 메모리 셋 비우기
            selectedOptionsSet.clear();
            
            // 2. 해당 옵션 메뉴 내의 모든 체크박스 및 전체선택 체크 해제 (태그바 소멸을 위해 필수)
            var optionMenu = resetBtn.closest('.option-menu');
            if (optionMenu) {
                optionMenu.querySelectorAll('.js-option-checkbox, .js-select-all-group').forEach(function(chk) {
                    chk.checked = false;
                });
            }
            
            // 3. UI 동기화 호출 및 서버 리스트 갱신
            syncFilterUIState();
            triggerReviewFetch('1', getCurrentSort());
            return;
        }
        // 8. 바깥 클릭 시 드롭다운 닫기
        if (!e.target.closest('.custom-dropdown')) {
            parentContainer.querySelectorAll('.dropdown-menu-box').forEach(function(m) { m.style.display = 'none'; });
            activeDropdownId = null;
        }
    });

 // 체크박스 변경 이벤트 수정
    document.addEventListener('change', function(e) {
        // 1. 전체 선택 체크박스 조작 시
        if (e.target.classList.contains('js-select-all-group')) {
            var isChecked = e.target.checked;
            var group = e.target.closest('.sub-option-group');
            if (group) {
                group.querySelectorAll('.js-option-checkbox').forEach(function(chk) {
                    chk.checked = isChecked; // 화면상 체크박스 상태 즉시 반영
                    if (isChecked) {
                        selectedOptionsSet.add(chk.value);
                    } else {
                        selectedOptionsSet.delete(chk.value);
                    }
                });
            }
            syncFilterUIState(); // 태그 및 UI 즉시 갱신
            triggerReviewFetch('1', getCurrentSort());
            return;
        }

        // 2. 별점 체크박스 조작 시
        if (e.target.classList.contains('js-rating-checkbox')) {
            if (e.target.checked) selectedRatingsSet.add(e.target.value);
            else selectedRatingsSet.delete(e.target.value);
            
            syncFilterUIState();
            triggerReviewFetch('1', getCurrentSort());
            return;
        }

        // 3. 개별 옵션 체크박스 조작 시
        if (e.target.classList.contains('js-option-checkbox')) {
            if (e.target.checked) {
                selectedOptionsSet.add(e.target.value);
            } else {
                selectedOptionsSet.delete(e.target.value);
            }
            
            // 개별 체크박스가 해제되면 해당 그룹의 '전체선택' 체크박스 상태도 즉시 해제
            var group = e.target.closest('.sub-option-group');
            if (group) {
                var selectAllCheckbox = group.querySelector('.js-select-all-group');
                var optionCheckboxes = group.querySelectorAll('.js-option-checkbox');
                var checkedOptions = group.querySelectorAll('.js-option-checkbox:checked');
                if (selectAllCheckbox) {
                    selectAllCheckbox.checked = (optionCheckboxes.length === checkedOptions.length);
                }
            }

            syncFilterUIState(); // 태그바 및 UI 즉시 갱신
            triggerReviewFetch('1', getCurrentSort());
            return;
        }
    });

    function getCurrentSort() {
    	var activeSortBtn = parentContainer.querySelector('.js-review-action.active[data-sort]:not([data-page])') 
        || parentContainer.querySelector('.filter-tabs .active[data-sort]');
        return activeSortBtn ? activeSortBtn.getAttribute('data-sort') : 'best';
    }

 // 리뷰 AJAX Fetch 수정
    function triggerReviewFetch(page, sort) {
        var productId = `${product_id}`;
        var reqUrl = '${pageContext.request.contextPath}/review.htm?product_id=' + productId + '&sort=' + sort + '&page=' + page;

        selectedRatingsSet.forEach(function(val) {
            reqUrl += '&ratings=' + encodeURIComponent(val);
        });

        selectedOptionsSet.forEach(function(val) {
            reqUrl += '&options=' + encodeURIComponent(val);
        });

        fetch(reqUrl)
            .then(function(res) {
                if (!res.ok) throw new Error('Network error');
                return res.text();
            })
            .then(function(html) {
                var parser = new DOMParser();
                var doc = parser.parseFromString(html, 'text/html');
                
                // 서버 응답에서 리뷰 리스트 컨테이너만 추출
                var newReviewList = doc.querySelector('#reviewListContainer');
                var currentReviewList = parentContainer.querySelector('#reviewListContainer');
                
                if (currentReviewList && newReviewList) {
                    // 필터 바를 건드리지 않고 오직 리뷰 목록 영역만 교체
                    currentReviewList.innerHTML = newReviewList.innerHTML;
                } else {
                    parentContainer.innerHTML = html;
                }
                
                // 정렬 버튼 활성화 상태 갱신
                parentContainer.querySelectorAll('.js-review-action[data-sort]:not([data-page])').forEach(function(btn) {
                    if (btn.getAttribute('data-sort') === sort) {
                        btn.classList.add('active');
                    } else {
                        btn.classList.remove('active');
                    }
                });
                
                // 드롭다운을 닫지 않고 UI 태그 및 체크박스 상태만 동기화
                syncFilterUIState();
            })
            .catch(function(err) {
                console.error('리뷰 조회 실패:', err);
            });
    }
    // 초기 서버 세팅 로드
    <c:if test="${not empty selectedRatings}">
        <c:forEach var="r" items="${selectedRatings}">
            selectedRatingsSet.add('${r}');
        </c:forEach>
    </c:if>

    <c:if test="${not empty selectedOptions}">
        <c:forEach var="o" items="${selectedOptions}">
            selectedOptionsSet.add('${o}');
        </c:forEach>
    </c:if>

    syncFilterUIState();
})();
</script>
<script>
/* 관리자용 기능 이미지 숨김처리 (toggle) */
function toggleHideImage(reviewId, isHideImage) {
    // 1. 현재 상태가 1이면 0으로, 0이면 1로 반전 (토글 처리)
    const nextStatus = (isHideImage === 1) ? 0 : 1;

    fetch('${pageContext.request.contextPath}/hideImageToggle.htm', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify({
            reviewId: reviewId,
            isHideImage: nextStatus // 반전된 값 전달
        })
    })
    .then(response => {
        if (!response.ok) throw new Error('서버 응답 에러');
        return response.json();
    })
    .then(data => {
        if (data.success) {
            alert("변경되었습니다.");
            location.reload();
        } else {
            alert(data.message || "처리에 실패했습니다.");
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert("통신 중 오류가 발생했습니다.");
    });
}
</script>
<script>
//1. 답변 작성/수정 입력 폼 토글
function toggleReplyForm(reviewId) {
    var form = document.getElementById('reply-form-' + reviewId);
    if (form) {
        form.style.display = (form.style.display === 'none' || form.style.display === '') ? 'block' : 'none';
    }
}

// 2. 답변 저장 (등록 및 수정)
function saveAdminReply(reviewId) {
    var replyText = document.getElementById('reply-input-' + reviewId).value;
    if (!replyText.trim()) {
        alert("답변 내용을 입력해주세요.");
        return;
    }
    sendAdminReplyRequest(reviewId, replyText);
}

// 3. 답변 삭제
function deleteAdminReply(reviewId) {
    if (!confirm("답변을 삭제하시겠습니까?")) return;
    sendAdminReplyRequest(reviewId, ""); // 삭제 시 빈 문자열 전달
}

// 4. 서블릿 통신 함수 (URLSearchParams 사용으로 ObjectMapper 불필요)
function sendAdminReplyRequest(reviewId, adminReply) {
    var params = new URLSearchParams();
    params.append('reviewId', reviewId);
    params.append('adminReply', adminReply);

    fetch('${pageContext.request.contextPath}/adminReply.htm', {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: params
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert("처리되었습니다.");
            location.reload();
        } else {
            alert(data.message || "처리에 실패했습니다.");
        }
    })
    .catch(err => {
        console.error("Error:", err);
        alert("통신 중 오류가 발생했습니다.");
    });
}

</script>
<script>
//리뷰 작성 모달 열기
function openReviewModal() {
    var modal = document.getElementById('review-write-modal');
    if (modal) {
        modal.style.display = 'flex'; // 중앙 정렬 flex 활성화
    }
}

// 리뷰 작성 모달 닫기
function closeReviewModal() {
    var modal = document.getElementById('review-write-modal');
    if (modal) {
        modal.style.display = 'none'; // 숨김 처리
    }
}
</script>
