package com.ohouse.search.dao;

import java.sql.Connection;
import java.util.List;

import com.ohouse.search.dto.KeyWordDTO;
import com.ohouse.search.dto.ProductSearchDTO;

public interface SearchDAO {
    void upsertKeyword(Connection conn, String keyword) throws Exception;
    
    List<ProductSearchDTO> selectProductsByKeyword(Connection conn, String keyword) throws Exception;
    
    void updateKeywordRanks(Connection conn) throws Exception;
    
    List<KeyWordDTO> selectTop10Keywords(Connection conn) throws Exception;
}