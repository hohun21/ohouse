<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 리뷰 작성 모달 -->
<div id="review-write-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center; overflow-y: auto;">
    <div style="background: #fff; width: 520px; max-height: 90vh; overflow-y: auto; border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.15); box-sizing: border-box; position: relative;">
        
        <!-- 모달 Header -->
        <div style="display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #eaeaea;">
            <h2 style="margin: 0; font-size: 18px; font-weight: bold; color: #212121;">리뷰 남기기</h2>
            <button type="button" onclick="closeReviewModal()" style="background: none; border: none; font-size: 20px; cursor: pointer; color: #757575;">✕</button>
        </div>

        <!-- 모달 Form Body -->
        <form id="reviewWriteForm" action="${pageContext.request.contextPath}/writeReview.htm" method="post" enctype="multipart/form-data" style="padding: 24px;">
            
            <!-- 상품 정보 요약 Box -->
            <div style="display: flex; align-items: center; background: #f7f9fa; padding: 12px; border-radius: 6px; margin-bottom: 24px;">
                <img src="${product.imageUrl}" alt="상품 이미지" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px; margin-right: 12px; border: 1px solid #e0e0e0;">
                <div>
                    <div style="font-size: 11px; color: #828282; font-weight: bold;">${product.brandName}</div>
                    <div style="font-size: 13px; color: #212121; font-weight: 500; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 380px;">${product.productName}</div>
                </div>
            </div>

            <!-- 별점 선택 -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 15px; font-weight: bold; color: #212121; margin-bottom: 8px;">이 상품 어떠셨나요?</label>
                <div id="star-container" style="display: flex; gap: 4px; cursor: pointer;">
                    <span class="star" data-value="1" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="star" data-value="2" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="star" data-value="3" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="star" data-value="4" style="font-size: 32px; color: #e0e0e0;">★</span>
                    <span class="star" data-value="5" style="font-size: 32px; color: #e0e0e0;">★</span>
                </div>
                <!-- 서버로 넘어갈 별점 값 -->
                <input type="hidden" name="rating" id="ratingInput" value="5">
            </div>

            <!-- 사진 첨부 -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 15px; font-weight: bold; color: #212121; margin-bottom: 4px;">사진 첨부 (선택)</label>
                <span style="display: block; font-size: 12px; color: #828282; margin-bottom: 12px;">오늘의집에 올렸던 사진에서 고르거나 새로운 사진을 첨부해주세요. (최대 1장)</span>
                
                <!-- 파일 업로드 버튼 -->
                <label for="reviewImageFile" style="display: block; text-align: center; padding: 12px; border: 1px solid #35c5f0; border-radius: 4px; color: #35c5f0; font-size: 14px; font-weight: bold; cursor: pointer; background: #fff;">
                    📷 사진 첨부하기
                </label>
                <input type="file" id="reviewImageFile" name="reviewImage" accept="image/*" style="display: none;" onchange="previewImage(this);">
                
                <!-- 이미지 미리보기 영역 -->
                <div id="imagePreviewContainer" style="margin-top: 10px; display: none; position: relative; width: 80px; height: 80px;">
                    <img id="previewImg" src="" alt="미리보기" style="width: 100%; height: 100%; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;">
                    <button type="button" onclick="removeImage()" style="position: absolute; top: -6px; right: -6px; background: #333; color: #fff; border: none; border-radius: 50%; width: 20px; height: 20px; font-size: 10px; cursor: pointer;">✕</button>
                </div>
            </div>

            <!-- 후기 작성 -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 15px; font-weight: bold; color: #212121; margin-bottom: 8px;">후기 작성</label>
                <div style="border: 1px solid #dbdbdb; border-radius: 4px; padding: 12px; background: #fff;">
                    <textarea name="content" id="reviewContent" rows="5" maxlength="1000" onkeyup="checkTextLength(this)"
                              style="width: 100%; border: none; outline: none; resize: none; font-size: 14px; box-sizing: border-box;" 
                              placeholder="다른 분들이 도움을 받을 수 있도록 상품 후기를 솔직하게 공유해주세요 (최소 20자 이상)"></textarea>
                    <div style="text-align: right; font-size: 12px; color: #828282; margin-top: 4px;">
                        <span id="charCount">0</span>자
                    </div>
                </div>
            </div>

            <!-- 안내 문구 -->
            <div style="background: #f7f9fa; padding: 12px; border-radius: 4px; font-size: 11px; color: #757575; line-height: 1.5; margin-bottom: 24px;">
                • 상품을 직접 사용한 경우에만 리뷰 작성을 하실 수 있습니다.<br>
                • 비구매 상품 리뷰 포인트는 심사 후 지급됩니다. (영업일 기준 2~3일 소요)
            </div>

            <!-- 저장하기 버튼 -->
            <button type="submit" style="width: 100%; padding: 14px; background: #35c5f0; color: #fff; border: none; border-radius: 4px; font-size: 15px; font-weight: bold; cursor: pointer;">
                저장하기
            </button>
			<!-- 핸들러로 productId -->
			<input type="hidden" name="productId" value="3377041">
        </form>
    </div>
</div>

<!-- 모달 스크립트 기능 -->
<script>
    // 1. 별점 인터랙션 (기본 5점 세팅)
    document.addEventListener("DOMContentLoaded", function() {
        const stars = document.querySelectorAll("#star-container .star");
        const ratingInput = document.getElementById("ratingInput");
        
        // 초기 5점 세팅
        setStarRating(5);

        stars.forEach(star => {
            star.addEventListener("click", function() {
                const value = this.getAttribute("data-value");
                ratingInput.value = value;
                setStarRating(value);
            });
        });

        function setStarRating(count) {
            stars.forEach((star, index) => {
                if (index < count) {
                    star.style.color = "#35c5f0"; // 채워진 별 색상
                } else {
                    star.style.color = "#e0e0e0"; // 빈 별 색상
                }
            });
        }
    });

    // 2. 글자 수 카운팅
    function checkTextLength(textarea) {
        const charCount = document.getElementById("charCount");
        charCount.textContent = textarea.value.length;
    }

    // 3. 이미지 업로드 미리보기
    function previewImage(input) {
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById("previewImg").src = e.target.result;
                document.getElementById("imagePreviewContainer").style.display = "block";
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    // 4. 첨부 이미지 취소
    function removeImage() {
        const fileInput = document.getElementById("reviewImageFile");
        fileInput.value = "";
        document.getElementById("imagePreviewContainer").style.display = "none";
    }
</script>