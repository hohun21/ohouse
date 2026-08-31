package com.ohouse.product.review.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReviewSummaryDTO {
    private double avgRating;   // 평균 별점 (예: 4.9)
    private int totalCount;     // 총 리뷰 수 (예: 23)
    
    // 개수
    private int count5;
    private int count4;
    private int count3;
    private int count2;
    private int count1;
    
    // 별점 그래프 퍼센트 계산값 (0~100)
    private int rate5;
    private int rate4;
    private int rate3;
    private int rate2;
    private int rate1;
}