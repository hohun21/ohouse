package com.ohouse.product.payment.dao;

import com.ohouse.product.payment.dto.OrderDetailRequestDTO;
import com.ohouse.product.payment.dto.OrderRequsetDTO;
import com.ohouse.util.conn.ConnectionProvider;

import java.sql.*;

public class OrderDAOImpl implements OrderDAO {
    private Connection conn = null;

    public OrderDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public int insertOrder(OrderRequsetDTO dto, int memberId) throws SQLException {
        int orderId;

        String seqSql = "SELECT ORDERS_SEQ.NEXTVAL FROM DUAL";

        try (PreparedStatement pstmt = conn.prepareStatement(seqSql);
             ResultSet rs = pstmt.executeQuery()) {

            rs.next();
            orderId = rs.getInt(1);
        }
        String sql = """
                INSERT INTO ORDERS
                (ORDER_ID, MEMBER_ID, TOTAL_PRICE, COUPON_DISCOUNT,
                DELIVERY_FEE, PAYMENT_PRICE, MEMBER_COUPON_ID, ORDER_STATUS,
                ORDER_DATE, ADDRESS_ID, REQUEST_MSG)
                VALUES
                (?, ?, ?, ?, ?, ?, ?, 'PAID', SYSDATE, ?, ?)
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(
                sql)) {
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, memberId);
            pstmt.setInt(3, dto.getTotalPrice());
            pstmt.setInt(4, dto.getCouponDiscount());
            pstmt.setInt(5, dto.getDeliveryFee());
            pstmt.setInt(6, dto.getPaymentPrice());

            if (dto.getMemberCouponId() == null) {
                pstmt.setNull(7, Types.NUMERIC);
            } else {
                pstmt.setLong(7, dto.getMemberCouponId());
            }

            pstmt.setLong(8, dto.getAddressId());
            pstmt.setString(9, dto.getRequestMsg());

            pstmt.executeUpdate();


        }
        return orderId;
    }

    @Override
    public void insertOrderDetail(int order_id, OrderDetailRequestDTO odrDTO) throws SQLException {
        String sql = """
                    INSERT INTO ORDERS_DETAIL(ORDER_DETAIL_ID,ORDER_ID,PRODUCT_OPTION_ID,
                    PRODUCT_NAME,OPTION_NAME,PRICE,QUANTITY,BRAND_ID)
                    VALUES(SEQ_ORDERS_DETAIL.NEXTVAL,?,?,?,?,?,?,?)
                """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, order_id);
            pstmt.setLong(2, odrDTO.getProductOptionId());
            pstmt.setString(3, odrDTO.getProductName());
            pstmt.setString(4, odrDTO.getOptionName());
            pstmt.setInt(5, odrDTO.getPrice());
            pstmt.setInt(6, odrDTO.getQuantity());
            pstmt.setLong(7, odrDTO.getBrandId());

            pstmt.executeUpdate();

        }
    }

    @Override
    public int updateStock(OrderDetailRequestDTO dto) throws SQLException {
        String sql = """
                UPDATE product_option
                SET stock = stock - ?
                WHERE product_option_id = ?
                  AND stock >= ?
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, dto.getQuantity());
            ps.setLong(2, dto.getProductOptionId());
            ps.setInt(3, dto.getQuantity());
            return ps.executeUpdate();
        }
    }
}
