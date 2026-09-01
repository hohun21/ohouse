package com.ohouse.product.cart.dao;

import com.ohouse.product.cart.dto.CartDTO;
import com.ohouse.product.cart.dto.CartItemDTO;
import com.ohouse.product.cart.dto.CartOptionDTO;
import com.ohouse.product.cart.dto.CartOptionEditRequestDTO;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface CartDAO {

    int findCartID(int member_id) throws SQLException, NamingException;

    boolean insert(Connection conn, List<CartItemDTO> cartItemDTO, int member_id) throws SQLException, NamingException;

    List<CartItemDTO> selectCartList(int cart_id) throws SQLException, NamingException;

    List<CartOptionDTO> selectCartOption(List<Long> productIds) throws SQLException, NamingException;

    int updateCartOption(Connection conn, int cart_id, CartOptionEditRequestDTO requestDTO) throws SQLException, NamingException;

    int updateCartQuantity(Connection conn, CartItemDTO cartItemDTO, int cart_id) throws SQLException, NamingException;

    CartDTO selectCart(int member_id) throws SQLException, NamingException;

    int updateTotalPrice(Connection conn, int cart_id) throws SQLException, NamingException;

    int getNextCartgroupID() throws SQLException, NamingException;

    int deleteCartItems(Connection conn, int cart_id, List<Integer> cartItemsIds) throws SQLException;

    List<CartOptionDTO> selectCartOptions(Connection conn, long product_option_id) throws SQLException;

    void createCart(Connection conn, int member_id) throws SQLException;

}
