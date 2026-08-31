package com.ohouse.category.service;

import java.sql.Connection;
import java.util.List;

import com.ohouse.category.dao.CategoryDAO;
import com.ohouse.category.dao.CategoryDAOImpl;
import com.ohouse.category.dto.CategoryDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class CategoryService {

    public List<CategoryDTO> getLeafCategories() {
        Connection conn = null;
        List<CategoryDTO> list = null;

        try {
            conn = ConnectionProvider.getConnection();
            
            CategoryDAO dao = new CategoryDAOImpl(conn);
            
            list = dao.getLeafCategories();
            
        } catch (Exception e) {
            System.out.println("카테고리 목록 조회 중 에러 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
        
        return list;
    }
}