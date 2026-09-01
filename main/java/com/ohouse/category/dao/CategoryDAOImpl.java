package com.ohouse.category.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.category.dto.CategoryDTO;

public class CategoryDAOImpl implements CategoryDAO {

    private Connection conn = null;

    public CategoryDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<CategoryDTO> getLeafCategories() throws SQLException {
        List<CategoryDTO> list = new ArrayList<>();
        
        String sql = "SELECT category_id, category_name "
                   + "FROM category "
                   + "WHERE category_level = 3 "
                   + "ORDER BY category_id";
        
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                CategoryDTO dto = new CategoryDTO();
                dto.setCategoryId(rs.getInt("category_id"));
                dto.setCategoryName(rs.getString("category_name"));
                
                list.add(dto);
            }
        }
        return list;
    }
}