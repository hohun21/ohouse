package com.ohouse.product.review.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor

//ReviewSearchDTO (또는 기존 검색/페이징 조건 DTO)
public class ReviewSearchDTO {
 private Long productId;
 private String sort;        // best, recent
 private List<Integer> ratings; // 선택된 별점 목록 (예: [5, 4])
 private List<Integer> options;    // 선택된 product_option_id 목록 (예: [91, 101])
 private int page;
 private int pageSize;
 
 // Getter / Setter
}