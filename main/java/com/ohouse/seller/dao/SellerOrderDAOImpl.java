package com.ohouse.seller.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ohouse.seller.dto.SellerOrderDTO;

public class SellerOrderDAOImpl implements SellerOrderDAO {

    private static SellerOrderDAOImpl instance = new SellerOrderDAOImpl();
    private SellerOrderDAOImpl() {}
    public static SellerOrderDAOImpl getInstance() {
        return instance;
    }

    @Override
    public List<SellerOrderDTO> selectOrderListByBrand(Connection conn, String brandName) throws SQLException {
        List<SellerOrderDTO> list = new ArrayList<>();
        
        String sql = "SELECT od.orders_detail_id, o.order_date, od.product_name, od.option_name, "
                   + "       od.quantity, od.price, od.delivery_status "
                   + "FROM ORDERS_DETAIL od "
                   + "JOIN ORDERS o ON od.order_id = o.order_id "
                   + "WHERE od.brand_id = (SELECT brand_id FROM brand WHERE brand_name = ?) "
                   + "  AND od.delivery_status IN (1, 2, 3, 4, 5) "
                   + "ORDER BY o.order_date DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, brandName);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SellerOrderDTO dto = new SellerOrderDTO();
                    dto.setOrderDetailId(rs.getInt("orders_detail_id"));
                    dto.setOrderDate(rs.getTimestamp("order_date"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setOptionName(rs.getString("option_name"));
                    dto.setQuantity(rs.getInt("quantity"));
                    dto.setPrice(rs.getInt("price"));
                    dto.setDeliveryStatus(rs.getInt("delivery_status"));
                    
                    list.add(dto);
                }
            }
        }
        return list;
    }

    @Override
    public int updateDeliveryStatus(Connection conn, int orderDetailId, int status) throws SQLException {
        String sql = "";
        
        if (status == 4) {
            sql = "UPDATE ORDERS_DETAIL SET delivery_status = ?, delivered_date = SYSDATE WHERE order_detail_id = ?";
        } else {
            sql = "UPDATE ORDERS_DETAIL SET delivery_status = ? WHERE order_detail_id = ?";
        }

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, status);
            pstmt.setInt(2, orderDetailId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public Map<String, Object> selectDashboardOrderStats(Connection conn, String brandName) throws SQLException {
        Map<String, Object> stats = new java.util.HashMap<>();
        
        String sql = "SELECT "
                   + "  NVL(SUM(CASE WHEN delivery_status = 2 THEN 1 ELSE 0 END), 0) AS readyCount, "
                   + "  NVL(SUM(CASE WHEN delivery_status = 3 THEN 1 ELSE 0 END), 0) AS shippingCount, "
                   + "  NVL(SUM(CASE WHEN delivery_status = 4 THEN 1 ELSE 0 END), 0) AS deliveredCount, "
                   + "  NVL(SUM(CASE WHEN delivery_status = 5 THEN 1 ELSE 0 END), 0) AS confirmedCount, "
                   + "  NVL(SUM(CASE WHEN delivery_status IN (5, 12) THEN price * quantity ELSE 0 END), 0) AS totalSales "
                   + "FROM ORDERS_DETAIL "
                   + "WHERE brand_id = (SELECT brand_id FROM brand WHERE brand_name = ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, brandName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("readyCount", rs.getInt("readyCount"));
                    stats.put("shippingCount", rs.getInt("shippingCount"));
                    stats.put("deliveredCount", rs.getInt("deliveredCount"));
                    stats.put("confirmedCount", rs.getInt("confirmedCount"));
                    
                    long totalSales = rs.getLong("totalSales");
                    stats.put("totalSales", totalSales);
                    stats.put("finalSettlement", (long)(totalSales * 0.98)); 
                }
            }
        }
        return stats;
    }
    
    @Override
    public List<SellerOrderDTO> selectClaimListByBrand(Connection conn, String brandName) throws SQLException {
        List<SellerOrderDTO> list = new ArrayList<>();
        
        String sql = "SELECT od.orders_detail_id, o.order_date, od.product_name, od.option_name, "
                   + "       od.quantity, od.price, od.delivery_status "
                   + "FROM ORDERS_DETAIL od "
                   + "JOIN ORDERS o ON od.order_id = o.order_id "
                   + "WHERE od.brand_id = (SELECT brand_id FROM brand WHERE brand_name = ?) "
                   + "  AND od.delivery_status IN (6, 7, 8, 9, 10, 11) "
                   + "ORDER BY o.order_date DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, brandName);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SellerOrderDTO dto = new SellerOrderDTO();
                    dto.setOrderDetailId(rs.getInt("orders_detail_id"));
                    dto.setOrderDate(rs.getTimestamp("order_date"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setOptionName(rs.getString("option_name"));
                    dto.setQuantity(rs.getInt("quantity"));
                    dto.setPrice(rs.getInt("price"));
                    dto.setDeliveryStatus(rs.getInt("delivery_status"));
                    
                    list.add(dto);
                }
            }
        }
        return list;
    }
    
    @Override
    public List<SellerOrderDTO> selectSettlementListByBrand(Connection conn, String brandName) throws SQLException {
        List<SellerOrderDTO> list = new ArrayList<>();
        
        String sql = "SELECT od.orders_detail_id, o.order_date, od.product_name, od.option_name, "
                   + "       od.quantity, od.price, od.delivery_status, "
                   + "       (od.price * od.quantity) AS total_price, "
                   + "       ((od.price * od.quantity) * 0.98) AS settlement_amount "
                   + "FROM ORDERS_DETAIL od "
                   + "JOIN ORDERS o ON od.order_id = o.order_id "
                   + "WHERE od.brand_id = (SELECT brand_id FROM brand WHERE brand_name = ?) "
                   + "  AND od.delivery_status = 12 "
                   + "ORDER BY o.order_date DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, brandName);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SellerOrderDTO dto = new SellerOrderDTO();
                    dto.setOrderDetailId(rs.getInt("orders_detail_id"));
                    dto.setOrderDate(rs.getTimestamp("order_date"));
                    dto.setProductName(rs.getString("product_name"));
                    dto.setOptionName(rs.getString("option_name"));
                    dto.setQuantity(rs.getInt("quantity"));
                    dto.setPrice(rs.getInt("price"));
                    dto.setDeliveryStatus(rs.getInt("delivery_status"));
                    
                    list.add(dto);
                }
            }
        }
        return list;
    }
}