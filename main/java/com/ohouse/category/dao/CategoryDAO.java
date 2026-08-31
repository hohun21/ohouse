package com.ohouse.category.dao;

import java.sql.SQLException;
import java.util.List;

import com.ohouse.category.dto.CategoryDTO;

public interface CategoryDAO {
    // 소분류 카테고리 목록을 가져오는 메서드
    List<CategoryDTO> getLeafCategories() throws SQLException;
}