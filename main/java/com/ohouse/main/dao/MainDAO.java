package com.ohouse.main.dao;

import com.ohouse.search.dto.ProductSearchDTO;
import java.sql.Connection;
import java.util.List;

public interface MainDAO {
    List<ProductSearchDTO> selectRandomProducts(Connection conn) throws Exception;
}