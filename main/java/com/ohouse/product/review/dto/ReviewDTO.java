package com.ohouse.product.review.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReviewDTO {
    private int reviewId;            // REVIEW_ID (PK)
    private int productId;           // PRODUCT_ID (FK)
    private Integer memberId;            // MEMBER_ID (FK)
    private Integer productOptionId; // PRODUCT_OPTION_ID (FK, null 가능)
    
    private String productName;
    // MEMBER 테이블 JOIN 결과
    private String writerName;       // 작성자 이름/닉네임
    private String profileImg;       // 작성자 프로필 이미지
    
    // OPTION JOIN 결과
    private String optionName;       // 예: "[Option] 핑크파우더"
    
    private int rating;              // RATING (1~5)
    private String content;          // CONTENT
    private String regDate;          // REG_DATE (YYYY-MM-DD)
    private String editDate;         // EDIT_DATE (YYYY-MM-DD)
    private int helpCount;           // HELP_COUNT
    
    private String adminReply;       // ADMIN_REPLY
    private String adminReplyDate;   // 관리자 답글 작성일 (필요 시)
    
    private Integer isPurchased;         // IS_FROM_OH ('Y' / 'N')
    
    // 1:1 이미지 첨부 (1장 제한에 맞춤)
    private ReviewImageDTO reviewImage;
    
    private boolean liked; //좋아요체크여부 
    
    private Integer isHideImage;		//사진 숨김 처리 여부, 관리자 권한.
    
    private String orderDate;			//주문했나 안했나 여부
}