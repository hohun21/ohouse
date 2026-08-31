package com.ohouse.product.review.handler;

import java.io.BufferedReader;
import java.util.Map;

import com.google.gson.Gson;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HideImageToggleHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();
    private Gson gson = new Gson(); // 1. Gson 객체 생성

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
        if (!"POST".equalsIgnoreCase(req.getMethod())) {
            res.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        try {
        	
            // 2. JS가 보낸 JSON 스트림(Body)을 읽어서 Map 객체로 자동 변환!
            BufferedReader reader = req.getReader();
            Map<String, Object> data = gson.fromJson(reader, Map.class);

            // 3. Map에서 값 추출 (Double 형태로 들어오므로 int 변환)
            int reviewId = ((Number) data.get("reviewId")).intValue();
            int isHideImage = ((Number) data.get("isHideImage")).intValue();

            // 4. Service 호출
            boolean result = reviewService.updateHideImage(reviewId, isHideImage);

            // 5. 응답할 때도 Gson을 활용해 JSON 생성
            res.setContentType("application/json; charset=UTF-8");
            
            Map<String, Object> responseMap = Map.of("success", result);
            res.getWriter().write(gson.toJson(responseMap)); // {"success": true}

        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.setContentType("application/json; charset=UTF-8");
            
            Map<String, Object> errorMap = Map.of("success", false, "message", "서버 오류가 발생했습니다.");
            res.getWriter().write(gson.toJson(errorMap));
        }

        return null; 
    }
}