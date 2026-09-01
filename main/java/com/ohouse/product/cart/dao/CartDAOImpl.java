package com.ohouse.product.cart.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.naming.NamingException;

import com.ohouse.product.cart.dto.CartDTO;
import com.ohouse.product.cart.dto.CartItemDTO;
import com.ohouse.product.cart.dto.CartOptionDTO;
import com.ohouse.product.cart.dto.CartOptionEditItemDTO;
import com.ohouse.product.cart.dto.CartOptionEditRequestDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class CartDAOImpl implements CartDAO {
    @Override
    public List<CartOptionDTO> selectCartOptions(Connection conn, long product_option_id) throws SQLException {

        String sql = """
                SELECT
                    po.product_id,
                    og.option_group_id,
                    og.group_name AS option_group_name,
                    ov.option_value_id,
                    ov.option_name AS option_value_name
                FROM product_option po
                JOIN product_option_value pov
                    ON po.product_option_id = pov.product_option_id
                JOIN option_value ov
                    ON pov.option_value_id = ov.option_value_id
                JOIN option_group og
                    ON ov.option_group_id = og.option_group_id
                WHERE po.product_option_id = ?
                ORDER BY og.sort_order, ov.sort_order
                """;

        List<CartOptionDTO> list = new ArrayList<>();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, product_option_id);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    list.add(CartOptionDTO.builder().product_id(rs.getLong("product_id")).option_group_id(rs.getLong("option_group_id")).option_group_name(rs.getString("option_group_name")).option_value_id(rs.getLong("option_value_id")).option_value_name(rs.getString("option_value_name")).build());
                }
            }
        }

        return list;
    }

    @Override
    public int deleteCartItems(Connection conn, int cart_id, List<Integer> cartItemsIds) throws SQLException {
        if (cartItemsIds == null || cartItemsIds.isEmpty()) {
            return 0;
        }

        String sql = """
                DELETE FROM CART_ITEMS
                WHERE CART_ITEMS_ID = ?
                AND CART_ID = ?
                """;

        int rowCount = 0;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (Integer cartItemsId : cartItemsIds) {

                pstmt.setInt(1, cartItemsId);

                pstmt.setInt(2, cart_id);

                rowCount += pstmt.executeUpdate();
            }
        }

        return rowCount;
    }

    @Override
    public int getNextCartgroupID() throws SQLException, NamingException {
        String sql = "SELECT CART_GROUP_SEQ.NEXTVAL FROM DUAL";

        try (Connection conn = ConnectionProvider.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        throw new SQLException("CART_GROUP_ID 생성 실패");
    }

    @Override
    public int updateCartQuantity(Connection conn, CartItemDTO cartItemDTO, int cart_id) throws SQLException {
        String sql = """
                UPDATE CART_ITEMS
                SET QUANTITY = ?
                WHERE CART_ITEMS_ID = ?
                AND CART_ID = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, cartItemDTO.getQuantity());
            pstmt.setInt(2, cartItemDTO.getCart_items_id());
            pstmt.setInt(3, cart_id);

            return pstmt.executeUpdate();
        }
    }

    @Override
    public int updateCartOption(
            Connection conn,
            int cart_id,
            CartOptionEditRequestDTO requestDTO
    ) throws SQLException {

        String sql = """
                UPDATE CART_ITEMS
                SET PRODUCT_OPTION_ID = ?,
                    QUANTITY = ?
                WHERE CART_ITEMS_ID = ?
                  AND CART_ID = ?
                """;

        int rowCount = 0;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (CartOptionEditItemDTO item : requestDTO.getItems()) {

                if (item.getCart_items_id() == null) {
                    continue;
                }

                pstmt.setLong(1, item.getProduct_option_id());
                pstmt.setInt(2, item.getQuantity());
                pstmt.setInt(3, item.getCart_items_id());
                pstmt.setInt(4, cart_id);

                rowCount += pstmt.executeUpdate();
            }
        }

        return rowCount;
    }

    @Override
    public CartDTO selectCart(int member_id) throws SQLException, NamingException {
        String sql = """
                    SELECT * FROM CART WHERE MEMBER_ID=?
                """;
        CartDTO cartDTO = null;
        try (Connection conn = ConnectionProvider.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql);) {
            stmt.setInt(1, member_id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                cartDTO = CartDTO.builder().member_id(rs.getLong("MEMBER_ID")).cart_id(rs.getLong("CART_ID")).total_price(rs.getLong("TOTAL_PRICE")).build();
            }
        }
        return cartDTO;
    }

    @Override
    public int updateTotalPrice(Connection conn, int cart_id) throws SQLException {

        String sql = """
                UPDATE CART
                SET TOTAL_PRICE = (
                    SELECT NVL(
                        SUM(ci.QUANTITY * po.PRICE),
                        0
                    )
                    FROM CART_ITEMS ci
                    JOIN PRODUCT_OPTION po
                      ON ci.PRODUCT_OPTION_ID =
                         po.PRODUCT_OPTION_ID
                    WHERE ci.CART_ID = ?
                )
                WHERE CART_ID = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, cart_id);
            pstmt.setInt(2, cart_id);

            return pstmt.executeUpdate();
        }
    }

    @Override
    public List<CartOptionDTO> selectCartOption(List<Long> productIds) throws SQLException, NamingException {
        if (productIds.isEmpty()) {
            return new ArrayList<>();
        }
        String placeholders = String.join(",", Collections.nCopies(productIds.size(), "?"));

        String sql = """
                    select og.option_group_id,og.group_name,ov.option_value_id,ov.option_name
                    from option_group og join option_value ov
                    on og.option_group_id = ov.option_group_id
                    where og.product_id IN (%s)
                """.formatted(placeholders);
        List<CartOptionDTO> cartOptionDTOList = new ArrayList<>();
        try (Connection conn = ConnectionProvider.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql);) {
            for (int i = 0; i < productIds.size(); i++) {
                pstmt.setLong(i + 1, productIds.get(i));
            }
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                CartOptionDTO cartOptionDTO = CartOptionDTO.builder().option_group_id(rs.getInt("option_group_id")).option_group_name(rs.getString("group_name")).option_value_id(rs.getInt("option_value_id")).option_value_name(rs.getString("option_name")).build();
                cartOptionDTOList.add(cartOptionDTO);
            }
        }
        return cartOptionDTOList;
    }

    @Override
    public List<CartItemDTO> selectCartList(int cart_id) throws SQLException, NamingException {
        String sql = """
                SELECT cart_id,
                       cart_items_id,
                       b.brand_name,
                       p.product_name,
                       pi.image_url,
                       p.product_id,
                       po.sku,
                       po.price,
                       quantity,
                       ci.product_option_id
                FROM cart_items ci
                JOIN product_option po
                    ON ci.product_option_id = po.product_option_id
                JOIN product p
                    ON p.product_id = po.product_id
                JOIN product_image pi
                    ON p.product_id = pi.product_id
                JOIN brand b
                    ON b.brand_id = p.brand_id
                WHERE pi.sort_order = 1
                  AND cart_id = ?
                ORDER BY b.brand_name, ci.cart_items_id
                """;

        List<CartItemDTO> list = new ArrayList<>();

        try (Connection conn = ConnectionProvider.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, cart_id);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    long productOptionId = rs.getLong("product_option_id");

                    List<CartOptionDTO> options = selectCartOptions(conn, productOptionId);


                    CartItemDTO item = CartItemDTO.builder().cart_items_id(rs.getInt("cart_items_id")).cart_id(rs.getInt("cart_id")).product_id(rs.getLong("product_id")).product_option_id(productOptionId).product_name(rs.getString("product_name")).image_url(rs.getString("image_url")).quantity(rs.getInt("quantity")).brand_name(rs.getString("brand_name")).sku(rs.getString("sku")).price(rs.getInt("price")).options(options).build();

                    list.add(item);
                }
            }
        }

        return list;
    }

    @Override
    public int findCartID(int member_id) throws SQLException, NamingException {
        String sql = """
                    SELECT CART_ID FROM CART WHERE MEMBER_ID = ?
                """;
        try (Connection conn = ConnectionProvider.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql);) {
            pstmt.setInt(1, member_id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("cart_id");
            }
        }
        return 0;
    }

    @Override
    public boolean insert(Connection conn, List<CartItemDTO> cartItemDTO, int cart_id) throws NamingException, SQLException {

        String sql = """
                   MERGE INTO CART_ITEMS ci
                              USING (
                                  SELECT ? PRODUCT_OPTION_ID,
                                         ? CART_ID,
                                         ? QUANTITY
                                  FROM dual
                              ) src
                              ON (
                                  ci.PRODUCT_OPTION_ID = src.PRODUCT_OPTION_ID
                                  AND ci.CART_ID = src.CART_ID
                              )
                              WHEN MATCHED THEN
                                  UPDATE SET ci.QUANTITY = ci.QUANTITY + src.QUANTITY
                              WHEN NOT MATCHED THEN
                                  INSERT (PRODUCT_OPTION_ID, CART_ID, QUANTITY)
                                  VALUES (src.PRODUCT_OPTION_ID, src.CART_ID, src.QUANTITY)
                """;
        int[] rowcountArr;
        boolean rowcount = false;
        try {
            PreparedStatement pstmt = conn.prepareStatement(sql);
            conn = ConnectionProvider.getConnection();
            for (CartItemDTO item : cartItemDTO) {
                pstmt.setLong(1, item.getProduct_option_id());
                pstmt.setInt(2, cart_id);
                pstmt.setInt(3, item.getQuantity());
                pstmt.addBatch();
            }


            rowcountArr = pstmt.executeBatch();
            if (rowcountArr.length > 0) {
                rowcount = true;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        ;

        return rowcount;
    }

    @Override
    public void createCart(Connection conn, int member_id) throws SQLException {
        String sql = "INSERT INTO cart (member_id, total_price) VALUES (?, 0)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, member_id);
            pstmt.executeUpdate();
        }
    }
}
