package com.ohouse.shopping.only.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.shopping.only.dto.OnlyDTO;

public interface OnlyDAO {

	List<OnlyDTO> getAllOnlyProducts(Connection conn) throws SQLException;
	
}
