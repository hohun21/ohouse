package com.ohouse.product.review.handler;

import java.io.File;
import java.util.UUID;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
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
public class EditReviewHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();
    private static final String UPLOAD_DIR = "C:/ohouse_uploads/review";

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        AuthUserDTO authUser = (AuthUserDTO) request.getSession().getAttribute("authUser");
        
        if (authUser == null) {
            return "redirect:" + request.getContextPath() + "/member/login.htm";
        }

        try {
            String reviewIdStr = request.getParameter("reviewId");
            String productIdStr = request.getParameter("productId");
            String ratingStr = request.getParameter("rating");
            String content = request.getParameter("content");

            int reviewId = Integer.parseInt(reviewIdStr);
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            String imageUrl = null;
            Part filePart = request.getPart("reviewImage");

            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = filePart.getSubmittedFileName();
                
                if (originalFileName != null && !originalFileName.isEmpty()) {
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                    
                    File uploadDir = new File(UPLOAD_DIR);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String filePath = UPLOAD_DIR + File.separator + savedFileName;
                    filePart.write(filePath);

                    imageUrl = "/uploads/review/" + savedFileName;
                }
            }

            ReviewDTO reviewDTO = new ReviewDTO();
            reviewDTO.setReviewId(reviewId);
            reviewDTO.setMemberId(authUser.getMemberId());
            reviewDTO.setRating(rating);
            reviewDTO.setContent(content);

            boolean success = reviewService.modifyReview(reviewDTO, imageUrl);

            if (success) {
                return "redirect:" + request.getContextPath() + "/product/productDetail.htm?product_id=" + productId;
            } else {
                request.setAttribute("errorMessage", "리뷰 수정에 실패했습니다.");
                return "/WEB-INF/views/common/error.jsp";
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("EditReviewHandler 오류: " + e.getMessage());
        }
    }
}