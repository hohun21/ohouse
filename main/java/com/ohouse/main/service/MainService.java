package com.ohouse.main.service;

import com.ohouse.main.dao.MainDAO;
import com.ohouse.main.dao.MainDAOImpl;
import com.ohouse.search.dto.ProductSearchDTO;
import com.ohouse.util.conn.ConnectionProvider;

import java.sql.Connection;
import java.util.List;

public class MainService {
    
    private MainDAO mainDAO = new MainDAOImpl();

    public List<ProductSearchDTO> getRandomProductList() throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return mainDAO.selectRandomProducts(conn);
        }
    }
}