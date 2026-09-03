package com.ohouse.product.review.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeleteReviewHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        AuthUserDTO authUser = (AuthUserDTO) request.getSession().getAttribute("authUser");

        if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }

        
        
        
        try {
        	String reviewIdStr = request.getParameter("reviewId");
            int reviewId = Integer.parseInt(reviewIdStr);

            boolean success = reviewService.removeReview(reviewId);

            if (success) {
                // 사용자가 방금 있던 페이지(상품 상세 페이지)로 안전하게 되돌아감
                String referer = request.getHeader("referer");
                return "redirect:" + (referer != null ? referer : request.getContextPath() + "/index.htm");
            } else {
                request.setAttribute("errorMessage", "리뷰 삭제에 실패했습니다.");
                return "/WEB-INF/views/common/error.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("DeleteReviewHandler 오류: " + e.getMessage());
        }
    }
}