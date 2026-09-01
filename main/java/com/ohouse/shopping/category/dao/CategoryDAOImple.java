package com.ohouse.shopping.category.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.shopping.category.dto.CategoryDTO;

public class CategoryDAOImple implements CategoryDAO{
	
	// 전체 카테고리 정렬 순
	@Override
	public List<CategoryDTO> getAllCategories(Connection conn) throws SQLException {

	    String sql = """
	            SELECT category_id,
	                   category_name,
	                   parent_id,
	                   sort_order
	            FROM category
	            ORDER BY parent_id NULLS FIRST, sort_order
	            """;

	    List<CategoryDTO> list = new ArrayList<>();

	    try (PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {

	            Integer parentId = null;

	            if (rs.getObject("parent_id") != null) {
	                parentId = rs.getInt("parent_id");
	            }

	            CategoryDTO cdto = CategoryDTO.builder()
	                    .category_id(rs.getInt("category_id"))
	                    .category_name(rs.getString("category_name"))
	                    .parentId(parentId)
	                    .sortOrder(rs.getInt("sort_order"))
	                    .build();

	            list.add(cdto);
	        }
	    }

	    return list;
	}
	
	@Override
	public List<CategoryDTO> getLeafCategories(Connection conn ,int categoryId) throws SQLException {
		String sql = """
					 SELECT category_id,
		                   parent_id,
		                   category_name,
		                   sort_order
		            FROM (
		                SELECT c.*,
		                       CONNECT_BY_ISLEAF AS is_leaf
		                FROM category c
		                START WITH c.category_id = ?
		                CONNECT BY PRIOR c.category_id = c.parent_id
				        )
		            WHERE is_leaf = 1
		            ORDER BY sort_order
				     """;
		
		List<CategoryDTO> list = new ArrayList<>();
	
		try(PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setInt(1, categoryId);
			
			try(ResultSet rs = pstmt.executeQuery()){
							
			while (rs.next()) {
				Integer parentId = null;
				
				if (rs.getObject("parent_id")!= null) {
					parentId = rs.getInt("parent_id");
				}
				
				CategoryDTO cdto = CategoryDTO.builder()
											  .category_id(rs.getInt("category_id"))
											  .category_name(rs.getString("category_name"))
											  .parentId(parentId)
											  .sortOrder(rs.getInt("sort_order"))
											  .build();
				list.add(cdto);
				
				}
				
			}

		}
		
		return list;
	}
	
	
	
	@Override
	public List<CategoryDTO> viewCategory(
	        Connection conn,
	        long productId
	) throws SQLException {

	    String sql = """
	            SELECT category_id,
	                   category_name,
	                   parent_id,
	                   sort_order
	            FROM category
	            START WITH category_id = (
	                SELECT category_id
	                FROM product
	                WHERE product_id = ?
	            )
	            CONNECT BY PRIOR parent_id = category_id
	            ORDER BY sort_order
	            """;

	    List<CategoryDTO> list = new ArrayList<>();

	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setLong(1, productId);

	        try (ResultSet rs = pstmt.executeQuery()) {

	            while (rs.next()) {
	            	Integer parentId = null;
	            	
	            	if (rs.getObject("parent_id") != null) {
						parentId = rs.getInt("parent_id");
					}

	                CategoryDTO cdto = CategoryDTO.builder()
	                        .category_id(rs.getInt("category_id"))
	                        .category_name(rs.getString("category_name"))
	                        .parentId(parentId)
	                        .sortOrder(rs.getInt("sort_order"))
	                        .build();

	                list.add(cdto);
	            }
	        }
	    }

	    return list;
	}
	
}
