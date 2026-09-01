package com.ohouse.product.review.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReviewPageDTO {
	private long product_id;           // 상품 ID
    private String sort;             // 정렬 기준 ("recent": 최신순, "best": 별점/도움순)
    private int currentPage;         // 현재 페이지 번호
    private int numberPerPage;       // 한 페이지당 출력할 리뷰 수
    private int member_id;
    
    // 추가된 복수 필터링 필드
    private List<Integer> ratings;   // 선택된 별점 목록 (예: [5, 4])
    private List<Integer> options;   // 선택된 productOptionId 목록 (예: [91, 101])

    // 기본 생성자, Getter / Setter 작성 (Lombok 사용 시 @Data 또는 @Getter @Setter 추가)
    public List<Integer> getRatings() { return ratings; }
    public void setRatings(List<Integer> ratings) { this.ratings = ratings; }

    public List<Integer> getOptions() { return options; }
    public void setOptions(List<Integer> options) { this.options = options; }
}