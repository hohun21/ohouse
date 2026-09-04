package com.ohouse.product.review.dao;

import java.sql.Connection;
import java.util.List;

import com.ohouse.product.review.dto.OptionFilterDTO;
import com.ohouse.product.review.dto.ReviewDTO;
import com.ohouse.product.review.dto.ReviewPageDTO;
import com.ohouse.product.review.dto.ReviewSummaryDTO;

public interface ReviewDAO {
    
    // 1. 특정 상품의 리뷰 통계 (평균 별점, 개수)
    ReviewSummaryDTO selectReviewSummary(Connection conn, long productId) throws Exception;

	int getTotalRecords(Connection conn, ReviewPageDTO reqDTO) throws Exception;

	List<OptionFilterDTO> selectOptionFilterList(Connection conn, long productId) throws Exception;

	boolean isReviewLiked(Connection conn, int reviewId, int memberId);

	int insertReviewLike(Connection conn, int reviewId, int memberId);

	int deleteReviewLike(Connection conn, int reviewId, int memberId);

	int getHelpCount(Connection conn, int reviewId);

	List<ReviewDTO> selectReviewList(Connection conn, ReviewPageDTO reqDTO) throws Exception;

	int updateHideImage(Connection conn, int reviewId, int isHideImage) throws Exception;
	
	int updateAdminReply(Connection conn, int reviewId, String adminReply) throws Exception;

	int insertReviewImage(Connection conn, int reviewId, String imageUrl) throws Exception;

	int insertReview(Connection conn, ReviewDTO reviewDTO) throws Exception;

	int updateReview(Connection conn, ReviewDTO reviewDTO) throws Exception;

	int updateReviewImage(Connection conn, int reviewId, String imageUrl) throws Exception;

	int deleteReviewLikes(Connection conn, int reviewId) throws Exception;

	int deleteReviewImages(Connection conn, int reviewId) throws Exception;

	int deleteReview(Connection conn, int reviewId) throws Exception;

	int selectMyReviewTotalCount(Connection conn, int memberId) throws Exception;

	List<ReviewDTO> selectMyReviewList(Connection conn, ReviewPageDTO reqDTO) throws Exception;

	boolean hasUserPurchased(Connection conn, int memberId, long productId) throws Exception;

	int insertReview2(Connection conn, ReviewDTO reviewDTO) throws Exception; //backup

	boolean hasUserReviewedProduct(Connection conn, long memberId, long productId) throws Exception;

	ReviewDTO findLatestOrderInfo(Connection conn, int memberId, long productId) throws Exception;
}