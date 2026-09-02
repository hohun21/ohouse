package com.ohouse.admin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.ohouse.seller.dto.SellerOrderDTO;

public class AdminSettlementDAOImpl implements AdminSettlementDAO {

    private static AdminSettlementDAOImpl instance = new AdminSettlementDAOImpl();
    private AdminSettlementDAOImpl() {}
    public static AdminSettlementDAOImpl getInstance() {
        return instance;
    }

    @Override
    public List<SellerOrderDTO> selectAdminSettlementList(Connection conn) throws SQLException {
        List<SellerOrderDTO> list = new ArrayList<>();
        
        String sql = "SELECT od.order_detail_id, o.order_date, b.brand_name, od.product_name, od.option_name, "
                   + "       od.quantity, od.price, od.delivery_status "
                   + "FROM ORDERS_DETAIL od "
                   + "JOIN ORDERS o ON od.order_id = o.order_id "
                   + "JOIN BRAND b ON od.brand_id = b.brand_id "
                   + "WHERE od.delivery_status IN (5, 12) "
                   + "ORDER BY o.order_date DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                SellerOrderDTO dto = new SellerOrderDTO();
                dto.setOrderDetailId(rs.getInt("order_detail_id"));
                dto.setOrderDate(rs.getTimestamp("order_date"));
                dto.setBrandName(rs.getString("brand_name"));
                dto.setProductName(rs.getString("product_name"));
                dto.setOptionName(rs.getString("option_name"));
                dto.setQuantity(rs.getInt("quantity"));
                dto.setPrice(rs.getInt("price"));
                dto.setDeliveryStatus(rs.getInt("delivery_status"));
                
                list.add(dto);
            }
        }
        return list;
    }
    
    @Override
    public int updateSettlementStatus(Connection conn, int orderDetailId) throws SQLException {
        String sql = "UPDATE ORDERS_DETAIL SET delivery_status = 12 WHERE order_detail_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, orderDetailId);
            return pstmt.executeUpdate();
        }
    }
}