package com.ohouse.product.review.handler;

import java.io.PrintWriter;
import java.util.Map;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HelpCountToggleHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	AuthUserDTO authUser = (AuthUserDTO) request.getSession().getAttribute("authUser");
        if (authUser == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "LOGIN_REQUIRED");
            return null;
        }
        
        String reviewIdParam = request.getParameter("review_id");
        if (reviewIdParam == null || reviewIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "review_id가 누락되었습니다.");
            return null;
        }
        
        int reviewId = Integer.parseInt(reviewIdParam);
        
        // 💡 프론트 파라미터 대신 세션에서 직접 회원 번호를 가져와 사용
        int memberId = authUser.getMemberId();

        // 서비스 실행
        Map<String, Object> resultMap = reviewService.toggleHelpCount(reviewId, memberId);

        boolean isLiked = (Boolean) resultMap.get("isLiked");
        int helpCount = (Integer) resultMap.get("helpCount");

        response.setContentType("application/json; charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(String.format("{\"reviewId\": %d, \"liked\": %b, \"helpCount\": %d}", 
                                    reviewId, isLiked, helpCount));
            out.flush();
        }

        return null;
    }
}