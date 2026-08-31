package com.ohouse.product.review.handler;

import java.io.PrintWriter;
import java.util.Map;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HelpCountToggleHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 파라미터 추출
        String reviewIdParam = request.getParameter("review_id");
        if (reviewIdParam == null || reviewIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "review_id가 누락되었습니다.");
            return null;
        }
        String memberIdParam = request.getParameter("member_id");
        int reviewId = Integer.parseInt(reviewIdParam);
        
        // 테스트용 회원 ID (추후 세션에서 동적으로 가져오도록 수정 가능)
        int memberId = (memberIdParam != null && !memberIdParam.isEmpty()) ? Integer.parseInt(memberIdParam) : 0;

        // 2. 서비스 실행
        Map<String, Object> resultMap = reviewService.toggleHelpCount(reviewId, memberId);

        boolean isLiked = (Boolean) resultMap.get("isLiked");
        int helpCount = (Integer) resultMap.get("helpCount");

        // 3. JSON 응답 출력
        response.setContentType("application/json; charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(String.format("{\"reviewId\": %d, \"liked\": %b, \"helpCount\": %d}", 
                                    reviewId, isLiked, helpCount));
            out.flush();
        }

        return null; // AJAX 요청이므로 View(JSP) 이동 없이 null 반환
    }
}