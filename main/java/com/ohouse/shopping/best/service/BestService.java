package com.ohouse.shopping.best.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.ohouse.shopping.best.dao.BestDAO;
import com.ohouse.shopping.best.dao.BestDAOImpl;
import com.ohouse.shopping.best.dto.BestDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class BestService {
	
	private BestDAO bestDao = new BestDAOImpl();
	
	public List<BestDTO> getBestProducts()
            throws SQLException, NamingException {

        try (Connection conn = ConnectionProvider.getConnection()) {
            return bestDao.getBestProducts(conn);
        }
    }
}
