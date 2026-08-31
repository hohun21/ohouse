package com.ohouse.search.service;

import java.sql.Connection;
import java.util.List;

import com.ohouse.search.dao.SearchDAO;
import com.ohouse.search.dao.SearchDAOImpl;
import com.ohouse.search.dto.KeyWordDTO;
import com.ohouse.search.dto.ProductSearchDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class SearchService {
    
    private SearchDAO searchDAO = new SearchDAOImpl();

    public void registerKeyword(String keyword) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {

                searchDAO.upsertKeyword(conn, keyword);
                
                searchDAO.updateKeywordRanks(conn);
                
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public List<ProductSearchDTO> getProductsByKeyword(String keyword) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return searchDAO.selectProductsByKeyword(conn, keyword);
        }
    }
    
    public List<KeyWordDTO> getTop10Keywords() throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return searchDAO.selectTop10Keywords(conn);
        }
    }
}