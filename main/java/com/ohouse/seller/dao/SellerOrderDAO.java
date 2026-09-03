package com.ohouse.seller.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.ohouse.seller.dto.SellerOrderDTO;

public interface SellerOrderDAO {
    
	List<SellerOrderDTO> selectOrderListByBrand(Connection conn, String brandName) throws SQLException;
	
    int updateDeliveryStatus(Connection conn, int orderDetailId, int status) throws SQLException;
    
    Map<String, Object> selectDashboardOrderStats(Connection conn, String brandName) throws SQLException;
    
    List<SellerOrderDTO> selectClaimListByBrand(Connection conn, String brandName) throws SQLException;
    
    List<SellerOrderDTO> selectSettlementListByBrand(Connection conn, String brandName) throws SQLException;
}