// ReviewService.java (인터페이스 없이 바로 구현)
package com.ohouse.product.review.service;

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ohouse.product.review.dao.ReviewDAO;
import com.ohouse.product.review.dao.ReviewDAOImpl;
import com.ohouse.product.review.dto.OptionFilterDTO;
import com.ohouse.product.review.dto.ReviewDTO;
import com.ohouse.product.review.dto.ReviewPageDTO;
import com.ohouse.product.review.dto.ReviewSummaryDTO;
import com.ohouse.util.conn.ConnectionProvider;


public class ReviewService {

    private ReviewDAO reviewDao = new ReviewDAOImpl(); 

    public List<ReviewDTO> getReviewList(ReviewPageDTO reqDTO) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return reviewDao.selectReviewList(conn, reqDTO);
        } catch (Exception e) {
            throw new RuntimeException("리뷰 목록 조회 중 에러 발생", e);
        }
    }

    public ReviewSummaryDTO getReviewSummary(int productId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return reviewDao.selectReviewSummary(conn, productId);
        } catch (Exception e) {
            throw new RuntimeException("리뷰 요약 정보 조회 중 에러 발생", e);
        }
    }
    
 // ReviewService.java
    public int getTotalRecords(ReviewPageDTO reqDTO) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) { 
            return reviewDao.getTotalRecords(conn, reqDTO);
        }
    }
    public List<OptionFilterDTO> getOptionFilterList(int productId) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) { 
            return reviewDao.selectOptionFilterList(conn, productId);
        }
    }
    
 // 도움돼요 토글 처리 (좋아요 추가/삭제 및 최신 개수 반환)
    public Map<String, Object> toggleHelpCount(int reviewId, int memberId) {
        Map<String, Object> resultMap = new HashMap<>();
        
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false); // 트랜잭션 시작

            boolean isLiked = reviewDao.isReviewLiked(conn, reviewId, memberId);

            if (isLiked) {
                reviewDao.deleteReviewLike(conn, reviewId, memberId);
                resultMap.put("isLiked", false);
            } else {
                reviewDao.insertReviewLike(conn, reviewId, memberId);
                resultMap.put("isLiked", true);
            }

            conn.commit(); // 커밋

            // REVIEW_LIKE 기준 최신 개수 집계
            int updatedCount = reviewDao.getHelpCount(conn, reviewId);
            resultMap.put("helpCount", updatedCount);

        } catch (Exception e) {
            throw new RuntimeException("도움돼요 토글 처리 중 에러 발생", e);
        }

        return resultMap;
    }
 // 리뷰 이미지 숨김/해제 토글 서비스
    public boolean updateHideImage(int reviewId, int isHideImage) {
        Connection conn = null;

        try {
            conn = ConnectionProvider.getConnection();
            
            // DAO 메서드에 conn 전달 (executeUpdate 시 자동 커밋됨)
            int rowCount = reviewDao.updateHideImage(conn, reviewId, isHideImage);

            return rowCount > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
    
    public boolean saveAdminReply(int reviewId, String adminReply, boolean isAdmin) {
        if (!isAdmin) {
            throw new SecurityException("관리자 권한이 없습니다.");
        }

        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            int result = reviewDao.updateAdminReply(conn, reviewId, adminReply);

            if (result > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
            throw new RuntimeException(e);
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ex) {}
        }
    }
    
    /**
     * 리뷰 등록 및 이미지 URL 저장 통합 비즈니스 로직
     */
    public boolean registerReview(ReviewDTO reviewDTO, String imageUrl) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // 1. 리뷰 본문 저장 후 생성된 review_id 반환 받기
            int generatedReviewId = reviewDao.insertReview(conn, reviewDTO);

            if (generatedReviewId <= 0) {
                conn.rollback();
                return false;
            }

            // 2. 이미지가 첨부된 경우에만 이미지 URL 저장 테이블에 INSERT
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                int imageResult = reviewDao.insertReviewImage(conn, generatedReviewId, imageUrl);
                if (imageResult <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            // 모든 작업 성공 시 커밋
            conn.commit();
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            }
            throw new RuntimeException("리뷰 등록 중 오류 발생: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception ex) { ex.printStackTrace(); }
            }
        }
    }
    
}