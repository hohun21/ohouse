<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 리뷰 수정 모달 -->
<div id="reviewEditModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center; overflow-y: auto;">
    <div style="background: #fff; width: 520px; max-height: 90vh; overflow-y: auto; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); box-sizing: border-box; position: relative;">
        
        <!-- 모달 Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #eaeaea;">
            <h2 style="margin: 0; font-size: 18px; font-weight: bold; color: #212121;">리뷰 수정</h2>
            <button type="button" onclick="closeEditReviewModal()" style="background: none; border: none; font-size: 20px; cursor: pointer; color: #757575;">✕</button>
        </div>

        <!-- 모달 Form Body -->
        <form id="editReviewForm" action="${pageContext.request.contextPath}/editReview.htm" method="post" enctype="multipart/form-data" style="padding: 24px;">
            
            <!-- 숨어있는 식별 번호들 -->
            <input type="hidden" id="editReviewId" name="reviewId">
            <%-- <input type="hidden" name="productId" value="${pdto.productDTO.product_id}"> --%>
            <input type="hidden" id="editProductId" name="productId">
            <input type="hidden" id="editImageUrl" name="existingImageUrl">

            <!-- 상품 정보 요약 Box -->
            <div style="display: flex; align-items: center; background: #f7f9fa; padding: 12px; border-radius: 6px; margin-bottom: 24px;">
                <img src="${pdto.imageDTOList[0].image_url}" alt="상품 이미지" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px; margin-right: 12px; border: 1px solid #e0e0e0;">
                <div>
                    <div style="font-size: 11px; color: #828282; font-weight: bold;">${pdto.productDTO.brand_name}</div>
                    <div style="font-size: 13px; color: #212121; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 380px;">${pdto.productDTO.product_name}</div>
                </div>
            </div>

            <!-- 별점 선택 -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 15px; font-weight: bold; color: #212121; margin-bottom: 8px;">이 상품 어떠셨나요?</label>
                <div id="edit-star-container" style="display: flex; gap: 4px; cursor: pointer;">
                    <span class="edit-star" data-value="1" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="edit-star" data-value="2" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="edit-star" data-value="3" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="edit-star" data-value="4" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="edit-star" data-value="5" style="font-size: 32px; color: #e0e0e0;">★</span>
                </div>
                <!-- 서버로 넘어갈 별점 값 -->
                <input type="hidden" name="rating" id="editRatingInput" value="5">
            </div>

            <!-- 사진 첨부 -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 15px; font-weight: bold; color: #212121; margin-bottom: 4px;">사진 첨부 (선택)</label>
                <span style="display: block; font-size: 12px; color: #828282; margin-bottom: 12px;">새로운 사진을 첨부하면 기존 사진이 교체됩니다. (최대 1장)</span>
                
                <!-- 파일 업로드 버튼 -->
                <label for="editReviewImageFile" style="display: block; text-align: center; padding: 12px; border: 1px solid #35c5f0; border-radius: 4px; color: #35c5f0; font-size: 14px; font-weight: bold; cursor: pointer; background: #fff;">
                    📷 사진 변경하기
                </label>
                <input type="file" id="editReviewImageFile" name="reviewImage" accept="image/*" style="display: none;" onchange="previewEditImage(this);">
                
                <!-- 이미지 미리보기 영역 -->
                <div id="editImagePreviewContainer" style="margin-top: 10px; display: none; position: relative; width: 80px; height: 80px;">
                    <img id="editPreviewImg" src="" alt="미리보기" style="width: 100%; height: 100%; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">
                    <button type="button" onclick="removeEditImage()" style="position: absolute; top: -6px; right: -6px; background: #333; color: #fff; border: none; border-radius: 50%; width: 20px; height: 20px; font-size: 10px; cursor: pointer;">✕</button>
                </div>
            </div>

            <!-- 후기 작성 -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 15px; font-weight: bold; color: #212121; margin-bottom: 8px;">후기 작성</label>
                <div style="border: 1px solid #dbdbdb; border-radius: 4px; padding: 12px; background: #fff;">
                    <textarea name="content" id="editContent" rows="5" maxlength="1000" onkeyup="checkEditTextLength(this)"
                              style="width: 100%; border: none; outline: none; resize: none; font-size: 14px; box-sizing: border-box;" 
                              placeholder="다른 분들이 도움을 받을 수 있도록 상품 후기를 솔직하게 공유해주세요 (최소 20자 이상)"></textarea>
                    <div style="text-align: right; font-size: 12px; color: #828282; margin-top: 4px;">
                        <span id="editCharCount">0</span>자
                    </div>
                </div>
            </div>

            <!-- 안내 문구 -->
            <div style="background: #f7f9fa; padding: 12px; border-radius: 4px; font-size: 11px; color: #757575; line-height: 1.5; margin-bottom: 24px;">
                • 상품을 직접 사용한 경우에만 리뷰 수정이 가능합니다.<br>
                • 부적절한 내용은 관리자에 의해 삭제될 수 있습니다.
            </div>

            <!-- 수정하기 버튼 -->
            <button type="submit" style="width: 100%; padding: 14px; background: #35c5f0; color: #fff; border: none; border-radius: 4px; font-size: 15px; font-weight: bold; cursor: pointer;">
                수정하기
            </button>
            
        </form>
    </div>
