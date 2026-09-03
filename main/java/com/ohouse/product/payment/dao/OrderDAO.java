package com.ohouse.product.payment.dao;

import com.ohouse.member.dto.MyOrderDTO;
import com.ohouse.member.dto.MyOrderDetailDTO;
import com.ohouse.product.payment.dto.OrderDetailRequestDTO;
import com.ohouse.product.payment.dto.OrderRequsetDTO;
import com.ohouse.product.payment.dto.OrderStatusCountDTO;

import java.sql.SQLException;
import java.util.List;

public interface OrderDAO {

    int insertOrder(OrderRequsetDTO orDTO,int member_id) throws SQLException;
    long findBrandIdByProductOptionId(long productOptionId) throws SQLException;
    void insertOrderDetail(int order_id,OrderDetailRequestDTO odrDTO) throws SQLException;
    int updateStock(OrderDetailRequestDTO dto) throws SQLException;
    List<MyOrderDTO> viewMyOrder(int member_id) throws SQLException;
    List<MyOrderDetailDTO> viewMyOrderDetail(int order_id) throws SQLException;
    void payConfirm(int orders_detail_id) throws SQLException;
    void payReturn(int orders_detail_id) throws SQLException;
    void payCancel(int orders_detail_id) throws SQLException;
    OrderStatusCountDTO getOrderStatusCount(int member_id) throws SQLException;

}
