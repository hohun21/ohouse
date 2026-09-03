package com.ohouse.admin.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import com.ohouse.seller.dto.SellerOrderDTO;

public interface AdminSettlementDAO {
    List<SellerOrderDTO> selectAdminSettlementList(Connection conn) throws SQLException;
    
    int updateSettlementStatus(Connection conn, int orderDetailId) throws SQLException;
}