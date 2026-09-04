package com.ohouse.product.review.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ReviewCheckHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        int memberId = authUser.getMemberId();
        
        String productIdParam = request.getParameter("product_id");
        long productId = (productIdParam != null && !productIdParam.isEmpty()) ? Long.parseLong(productIdParam) : 0;

        boolean hasReviewed = reviewService.checkAndValidateUserReview(memberId, productId);

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"hasReviewed\": " + hasReviewed + "}");
        
        return null; // 뷰를 리턴하지 않고 JSON 응답만 직접 보냄
    }
}