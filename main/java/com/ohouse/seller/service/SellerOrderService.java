package com.ohouse.seller.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;

import com.ohouse.seller.dao.SellerOrderDAO;
import com.ohouse.seller.dao.SellerOrderDAOImpl;
import com.ohouse.seller.dto.SellerOrderDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class SellerOrderService {

    private SellerOrderDAO orderDao = SellerOrderDAOImpl.getInstance();

    public List<SellerOrderDTO> getOrderList(String brandName) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return orderDao.selectOrderListByBrand(conn, brandName);
        } catch (SQLException | NamingException e) {
            throw new RuntimeException("주문 목록 조회 중 오류 발생", e);
        }
    }

    public boolean changeDeliveryStatus(int orderDetailId, int status) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false); 
            try {
                int result = orderDao.updateDeliveryStatus(conn, orderDetailId, status);
                
                conn.commit();
                return result > 0;
            } catch (SQLException e) {
                conn.rollback(); 
                throw e;
            }
        } catch (SQLException | NamingException e) {
            throw new RuntimeException("배송 상태 업데이트 중 오류 발생", e);
        }
    }

    public Map<String, Object> getDashboardOrderStats(String brandName) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return orderDao.selectDashboardOrderStats(conn, brandName);
        } catch (SQLException | NamingException e) {
            throw new RuntimeException("대시보드 통계 조회 중 오류 발생", e);
        }
    }
    
    public List<SellerOrderDTO> getClaimList(String brandName) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return orderDao.selectClaimListByBrand(conn, brandName);
        } catch (SQLException | NamingException e) {
            throw new RuntimeException("클레임 목록 조회 중 오류 발생", e);
        }
    }

    public List<SellerOrderDTO> getSettlementList(String brandName) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return orderDao.selectSettlementListByBrand(conn, brandName);
        } catch (SQLException | NamingException e) {
            throw new RuntimeException("정산 목록 조회 중 오류 발생", e);
        }
    }
}