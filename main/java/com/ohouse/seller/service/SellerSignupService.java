package com.ohouse.seller.service;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ohouse.member.service.DuplicateEmailException;
import com.ohouse.seller.dao.BrandDAO;
import com.ohouse.seller.dao.BrandDAOImpl;
import com.ohouse.seller.dao.SellerAuthDAO;
import com.ohouse.seller.dao.SellerAuthDAOImpl;
import com.ohouse.seller.dto.BrandDTO;
import com.ohouse.seller.dto.SellerDTO;
import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.util.conn.JdbcUtil;

public class SellerSignupService {
    
    // 💡 SellerAuthDAO로 변경
    private SellerAuthDAO sellerDAO = SellerAuthDAOImpl.getInstance();
    private BrandDAO brandDAO = BrandDAOImpl.getInstance();
    
    public SellerDTO signup(SellerSignupRequest signupReq) {
        Connection conn = null;
        
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            
            String email = signupReq.getEmail();
            String brandName = signupReq.getBrandName();
            
            SellerDTO foundMember = sellerDAO.selectByEmail(conn, email);
            if (foundMember != null) {
                JdbcUtil.rollback(conn);
                throw new DuplicateEmailException();
            }
            
            SellerDTO seller = SellerDTO.builder()
                    .email(email)
                    .password(signupReq.getPassword())
                    .businessNumber(signupReq.getBusinessNumber())
                    .representativeName(signupReq.getRepresentativeName())
                    .mailOrderNumber(signupReq.getMailOrderNumber())
                    .businessAddress(signupReq.getBusinessAddress())
                    .representativeContact(signupReq.getRepresentativeContact())
                    .customerServicePhone(signupReq.getCustomerServicePhone())
                    .build();
            
            int sellerRowCount = sellerDAO.insert(conn, seller);
            if (sellerRowCount != 1) {
                throw new SQLException("판매자 등록에 실패했습니다.");
            }
            
            SellerDTO newSeller = sellerDAO.selectByEmail(conn, email);
            if (newSeller == null) {
                throw new SQLException("등록한 판매자를 찾을 수 없습니다.");
            }
            
            BrandDTO brand = BrandDTO.builder()
                    .brandName(signupReq.getBrandName())
                    .sellerId((int) newSeller.getSellerId()) // 타입 맞춤
                    .build();
            
            int brandRowCount = brandDAO.insert(conn, brand);
            if (brandRowCount != 1) {
                throw new SQLException("브랜드 등록에 실패했습니다.");
            }
            
            BrandDTO newBrand = brandDAO.selectByBrandName(conn, brandName);
            if (newBrand == null) {
                throw new SQLException("등록한 브랜드를 찾을 수 없습니다.");
            }
            
            conn.commit();
            return newSeller;

        } catch (SQLException | NamingException e) {
            JdbcUtil.rollback(conn);
            throw new RuntimeException(e);
        } finally {
            JdbcUtil.close(conn);
        }
    } 
    
    public String emailCheck(String email) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return sellerDAO.emailCheck(conn, email); 
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        } 
    } 
    
    public String buisinessNumberCheck(String buisiness_number) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return sellerDAO.businessNumberCheck(conn, buisiness_number); 
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        } 
    } 
    
    public String mailOrderNumberCheck(String mail_Order_Number) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return sellerDAO.mailOrderNumberCheck(conn, mail_Order_Number); 
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        } 
    } 
    
    public String brandNameCheck(String brandName) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return brandDAO.brandNameCheck(conn, brandName); 
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        } 
    } 
}