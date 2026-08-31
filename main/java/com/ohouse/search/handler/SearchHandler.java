package com.ohouse.search.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.search.dto.ProductSearchDTO;
import com.ohouse.search.service.SearchService; // DAO 대신 Service 호출

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

public class SearchHandler implements CommandHandler {

    private SearchService searchService = new SearchService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String keyword = request.getParameter("keyword");

        if (keyword == null || keyword.trim().length() < 2) {
            request.setAttribute("keyword", keyword != null ? keyword : "");
            request.setAttribute("productList", null);
            return "/WEB-INF/views/store/search_result.jsp"; 
        }

        keyword = keyword.trim();

        searchService.registerKeyword(keyword);
        List<ProductSearchDTO> productList = searchService.getProductsByKeyword(keyword);

        request.setAttribute("keyword", keyword);
        request.setAttribute("productList", productList);

        return "/WEB-INF/views/store/search_result.jsp";
    }
}