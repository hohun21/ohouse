package com.ohouse.product.review.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
    private int startPage;     // 화면 출력 시작 번호
    private int endPage;       // 화면 출력 끝 번호
    private boolean prev;      // < 버튼 (1페이지면 false)
    private boolean next;      // > 버튼 (마지막 페이지면 false)
    
    private int currentPage;   // 현재 페이지
    private int totalPages;    // 전체 페이지 수
    private int total;         // 총 레코드 수
    
    private static final int BLOCK_SIZE = 9; // 오늘의집처럼 화면에 띄울 숫자 개수 (기본 9개)

    public PageDTO(int total, int currentPage, int numberPerPage) {
        this.total = total;
        this.currentPage = currentPage;
        
        // 1. 전체 페이지 수(totalPages) 계산
        this.totalPages = (int) Math.ceil((double) total / numberPerPage);
        if (this.totalPages == 0) this.totalPages = 1;

        // 2. 현재 페이지를 중앙(약 5번째)에 두기 위한 좌우 계산
        int half = BLOCK_SIZE / 2; // 4
        this.startPage = currentPage - half;
        this.endPage = currentPage + half;

        // 3. 시작 페이지 번호 보정
        if (this.startPage < 1) {
            this.endPage += (1 - this.startPage);
            this.startPage = 1;
        }

        // 4. 끝 페이지 번호 보정
        if (this.endPage > this.totalPages) {
            this.startPage -= (this.endPage - this.totalPages);
            this.endPage = this.totalPages;
        }

        // 5. 최소값 최종 방어선
        if (this.startPage < 1) {
            this.startPage = 1;
        }

        // 6. 오늘의집 방식 화살표 활성화 조건
        this.prev = (currentPage > 1);                  // 1페이지가 아니면 < 보임
        this.next = (currentPage < this.totalPages);    // 마지막 페이지가 아니면 > 보임
    }
}