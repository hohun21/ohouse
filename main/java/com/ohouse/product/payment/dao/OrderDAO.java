package com.ohouse.product.payment.dao;

import com.ohouse.product.payment.dto.OrderDetailRequestDTO;
import com.ohouse.product.payment.dto.OrderRequsetDTO;

import java.sql.SQLException;

public interface OrderDAO {

    int insertOrder(OrderRequsetDTO orDTO,int member_id) throws SQLException;
    void insertOrderDetail(int order_id,OrderDetailRequestDTO odrDTO) throws SQLException;
    int updateStock(OrderDetailRequestDTO dto) throws SQLException;
}
