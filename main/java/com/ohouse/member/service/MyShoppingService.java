package com.ohouse.member.service;

import com.ohouse.member.dto.MyOrderDTO;
import com.ohouse.member.dto.MyOrderDetailDTO;
import com.ohouse.product.payment.dao.OrderDAO;
import com.ohouse.product.payment.dao.OrderDAOImpl;
import com.ohouse.util.conn.ConnectionProvider;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class MyShoppingService {
    Connection conn = null;

    public List<MyOrderDTO> selectorder(int member_id) throws Exception {
        conn = ConnectionProvider.getConnection();
        try {
            OrderDAO orderDAO = new OrderDAOImpl(conn);
            List<MyOrderDTO> orderlist = orderDAO.viewMyOrder(member_id);

            for(MyOrderDTO order : orderlist){
                List<MyOrderDetailDTO> detaillist =
                        orderDAO.viewMyOrderDetail(order.getOrders_id());
                order.setOrderDetails(detaillist);
            }
            return orderlist;
        } finally {
            if (conn != null) conn.close();
        }
    }
}
