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
public class WriteReviewHandler implements CommandHandler {

	private ReviewService reviewService = new ReviewService();

	// 👉 외부 고정 경로 설정 (C드라이브에 폴더가 미리 생성되어 있어야 함)
	private static final String UPLOAD_DIR = "C:/ohouse_uploads/review";

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("UTF-8");
		AuthUserDTO authUser = (AuthUserDTO) request.getSession().getAttribute("authUser");
		Integer memberId = 0;
		String id = "";
		String name = "";
		String role = "";

		if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
			return "redirect:" + request.getContextPath() + "/login.htm";
		}

		if(authUser != null) {
			memberId = authUser.getMemberId();
			id = authUser.getId();
			name = authUser.getName();
			role = authUser.getRole();
		}
		boolean isAdmin = role.equals("ADMIN");
		System.out.println(memberId + "&" + id + "&" + name + "&" + role + "&" + isAdmin);

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
				String originalFileName = filePart.getSubmittedFileName();

				if (originalFileName != null && !originalFileName.isEmpty()) {
					String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;

					// 👉 외부 경로 객체 생성
					File uploadDir = new File(UPLOAD_DIR);
					if (!uploadDir.exists()) {
						uploadDir.mkdirs();
					}

					// 👉 외부 폴더에 파일 저장
					String filePath = UPLOAD_DIR + File.separator + savedFileName;
					filePart.write(filePath);

					// 👉 DB에 저장될 웹 경로 (server.xml의 /uploads 매핑과 일치)
					imageUrl = "/uploads/review/" + savedFileName;
				}
			}

			ReviewDTO reviewDTO = new ReviewDTO();
			reviewDTO.setProductId(productId);
			reviewDTO.setMemberId(memberId);
			reviewDTO.setRating(rating);
			reviewDTO.setContent(content);

			boolean success = reviewService.registerReview(reviewDTO, imageUrl);

			if (success) {
				return "redirect:" + request.getContextPath() + "/productDetail.htm?product_id=" + productId;
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