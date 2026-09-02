package com.ohouse.shopping.category.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.shopping.category.dto.CategoryDTO;

public interface CategoryDAO {
	// 상품 상세  -> 상위 카테고리 조회
	List<CategoryDTO> viewCategory(
			Connection conn,
			long productId
			) throws SQLException;
	
	// 현재 카테고리 -> 최하위 카테고리 조회
	List<CategoryDTO> getLeafCategories(Connection conn, int categoryId) throws SQLException;
	
	// 카테고리 좌측 메뉴open용
	List<CategoryDTO> getAllCategories(Connection conn) throws SQLException;
	
	List<CategoryDTO> getRootCategories(Connection conn)
	        throws SQLException;
	
	List<CategoryDTO> getAllLeafCategories(Connection conn) throws SQLException;
}
