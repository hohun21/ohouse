package com.ohouse.product.review.handler;

import java.io.PrintWriter;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminReplyHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        AuthUserDTO authUser = (AuthUserDTO) request.getSession().getAttribute("authUser");
        Integer memberId = 0;
        String id = "";
        String name = "";
        String role = "";
        
        if(authUser != null) {
        	memberId=authUser.getMemberId();
        	id=authUser.getId();
        	name=authUser.getName();
        	role = authUser.getRole();
        }
        
		boolean isAdmin = role.equals("ADMIN");
	     request.setAttribute("isAdmin", isAdmin);
	     
        if (!isAdmin) {
            out.write("{\"success\": false, \"message\": \"권한이 없습니다.\"}");
            return null;
        }

        try {
            // 2. 파라미터 수직 추출 (JSON 아님, 일반 폼 파라미터 수신)
            String reviewIdStr = request.getParameter("reviewId");
            String adminReply = request.getParameter("adminReply");

            if (reviewIdStr == null || reviewIdStr.isEmpty()) {
                out.write("{\"success\": false, \"message\": \"리뷰 번호가 없습니다.\"}");
                return null;
            }

            int reviewId = Integer.parseInt(reviewIdStr);

            // 3. 서비스 호출 (삭제의 경우 adminReply가 빈값이거나 null일 수 있음)
            boolean success = reviewService.saveAdminReply(reviewId, adminReply, isAdmin);

            // 4. JSON 형태의 문자열 직접 응답
            if (success) {
                out.write("{\"success\": true}");
            } else {
                out.write("{\"success\": false, \"message\": \"DB 처리에 실패했습니다.\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"서버 오류: " + e.getMessage() + "\"}");
        }

        return null;
    }
}