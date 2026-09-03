package com.ohouse.seller.service;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ohouse.seller.dao.BrandDAO;
import com.ohouse.seller.dao.BrandDAOImpl;
import com.ohouse.seller.dao.SellerAuthDAO;
import com.ohouse.seller.dao.SellerAuthDAOImpl;
import com.ohouse.seller.dto.BrandDTO;
import com.ohouse.seller.dto.SellerAuthDTO;
import com.ohouse.seller.dto.SellerDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class SellerLoginService {

	private SellerAuthDAO sellerDao = SellerAuthDAOImpl.getInstance();
	private BrandDAO brandDao = BrandDAOImpl.getInstance();

    public SellerAuthDTO login(String email, String password, String businessNumber) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            SellerDTO seller = sellerDao.selectByEmail(conn, email);
            
            // 💡 1. seller 조회 결과가 없는지 '먼저' 체크해야 합니다!
            if (seller == null) { 
                throw new SellerLoginFailException(); 
            }
            
            // 💡 2. seller가 null이 아님을 보장한 뒤에 안전하게 ID를 꺼내어 brand를 조회합니다.
            BrandDTO brand = brandDao.selectBySellerId(conn, seller.getSellerId());

            if (!password.equals(seller.getPassword())) {
                throw new SellerLoginFailException();
            }

            String savedBusinessNumber = normalizeBusinessNumber(seller.getBusinessNumber());

            if (!businessNumber.equals(savedBusinessNumber)) { // 원본 비교 혹은 정규화 비교에 맞게 유지
                throw new SellerLoginFailException();
            }
            
            if (brand == null) { 
                throw new SellerLoginFailException(); 
            }

            String status = seller.getStatus();
            if (!"ACTIVE".equalsIgnoreCase(status)) {
                throw new SellerNotActiveException(status);
            }

            return new SellerAuthDTO(
                    seller.getSellerId(),
                    seller.getEmail(),
                    seller.getBusinessNumber(),
                    brand.getBrandName(), 
                    seller.getStatus()
            );

        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        }
    }
    
    private String normalizeBusinessNumber(String businessNumber) {
        if (businessNumber == null) { return ""; }
        return businessNumber.replaceAll("[^0-9]", "");
    }
    
    // status 체크 ajax
    public String statusCheck(String email) throws SQLException, NamingException {
        try (Connection conn = ConnectionProvider.getConnection()) {
            
            return sellerDao.statusCheck(conn, email); 
            
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        } 
    }
}