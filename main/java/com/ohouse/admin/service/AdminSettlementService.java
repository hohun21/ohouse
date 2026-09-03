package com.ohouse.admin.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import javax.naming.NamingException;

import com.ohouse.admin.dao.AdminSettlementDAO;
import com.ohouse.admin.dao.AdminSettlementDAOImpl;
import com.ohouse.seller.dto.SellerOrderDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class AdminSettlementService {

    private AdminSettlementDAO settlementDao = AdminSettlementDAOImpl.getInstance();

    public List<SellerOrderDTO> getAdminSettlementList() {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return settlementDao.selectAdminSettlementList(conn);
        } catch (SQLException | NamingException e) {
            throw new RuntimeException("관리자 정산 대기 목록 조회 중 오류 발생", e);
        }
    }
    
    public boolean executeSettlement(int orderDetailId) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int result = settlementDao.updateSettlementStatus(conn, orderDetailId);
                conn.commit();
                return result > 0;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException | javax.naming.NamingException e) {
            throw new RuntimeException("정산 처리 중 오류 발생", e);
        }
    }
}