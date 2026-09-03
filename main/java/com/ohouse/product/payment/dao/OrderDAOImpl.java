package com.ohouse.product.payment.dao;

import com.ohouse.member.dto.MyOrderDTO;
import com.ohouse.member.dto.MyOrderDetailDTO;
import com.ohouse.product.payment.dto.OrderDetailRequestDTO;
import com.ohouse.product.payment.dto.OrderRequsetDTO;
import com.ohouse.product.payment.dto.OrderStatusCountDTO;
import com.ohouse.util.conn.ConnectionProvider;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {
    private Connection conn = null;

    public OrderDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public int insertOrder(OrderRequsetDTO dto, int memberId
    ) throws SQLException {
        int orderId;

        String seqSql = "SELECT ORDERS_SEQ.NEXTVAL FROM DUAL";

        try (PreparedStatement pstmt = conn.prepareStatement(seqSql);
             ResultSet rs = pstmt.executeQuery()) {

            rs.next();
            orderId = rs.getInt(1);
        }
        String sql = """
                 INSERT INTO ORDERS
                (ORDER_ID, MEMBER_ID, ORDER_NAME, TOTAL_PRICE, COUPON_DISCOUNT,
                 DELIVERY_FEE, PAYMENT_PRICE, MEMBER_COUPON_ID, ORDER_STATUS,
                 ORDER_DATE, ADDRESS_ID, REQUEST_MSG, TOSS_ORDER_ID)
                VALUES(?, ?, ?, ?, ?, ?, ?, ?, 'PAID', SYSDATE, ?, ?, ?)
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(
                sql)) {
            pstmt.setInt(1, orderId);
            pstmt.setInt(2, memberId);
            pstmt.setString(3, dto.getOrderName());
            pstmt.setInt(4, dto.getTotalPrice());
            pstmt.setInt(5, dto.getCouponDiscount());
            pstmt.setInt(6, dto.getDeliveryFee());
            pstmt.setInt(7, dto.getPaymentPrice());

            if (dto.getMemberCouponId() == null) {
                pstmt.setNull(8, Types.NUMERIC);
            } else {
                pstmt.setLong(8, dto.getMemberCouponId());
            }

            pstmt.setLong(9, dto.getAddressId());
            pstmt.setString(10, dto.getRequestMsg());
            pstmt.setString(11, dto.getTossOrderId());

            pstmt.executeUpdate();


        }
        return orderId;
    }

    @Override
    public long findBrandIdByProductOptionId(long productOptionId) throws SQLException {
        String sql = """
                SELECT p.brand_id
                FROM product_option po
                JOIN product p ON p.product_id = po.product_id
                WHERE po.product_option_id = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, productOptionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("상품 옵션을 찾을 수 없습니다: " + productOptionId);
                }
                return rs.getLong("brand_id");
            }
        }
    }

    @Override
    public void insertOrderDetail(int order_id, OrderDetailRequestDTO odrDTO) throws SQLException {
        String sql = """
                INSERT INTO ORDERS_DETAIL(ORDERS_DETAIL_ID, ORDER_ID, PRODUCT_OPTION_ID,
                PRODUCT_NAME, OPTION_NAME, IMG_URL, PRICE, QUANTITY, BRAND_ID,
                DELIVERY_STATUS)
                VALUES(SEQ_ORDERS_DETAIL.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?,1)
            """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, order_id);
            pstmt.setLong(2, odrDTO.getProductOptionId());
            pstmt.setString(3, odrDTO.getProductName());
            pstmt.setString(4, odrDTO.getOptionName());
            pstmt.setString(5, odrDTO.getImgUrl());
            pstmt.setInt(6, odrDTO.getPrice());
            pstmt.setInt(7, odrDTO.getQuantity());
            pstmt.setLong(8, odrDTO.getBrandId());
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

    @Override
    public List<MyOrderDTO> viewMyOrder(int member_id) throws SQLException {
        String sql = """
                    SELECT ORDER_ID,ORDER_NAME,PAYMENT_PRICE,ORDER_DATE
                    ,REQUEST_MSG FROM ORDERS
                    WHERE MEMBER_ID = ?
                """;
        List<MyOrderDTO> orderDTOlist = new ArrayList<>();
        try (
                PreparedStatement pstmt = conn.prepareStatement(sql);

        ) {
            pstmt.setInt(1, member_id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                MyOrderDTO orderDTO = MyOrderDTO.builder()
                        .orders_id(rs.getInt("order_id"))
                        .order_name(rs.getString("order_name"))
                        .payment_price(rs.getInt("payment_price"))
                        .order_date(rs.getDate("order_date"))
                        .request_msg(rs.getString("request_msg"))
                        .build();
                orderDTOlist.add(orderDTO);
            }

        }
        return orderDTOlist;
    }

    @Override
    public List<MyOrderDetailDTO> viewMyOrderDetail(int order_id) throws SQLException {

        String sql = """
                     SELECT od.ORDERS_DETAIL_ID,od.ORDER_ID,od.PRODUCT_NAME,od.img_url
                                         ,od.OPTION_NAME,od.PRICE,od.QUANTITY,b.BRAND_ID,b.BRAND_NAME,od.DELIVERY_STATUS,
                                         od.DELIVERED_DATE,od.PURCHASE_CONFIRMED_DATE
                                         FROM ORDERS_DETAIL od JOIN BRAND b
                                         ON od.brand_id = b.brand_id
                                         WHERE od.ORDER_ID = ?
                """;
        List<MyOrderDetailDTO> orderDetailDTOList = new ArrayList<>();
        try (
                PreparedStatement pstmt = conn.prepareStatement(sql);

        ) {
            pstmt.setInt(1, order_id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {

                MyOrderDetailDTO orderDetailDTO = MyOrderDetailDTO.builder()
                        .orders_detail_id(rs.getInt("orders_detail_id"))
                        .order_id(rs.getInt("order_id") )
                        .product_name(rs.getString("product_name"))
                        .option_name(rs.getString("option_name"))
                        .price(rs.getInt("price"))
                        .quantity(rs.getInt("quantity"))
                        .brand_id(rs.getInt("brand_id"))
                        .brand_name(rs.getString("brand_name"))
                        .image_url(rs.getString("img_url"))
                        .delivery_status(rs.getInt("delivery_status"))
                        .delivered_date(rs.getDate("delivered_date"))
                        .purchase_confirmed_date(rs.getDate("purchase_confirmed_date"))
                        .build();
                orderDetailDTOList.add(orderDetailDTO);
            }

        }
        return orderDetailDTOList;
    }

    @Override
    public void payConfirm(int orders_detail_id) throws SQLException {
        String sql = """
                    UPDATE ORDERS_DETAIL
                    SET DELIVERY_STATUS = 5 , PURCHASE_CONFIRMED_DATE = SYSDATE
                    WHERE ORDERS_DETAIL_ID = ?
                """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, orders_detail_id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw e;
        }
    }

    @Override
    public void payReturn(int orders_detail_id) throws SQLException {
        String sql = """
                    UPDATE ORDERS_DETAIL
                    SET DELIVERY_STATUS = 6 
                    WHERE ORDERS_DETAIL_ID = ?
                """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, orders_detail_id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw e;
        }
    }

    @Override
    public OrderStatusCountDTO getOrderStatusCount(int member_id) throws SQLException {
        String sql = """
        SELECT
            NVL(SUM(CASE WHEN od.DELIVERY_STATUS = 1 THEN 1 ELSE 0 END), 0) AS PAYMENT_COUNT,
            NVL(SUM(CASE WHEN od.DELIVERY_STATUS = 2 THEN 1 ELSE 0 END), 0) AS PREPARING_COUNT,
            NVL(SUM(CASE WHEN od.DELIVERY_STATUS = 3 THEN 1 ELSE 0 END), 0) AS SHIPPING_COUNT,
            NVL(SUM(CASE WHEN od.DELIVERY_STATUS = 4 THEN 1 ELSE 0 END), 0) AS DELIVERED_COUNT,
            NVL(SUM(CASE WHEN od.DELIVERY_STATUS IN (5, 12) THEN 1 ELSE 0 END), 0) AS CONFIRMED_COUNT
        FROM ORDERS_DETAIL od
        JOIN ORDERS o ON od.ORDER_ID = o.ORDER_ID
        WHERE o.MEMBER_ID = ?
    """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, member_id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    OrderStatusCountDTO dto = new OrderStatusCountDTO();
                    dto.setPaymentCount(rs.getInt("PAYMENT_COUNT"));
                    dto.setPreparingCount(rs.getInt("PREPARING_COUNT"));
                    dto.setShippingCount(rs.getInt("SHIPPING_COUNT"));
                    dto.setDeliveredCount(rs.getInt("DELIVERED_COUNT"));
                    dto.setConfirmedCount(rs.getInt("CONFIRMED_COUNT"));
                    return dto;
                }
            }
        }

        return new OrderStatusCountDTO();
    }

    @Override
    public void payCancel(int orders_detail_id) throws SQLException {
        String sql = """
                    UPDATE ORDERS_DETAIL
                    SET DELIVERY_STATUS = 10 
                    WHERE ORDERS_DETAIL_ID = ?
                """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)){
            pstmt.setInt(1, orders_detail_id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw e;
        }
    }
}
