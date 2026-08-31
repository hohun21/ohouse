package com.ohouse.seller.service;

import java.sql.Connection;
import java.sql.SQLException;

import com.ohouse.seller.dao.SellerAuthDAO;
import com.ohouse.seller.dao.SellerAuthDAOImpl;
import com.ohouse.seller.dto.SellerDTO;
import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.util.conn.JdbcUtil;

public class SellerSignupStatusService {

    private static SellerSignupStatusService instance = new SellerSignupStatusService();

    // 💡 SellerAuthDAO로 변경
    private SellerAuthDAO sellerDAO = SellerAuthDAOImpl.getInstance();

    public SellerSignupStatusService() {}

    public static SellerSignupStatusService getInstance() {
        return instance;
    }

    public String checkSignupStatus(String email, String password, String businessNumber) throws SQLException, Exception {

        Connection conn = null;

        try {
            conn = ConnectionProvider.getConnection();
            SellerDTO seller = sellerDAO.selectByEmail(conn, email);

            if (seller == null) {
                throw new SellerAuthenticationException();
            }

            if (!password.equals(seller.getPassword())) {
                throw new SellerAuthenticationException();
            }

            String inputBusinessNumber = normalizeBusinessNumber(businessNumber);

            // 💡 getBusiness_Number() -> getBusinessNumber()
            String savedBusinessNumber = normalizeBusinessNumber(seller.getBusinessNumber());

            if (!inputBusinessNumber.equals(savedBusinessNumber)) {
                throw new SellerAuthenticationException();
            }

            String status = seller.getStatus();
            if (status == null || status.isBlank()) {
                throw new IllegalStateException("판매자의 입점 상태가 없습니다.");
            }

            status = status.trim().toUpperCase();

            if (!"PENDING".equals(status) && !"ACTIVE".equals(status) && !"REJECTED".equals(status)) {
                throw new IllegalStateException("처리할 수 없는 입점 상태입니다: " + status);
            }

            return status;

        } finally {
            JdbcUtil.close(conn);
        }
    }

    private String normalizeBusinessNumber(String businessNumber) {
        if (businessNumber == null) {
            return "";
        }
        return businessNumber.replaceAll("[^0-9]", "");
    }
}