package com.ohouse.shopping.best.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.shopping.best.dto.BestDTO;

public interface BestDAO {
	
	List<BestDTO> getBestProducts(Connection conn) throws SQLException;
	
}
