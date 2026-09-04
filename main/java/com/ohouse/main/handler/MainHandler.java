package com.ohouse.main.handler;

import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.main.service.MainService;
import com.ohouse.search.dto.ProductSearchDTO;
import com.ohouse.shopping.category.dao.CategoryDAOImple;
import com.ohouse.shopping.category.dto.CategoryDTO;
import com.ohouse.shopping.category.service.CategoryService;
import com.ohouse.shopping.category.dao.CategoryDAO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MainHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        MainService mainService = new MainService();
        
        List<ProductSearchDTO> randomProductList = mainService.getRandomProductList();
        
        request.setAttribute("randomProductList", randomProductList);
        request.setAttribute("activeMenu", "home");
        
        // 대분류 조회
        CategoryDAO categoryDAO = new CategoryDAOImple();
        CategoryService categoryService =
                new CategoryService(categoryDAO);

        List<CategoryDTO> rootCategories =
                categoryService.getRootCategories();

        request.setAttribute("rootCategories", rootCategories);
        
        CategoryDTO furnitureCategory = null;
        CategoryDTO storageCategory = null;
        CategoryDTO kitchenCategory = null;

        for (CategoryDTO category : rootCategories) {

            if ("가구".equals(category.getCategory_name())) {
                furnitureCategory = category;

            } else if ("수납/정리".equals(category.getCategory_name())) {
                storageCategory = category;

            } else if ("주방용품".equals(category.getCategory_name())) {
                kitchenCategory = category;
            }
        }

        request.setAttribute("furnitureCategory", furnitureCategory);
        request.setAttribute("storageCategory", storageCategory);
        request.setAttribute("kitchenCategory", kitchenCategory);
        
        return "/WEB-INF/views/main/main.jsp";
    }
}