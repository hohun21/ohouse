package com.ohouse.product.review.handler;

import java.io.File;
import java.util.UUID;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.review.dto.ReviewDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  
    maxFileSize = 1024 * 1024 * 10,       
    maxRequestSize = 1024 * 1024 * 50     
)
public class WriteReviewHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        int memberId = 3; // 로그인 세션 연동 전 임시 회원 ID

        try {
        	String productIdStr = request.getParameter("productId");
        	String ratingStr = request.getParameter("rating");
        	String content = request.getParameter("content");

        	System.out.println(">>> productIdStr: " + productIdStr);
        	System.out.println(">>> ratingStr: " + ratingStr);
        	System.out.println(">>> content: " + content);

            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            String imageUrl = null;
            Part filePart = request.getPart("reviewImage"); 

            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName(); // 최신 내장 메서드로 변경
                
                if (originalFileName != null && !originalFileName.isEmpty()) {
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                    
                    // 👉 폴더 경로를 /upload/review 로 수정 완료
                    String uploadPath = request.getServletContext().getRealPath("/upload/review");
                    
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String filePath = uploadPath + File.separator + savedFileName;
                    filePart.write(filePath);

                    // 👉 DB에 저장될 웹 경로도 /upload/review 로 수정 완료
                    imageUrl = "/upload/review/" + savedFileName;
                }
            }

            ReviewDTO reviewDTO = new ReviewDTO();
            reviewDTO.setProductId(productId);
            reviewDTO.setMemberId(memberId);
            reviewDTO.setRating(rating);
            reviewDTO.setContent(content);

            boolean success = reviewService.registerReview(reviewDTO, imageUrl);

            if (success) {
                return "redirect:" + request.getContextPath() + "/product_detail.htm?productId=" + productId;
            } else {
                request.setAttribute("errorMessage", "리뷰 등록에 실패했습니다.");
                return "/WEB-INF/views/common/error.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("WriteReviewHandler 오류: " + e.getMessage());
        }
    }
}