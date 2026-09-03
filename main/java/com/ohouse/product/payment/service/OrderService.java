package com.ohouse.product.payment.service;

import com.ohouse.product.payment.dao.OrderDAO;
import com.ohouse.product.payment.dao.OrderDAOImpl;
import com.ohouse.product.payment.dto.OrderDetailRequestDTO;
import com.ohouse.product.payment.dto.OrderRequsetDTO;
import com.ohouse.util.conn.ConnectionProvider;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.SQLException;

public class OrderService {
    Connection conn = null;

    public void insertOrder(int memberId, OrderRequsetDTO dto) throws Exception{
        int order_id = 0;
        try{
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            OrderDAO orderDAO = new OrderDAOImpl(conn);

            order_id = orderDAO.insertOrder(dto,memberId);

            for(OrderDetailRequestDTO odrDTO : dto.getOrderDetails()){
                System.out.println("BRAND ID >>> " + odrDTO.getBrandId());
                orderDAO.insertOrderDetail(order_id,odrDTO);
                int result = orderDAO.updateStock(odrDTO);

                if (result == 0) {
                    throw new SQLException("재고가 부족합니다.");
                }
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

}
