package com.ohouse.seller.service;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.NamingException;

import com.ohouse.seller.dao.SellerAuthDAO;
import com.ohouse.seller.dao.SellerAuthDAOImpl;
import com.ohouse.seller.dto.SellerDTO;
import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.util.conn.JdbcUtil;

public class SellerChangePasswordService {

    private SellerAuthDAO sellerDao = SellerAuthDAOImpl.getInstance();

    public boolean checkCurrentPassword(String email, String currentPwd) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            SellerDTO seller = sellerDao.selectByEmail(conn, email);
            if (seller == null) {
                return false;
            }
            return currentPwd.equals(seller.getPassword());
        } catch (SQLException | NamingException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void changePassword(long sellerId, String email, String currentPwd, String newPwd) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            
            SellerDTO seller = sellerDao.selectByEmail(conn, email);
            
            if (seller == null || seller.getSellerId() != sellerId) {
                throw new RuntimeException("판매자 정보를 찾을 수 없습니다.");
            }
            
            if (!currentPwd.equals(seller.getPassword())) {
                throw new RuntimeException("현재 비밀번호가 일치하지 않습니다.");
            }

            int updatedRows = sellerDao.updatePassword(conn, sellerId, newPwd);

            if (updatedRows != 1) {
                throw new SQLException("판매자 비밀번호 변경에 실패했습니다.");
            }
            conn.commit();

        } catch (SQLException | NamingException e) {
            JdbcUtil.rollback(conn);
            throw new RuntimeException(e);
        } catch (RuntimeException e) {
            JdbcUtil.rollback(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }
}