package com.ohouse.seller.handler;

import java.util.List;

import com.ohouse.shopping.category.dto.CategoryDTO;
import com.ohouse.shopping.category.service.CategoryService;
import com.ohouse.shopping.category.dao.CategoryDAOImple;

import com.ohouse.common.handler.CommandHandler;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductAddHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        CategoryService categoryService = new CategoryService(new CategoryDAOImple());
        
        List<CategoryDTO> categoryList = categoryService.getAllLeafCategories();
        
        request.setAttribute("categoryList", categoryList);
        
        return "/WEB-INF/views/seller/seller_add.jsp";
    }
}