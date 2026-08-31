package com.ohouse.shopping.category.handler;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.productDetail.dto.ProductDTO;
import com.ohouse.product.productDetail.service.ProductService;
import com.ohouse.shopping.category.dao.CategoryDAO;
import com.ohouse.shopping.category.dao.CategoryDAOImple;
import com.ohouse.shopping.category.dto.CategoryDTO;
import com.ohouse.shopping.category.service.CategoryService;
import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.util.conn.JdbcUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CategoryHandler implements CommandHandler{

@Override
public String process(
        HttpServletRequest request,
        HttpServletResponse response
) throws Exception {

	    System.out.println("===== CategoryHandler.process() 실행 =====");
	
	    String categoryId = request.getParameter("category_id");
	
	    Connection conn = null;
	
	    try {
	        conn = ConnectionProvider.getConnection();
	        
	        System.out.println("===== DB 연결 확인 =====");
	        System.out.println("URL = " + conn.getMetaData().getURL());
	        System.out.println("USER = " + conn.getMetaData().getUserName());
	        try (var pstmt = conn.prepareStatement(
	                "SELECT COUNT(*) FROM category");
	             var rs = pstmt.executeQuery()) {

	            if (rs.next()) {
	                System.out.println("Java CATEGORY COUNT = " + rs.getInt(1));
	            }
	        }
	        
	        CategoryDAO dao = new CategoryDAOImple();
	        CategoryService categoryService = new CategoryService(dao);
	        ProductService productService = new ProductService();
	
	        // 전체 카테고리 조회
	        List<CategoryDTO> categories =
	                categoryService.getAllCategories(conn);
	
	        // 현재 선택된 카테고리 결정
	        int selectedCategoryId;
	
	        if (categoryId == null || categoryId.isEmpty()) {
	
	            selectedCategoryId = 10000000;
	
	        } else {
	
	            selectedCategoryId = Integer.parseInt(categoryId);
	        }
	
	        // 현재 카테고리 아래의 leaf 카테고리 조회
	        List<CategoryDTO> leafCategories =
	                categoryService.getLeafCategories(
	                        conn,
	                        selectedCategoryId
	                );
	
	        // 상품 조회에 사용할 카테고리 ID 목록
	        List<Integer> categoryIds = new ArrayList<>();
	
	        for (CategoryDTO category : leafCategories) {
	            categoryIds.add(category.getCategory_id());
	        }
	
	        // 상품 조회
	        List<ProductDTO> products =
	                productService.getProductListByCategories(
	                        conn,
	                        categoryIds
	                );
	
	        // JSP 전달
	        request.setAttribute("categories", categories);
	        request.setAttribute("leafCategories", leafCategories);
	        request.setAttribute("products", products);
	        request.setAttribute("selectedCategoryId", selectedCategoryId);
	
	        System.out.println("현재 카테고리 = " + selectedCategoryId);
	        System.out.println("전체 카테고리 수 = " + categories.size());
	        System.out.println("Leaf 카테고리 수 = " + leafCategories.size());
	        System.out.println("상품 조회 개수 = " + products.size());
	
	    } finally {
	        JdbcUtil.close(conn);
	    }
	
	    return "/WEB-INF/views/shopping/category/category.jsp";
	}
}