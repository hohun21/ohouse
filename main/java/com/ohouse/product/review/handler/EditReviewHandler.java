package com.ohouse.product.review.handler;

import java.net.URI;
import java.util.UUID;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.review.dto.ReviewDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  
    maxFileSize = 1024 * 1024 * 10,       
    maxRequestSize = 1024 * 1024 * 50     
)
public class EditReviewHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    // 👉 R2 공용 설정값 연동
    private static final String R2_ENDPOINT = "https://c118a7efdddd35d3edac1db3a63ed76d.r2.cloudflarestorage.com";
    private static final String R2_ACCESS_KEY = "8f8a91958a3c06d4ce11ba80f5d60e2f";
    private static final String R2_SECRET_KEY = "5ab97a22e5baa3fe630165a9e770f0eada870d8672aaea80d3258ccbc2440667";
    private static final String R2_BUCKET = "productimage";
    private static final String R2_PUBLIC_URL = "https://pub-3490b121289f419194b634a98c9d4ba5.r2.dev";

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
                    String objectKey = "reviews/" + savedFileName;

                    // 👉 스트림 재사용 오류 방지를 위해 바이트 배열로 미리 읽기
                    byte[] fileBytes;
                    try (java.io.InputStream is = filePart.getInputStream()) {
                        fileBytes = is.readAllBytes();
                    }

                    S3Configuration s3Configuration = S3Configuration.builder()
                            .chunkedEncodingEnabled(false)
                            .build();

                    try (S3Client s3Client = S3Client.builder()
                            .endpointOverride(URI.create(R2_ENDPOINT))
                            .region(Region.of("auto"))
                            .credentialsProvider(
                                    StaticCredentialsProvider.create(
                                            AwsBasicCredentials.create(R2_ACCESS_KEY, R2_SECRET_KEY)
                                    )
                            )
                            .serviceConfiguration(s3Configuration)
                            .build()) {

                        PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                                .bucket(R2_BUCKET)
                                .key(objectKey)
                                .contentType(filePart.getContentType())
                                .build();

                        // 👉 바이트 배열 기반 RequestBody 적용
                        s3Client.putObject(
                                putObjectRequest,
                                RequestBody.fromBytes(fileBytes)
                        );

                        // 👉 R2 퍼블릭 URL 조합
                        imageUrl = R2_PUBLIC_URL + "/" + objectKey;
                    }
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