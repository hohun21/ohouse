package com.ohouse.member.handler;

import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.review.dto.PageDTO;
import com.ohouse.product.review.dto.ReviewDTO;
import com.ohouse.product.review.dto.ReviewPageDTO;
import com.ohouse.product.review.service.ReviewService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MyReviewListHandler implements CommandHandler {

    private ReviewService reviewService = new ReviewService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        Object sellerAuth = session.getAttribute("sellerAuth");
       
        if (authUser == null && sellerAuth == null) {
            System.out.println("접근 거부: 로그인이 필요합니다.");
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        int memberId = authUser.getMemberId();
        
        // 파라미터 수집
        String pageParam = request.getParameter("page");
        String sortParam = request.getParameter("sort");
        
        int currentPage = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        String sort = (sortParam != null && !sortParam.isEmpty()) ? sortParam : "recent";
        int numberPerPage = 5;

        // 1. 총 리뷰 개수 조회 (마이페이지용)
        int totalRecords = reviewService.getMyReviewTotalCount(memberId);
        PageDTO pageDTO = new PageDTO(totalRecords, currentPage, numberPerPage);

        // 2. 보유중인 ReviewPageDTO 스펙에 맞춰 빌드
        ReviewPageDTO reqDTO = ReviewPageDTO.builder()
                .member_id(memberId)
                .sort(sort)
                .currentPage(currentPage)
                .numberPerPage(numberPerPage)
                .build();

        // 3. 데이터 조회
        List<ReviewDTO> reviewList = reviewService.getMyReviewList(reqDTO);

        // 4. JSP 전달
        request.setAttribute("reviewList", reviewList);
        request.setAttribute("pageDTO", pageDTO);
        request.setAttribute("currentSort", sort);
        request.setAttribute("isAdmin", "ADMIN".equals(authUser.getRole()));

     // 헤더 대신 쿼리 파라미터로 AJAX 여부 확인
        String ajaxParam = request.getParameter("ajax");
        boolean isAjax = "true".equals(ajaxParam);

        if (isAjax) {
            return "/WEB-INF/views/member/ajaxMyReview.jsp"; // 탭 + 리스트 + 페이징 조각 파일
        }

        return "/WEB-INF/views/member/myReview.jsp"; // 최초 페이지 진입 시
    }
}