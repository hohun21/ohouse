package com.ohouse.product.cart.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import com.ohouse.product.cart.dao.CartDAO;
import com.ohouse.product.cart.dao.CartDAOImpl;
import com.ohouse.product.cart.dto.CartItemDTO;
import com.ohouse.product.cart.dto.CartOptionEditItemDTO;
import com.ohouse.product.cart.dto.CartOptionEditRequestDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class CartService {

    private CartDAO cartDAO = new CartDAOImpl();

    public int deleteCartItems(List<Integer> cartItemsIds, int member_id) throws SQLException, NamingException {

        int cart_id = cartDAO.findCartID(member_id);

        try (Connection conn = ConnectionProvider.getConnection()) {

            conn.setAutoCommit(false);

            try {

                int deleteCount = cartDAO.deleteCartItems(conn, cart_id, cartItemsIds);

                cartDAO.updateTotalPrice(conn, cart_id);

                conn.commit();

                return deleteCount;

            } catch (SQLException e) {

                conn.rollback();

                throw e;
            }
        }
    }

    public void insert(List<CartItemDTO> cartItems, int member_id) throws SQLException, NamingException {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int cart_id = cartDAO.findCartID(member_id);

                boolean result = cartDAO.insert(conn, cartItems, cart_id);


                if (!result) {
                    conn.rollback();
                    return;
                }
                cartDAO.updateTotalPrice(conn, cart_id);
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public List<CartItemDTO> selectCartList(int member_id) throws SQLException, NamingException {
        int cart_id = cartDAO.findCartID(member_id);
        return cartDAO.selectCartList(cart_id);
    }

    public void updateCartOption(CartOptionEditRequestDTO requestDTO, int member_id) throws SQLException, NamingException {

        int cart_id = cartDAO.findCartID(member_id);

        try (Connection conn = ConnectionProvider.getConnection()) {

            conn.setAutoCommit(false);

            try {
                List<Integer> deletedIds = requestDTO.getDeleted_cart_items_ids();

                if (deletedIds != null && !deletedIds.isEmpty()) {
                    cartDAO.deleteCartItems(conn, cart_id, deletedIds);
                }

                List<CartOptionEditItemDTO> items = requestDTO.getItems();

                if (items != null && !items.isEmpty()) {

                    List<CartItemDTO> newItems = new ArrayList<>();

                    for (CartOptionEditItemDTO item : items) {
                        if (item.is_new()) {
                            newItems.add(CartItemDTO.builder().product_option_id(item.getProduct_option_id()).quantity(item.getQuantity()).build());
                        }
                    }

                    if (!newItems.isEmpty()) {
                        cartDAO.insert(conn, newItems, cart_id);
                    }

                    cartDAO.updateCartOption(conn, cart_id, requestDTO);
                }

                cartDAO.updateTotalPrice(conn, cart_id);

                conn.commit();

            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public int updateQuantity(CartItemDTO cartItemDTO, int member_id) throws SQLException, NamingException {
        int cart_id = cartDAO.findCartID(member_id);
        int rowcount = 0;
        try (Connection conn = ConnectionProvider.getConnection()) {
            try {
                rowcount = cartDAO.updateCartQuantity(conn, cartItemDTO, cart_id);
                if (rowcount == 0) {
                    conn.rollback();
                    return 0;
                }
                cartDAO.updateTotalPrice(conn, cart_id);
            } catch (Exception e) {
                conn.rollback();
                throw new RuntimeException(e);
            }


        }
        return rowcount;
    }
}