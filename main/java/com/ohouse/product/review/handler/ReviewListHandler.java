package com.ohouse.product.review.handler;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.review.dto.OptionFilterDTO; // 추가
import com.ohouse.product.review.dto.PageDTO;
import com.ohouse.product.review.dto.ReviewDTO;
import com.ohouse.product.review.dto.ReviewPageDTO;
import com.ohouse.product.review.dto.ReviewSummaryDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ReviewListHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        System.out.println(">>> ReviewListHandler 호출 성공!");

        // 1. 파라미터 수집
        String productIdParam = request.getParameter("product_id");
        String[] ratingParams = request.getParameterValues("ratings");
        String[] optionParams = request.getParameterValues("options");
        String pageParam = request.getParameter("page");
        String sortParam = request.getParameter("sort");
        
        
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
        
        
        // 2. 파싱 및 기본값 세팅
        int productId = (productIdParam != null && !productIdParam.isEmpty()) ? Integer.parseInt(productIdParam) : 0;
        
        List<Integer> ratings = null;
        if (ratingParams != null && ratingParams.length > 0) {
            ratings = Arrays.stream(ratingParams).map(Integer::parseInt).collect(Collectors.toList());
        }

        List<Integer> options = null;
        if (optionParams != null && optionParams.length > 0) {
            options = Arrays.stream(optionParams).map(Integer::parseInt).collect(Collectors.toList());
        }
        
        int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        String sort = (sortParam != null && !sortParam.isEmpty()) ? sortParam : "best";
        int numberPerPage = 5;

        if (productId > 0) {
            // 3. DTO 생성 (ratings, options 필터 추가)
            ReviewPageDTO reqDTO = ReviewPageDTO.builder()
                    .product_id(productId)
                    .currentPage(currentPage)
                    .numberPerPage(numberPerPage)
                    .sort(sort)
                    .ratings(ratings)
                    .options(options)
                    .member_id(memberId)
                    .build();

            // 4. Service 연동
            List<ReviewDTO> reviewList = reviewService.getReviewList(reqDTO);
            ReviewSummaryDTO reviewSummary = reviewService.getReviewSummary(productId);
            
            // 필터가 적용된 전체 레코드 수 조회
            int totalRecords = reviewService.getTotalRecords(reqDTO);

            // [추가] 2단 드롭다운 옵션 필터 데이터 조회
            List<OptionFilterDTO> optionFilterList = reviewService.getOptionFilterList(productId);

            // 5. PageDTO에 필터 반영된 totalRecords 전달
            PageDTO pageDTO = new PageDTO(totalRecords, currentPage, numberPerPage);
            
            // 6. Request Attribute 세팅
            request.setAttribute("reviewList", reviewList);
            request.setAttribute("reviewSummary", reviewSummary);
            request.setAttribute("pageDTO", pageDTO);
            request.setAttribute("currentSort", sort);
            request.setAttribute("product_id", productId);
            request.setAttribute("selectedRatings", ratings);
            request.setAttribute("selectedOptions", options);
            request.setAttribute("isAdmin", isAdmin);
            
            
            // [추가] JSP로 2단 옵션 데이터 전달
            request.setAttribute("optionFilterList", optionFilterList);
        }
        
     // 7. AJAX(Fetch) 요청 여부 확인
        String header = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(header);

        // 비동기(Fetch) 요청일 때는 리뷰 카드 반복문 조각만 리턴!
        if (isAjax) {
            return "/WEB-INF/views/product/review/reviewItem.jsp";
        }

        // 처음 페이지를 로드할 때는 전체 페이지 리턴
        return "/WEB-INF/views/product/review/reviewList.jsp";
    }
}