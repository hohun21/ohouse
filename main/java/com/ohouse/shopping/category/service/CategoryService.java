package com.ohouse.shopping.category.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.shopping.category.dao.CategoryDAO;
import com.ohouse.shopping.category.dto.CategoryDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class CategoryService {

    private final CategoryDAO dao;

    public CategoryService(CategoryDAO dao) {
        this.dao = dao;
    }

    // 전체 카테고리 조회
    public List<CategoryDTO> getAllCategories(
            Connection conn
    ) throws SQLException {

        return dao.getAllCategories(conn);
    }
    
    public List<CategoryDTO> getRootCategories()
            throws Exception {

        try (Connection conn = ConnectionProvider.getConnection()) {
            return dao.getRootCategories(conn);
        }
    }

    // 현재 카테고리 하위의 leaf 카테고리 조회
    public List<CategoryDTO> getLeafCategories(
            Connection conn,
            int categoryId
    ) throws SQLException {

        return dao.getLeafCategories(conn, categoryId);
    }

    // 상품 상세 → 상품의 카테고리 경로 조회
    public List<CategoryDTO> viewCategory(
            Connection conn,
            long productId
    ) throws SQLException {

        return dao.viewCategory(conn, productId);
    }
}