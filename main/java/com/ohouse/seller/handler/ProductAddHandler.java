package com.ohouse.seller.handler;

import java.util.List;

import com.ohouse.category.dto.CategoryDTO;
import com.ohouse.category.service.CategoryService;
import com.ohouse.common.handler.CommandHandler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductAddHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        CategoryService categoryService = new CategoryService();
        List<CategoryDTO> categoryList = categoryService.getLeafCategories();
        
        request.setAttribute("categoryList", categoryList);
        
        return "/WEB-INF/views/seller/seller_add.jsp";
    }
}