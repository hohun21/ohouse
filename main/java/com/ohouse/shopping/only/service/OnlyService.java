package com.ohouse.shopping.only.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.naming.NamingException;

import com.ohouse.shopping.only.dao.OnlyDAO;
import com.ohouse.shopping.only.dao.OnlyDAOImpl;
import com.ohouse.shopping.only.dto.OnlyDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class OnlyService {
	
	private OnlyDAO onlyDao = new OnlyDAOImpl();
	
	public List<OnlyDTO> getOnlyProducts()
            throws SQLException, NamingException {

        try (Connection conn = ConnectionProvider.getConnection()) {
            return onlyDao.getAllOnlyProducts(conn);
        }
    }
	
	public List<OnlyDTO> getOnlyProductsByMainCategory(
	        Connection conn,
	        int mainCategoryId
	) throws SQLException {

	    return onlyDao.getOnlyProductsByMainCategory(
	            conn,
	            mainCategoryId
	    );
	}

}
