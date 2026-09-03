package com.ohouse.product.payment.service;

import com.ohouse.product.cart.dao.CartDAO;
import com.ohouse.product.cart.dao.CartDAOImpl;
import com.ohouse.product.payment.dao.OrderDAO;
import com.ohouse.product.payment.dao.OrderDAOImpl;
import com.ohouse.product.payment.dto.OrderDetailRequestDTO;
import com.ohouse.product.payment.dto.OrderRequsetDTO;
import com.ohouse.product.payment.dto.OrderStatusCountDTO;
import com.ohouse.util.conn.ConnectionProvider;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class OrderService {
    Connection conn = null;

    public void insertOrder(int memberId, OrderRequsetDTO dto,List<Integer> cartItemsIds) throws Exception {
        int order_id = 0;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            OrderDAO orderDAO = new OrderDAOImpl(conn);
            CartDAO cartDAO = new CartDAOImpl(conn);
            Integer cartId = null;

            if (cartItemsIds != null && !cartItemsIds.isEmpty()) {
                cartId = cartDAO.findCartID(memberId);
            }

            order_id = orderDAO.insertOrder(dto, memberId);

            for (OrderDetailRequestDTO odrDTO : dto.getOrderDetails()) {
                long brandId = orderDAO.findBrandIdByProductOptionId(odrDTO.getProductOptionId());
                odrDTO.setBrandId(brandId);
                System.out.println("BRAND ID >>> " + odrDTO.getBrandId());
//                System.out.println("Quanttity >>> " + odrDTO.getQuantity());
                orderDAO.insertOrderDetail(order_id, odrDTO);
                int result = orderDAO.updateStock(odrDTO);
                /*System.out.println("productOptionId >>> " + odrDTO.getProductOptionId());
                System.out.println("quantity >>> " + odrDTO.getQuantity());
                System.out.println("updateStock result >>> " + result);*/
                if (result == 0) {
                    throw new SQLException("재고가 부족합니다.");
                }
            }

            // 주문과 재고 차감이 모두 성공한 경우에만 주문한 장바구니 항목을 제거한다.
            if (cartId != null) {
                cartDAO.deleteCartItems(conn, cartId, cartItemsIds);
                cartDAO.updateTotalPrice(conn, cartId);
            }


            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    public void payconfirm(int orders_detail_id) throws SQLException, NamingException {
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            OrderDAO orderDAO = new OrderDAOImpl(conn);
            orderDAO.payConfirm(orders_detail_id);


            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    public void payreturn(int orders_detail_id) throws SQLException, NamingException {
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            OrderDAO orderDAO = new OrderDAOImpl(conn);
            orderDAO.payReturn(orders_detail_id);
            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    public void paycancel(int orders_detail_id) throws SQLException, NamingException {
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            OrderDAO orderDAO = new OrderDAOImpl(conn);
            orderDAO.payCancel(orders_detail_id);
            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }
    public OrderStatusCountDTO getOrderStatusCount(int member_id) throws SQLException, NamingException {
        conn = ConnectionProvider.getConnection();
        OrderDAO orderDAO = new OrderDAOImpl(conn);
        return orderDAO.getOrderStatusCount(member_id);
    }
}
