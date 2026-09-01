package com.ohouse.product.productDetail.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.productDetail.dto.ProductDetailDTO;
import com.ohouse.product.productDetail.service.ProductService;
import com.ohouse.product.review.dto.PageDTO;
import com.ohouse.product.review.dto.ReviewPageDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductDetailHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        System.out.println("1. ProductDetailHandler 진입");

        if (request.getMethod().equals("GET")) {

            String product_id = request.getParameter("product_id");
            System.out.println("2. product_id = " + product_id);

            long pId = Long.parseLong(product_id);

            ProductService psvc = new ProductService();

            System.out.println("3. Service 호출 전");

            ProductDetailDTO pdto = psvc.getProductDetail(pId);

            System.out.println("4. Service 호출 후");

            request.setAttribute("pdto", pdto);

            System.out.println("5. JSP forward");

            
            System.out.println("reviewservice 호출");

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
    		System.out.println(memberId+"&"+ id+"&"+  name+"&"+  role+"&"+ isAdmin);
    		ReviewService reviewService = new ReviewService();
    		
    		// 2. 리뷰 요청 DTO 생성
    		ReviewPageDTO reqDTO = ReviewPageDTO.builder()
    		        .product_id(pId)
    		        .currentPage(1)
    		        .numberPerPage(5)
    		        .member_id(memberId)
    		        .sort("best")
    		        .build();

    		// 3. jsp:include로 불러올 reviewList.jsp를 위해 request에 바인딩
    		request.setAttribute("memberId", memberId);
    		request.setAttribute("isAdmin", isAdmin);
    		request.setAttribute("reviewList", reviewService.getReviewList(reqDTO));
   
    		request.setAttribute("reviewSummary", reviewService.getReviewSummary(pId));
    		request.setAttribute("pageDTO", new PageDTO(reviewService.getReviewSummary(pId).getTotalCount(), 1, 5));
    		request.setAttribute("currentSort", "best");
    		request.setAttribute("product_id", pId);
    		request.setAttribute("optionFilterList", reviewService.getOptionFilterList(pId));
            
            return "/WEB-INF/views/product/product_detail.jsp";
        }

        return null;
    }
}