</div>

<!-- 모달 스크립트 기능 -->
<script>
    // 1. 별점 인터랙션 바인딩
    const editStars = document.querySelectorAll("#edit-star-container .edit-star");
    const editRatingInput = document.getElementById("editRatingInput");

    editStars.forEach(star => {
        star.addEventListener("click", function() {
            const value = this.getAttribute("data-value");
            editRatingInput.value = value;
            setEditStarRating(value);
        });
    });

    function setEditStarRating(count) {
        editStars.forEach((star, index) => {
            if (index < count) {
                star.style.color = "#35c5f0"; // 채워진 별 색상
            } else {
                star.style.color = "#e0e0e0"; // 빈 별 색상
            }
        });
    }

    // 2. 글자 수 카운팅
    function checkEditTextLength(textarea) {
        const editCharCount = document.getElementById("editCharCount");
        editCharCount.textContent = textarea.value.length;
    }

    // 3. 이미지 업로드 미리보기
    function previewEditImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById("editPreviewImg").src = e.target.result;
                document.getElementById("editImagePreviewContainer").style.display = "block";
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 4. 첨부 이미지 취소
    function removeEditImage() {
        const fileInput = document.getElementById("editReviewImageFile");
        fileInput.value = "";
        document.getElementById("editImagePreviewContainer").style.display = "none";
        document.getElementById("editImageUrl").value = ""; // 기존 이미지 URL도 초기화
    }

    // 5. 모달 오픈 함수 (기존 데이터 세팅)
    window.openEditReviewModal = function(reviewId, rating, content, imageUrl) {
        document.getElementById("editReviewId").value = reviewId;
        document.getElementById("editRatingInput").value = rating;
        setEditStarRating(rating); // 별점 아이콘 색상 동기화
        
        const urlParams = new URLSearchParams(window.location.search);
        const productId = urlParams.get("product_id") || urlParams.get("productId");
        document.getElementById("editProductId").value = productId;
        
        const contentArea = document.getElementById("editContent");
        contentArea.value = content;
        checkEditTextLength(contentArea); // 글자수 카운트 동기화
        
        // 기존 이미지 처리
        const imgContainer = document.getElementById("editImagePreviewContainer");
        const previewImg = document.getElementById("editPreviewImg");
        const imgUrlInput = document.getElementById("editImageUrl");
        
        if (imageUrl && imageUrl !== "null" && imageUrl !== "") {
            imgUrlInput.value = imageUrl;
            previewImg.src = imageUrl;
            imgContainer.style.display = "block";
        } else {
            imgUrlInput.value = "";
            previewImg.src = "";
            imgContainer.style.display = "none";
        }

        // 파일 인풋 초기화
        document.getElementById("editReviewImageFile").value = "";

        // 모달 띄우기
        document.getElementById("reviewEditModal").style.display = "flex";
    };

    // 6. 모달 닫기 함수
    window.closeEditReviewModal = function() {
        document.getElementById("reviewEditModal").style.display = "none";
    };

    // 7. 이벤트 위임 (수정 버튼 클릭 연동)
    document.addEventListener("click", function(event) {
        const editBtn = event.target.closest(".js-edit-review-btn");
        if (editBtn) {
            const reviewId = editBtn.getAttribute("data-review-id");
            const rating = editBtn.getAttribute("data-rating");
            const content = editBtn.getAttribute("data-content");
            const imageUrl = editBtn.getAttribute("data-image-url");
            
            window.openEditReviewModal(reviewId, rating, content, imageUrl);
        }
    });
</script>