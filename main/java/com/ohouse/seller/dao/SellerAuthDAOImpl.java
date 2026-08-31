package com.ohouse.seller.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.ohouse.seller.dto.SellerDTO;
import com.ohouse.util.conn.JdbcUtil;

public class SellerAuthDAOImpl implements SellerAuthDAO {

    private static final SellerAuthDAOImpl instance = new SellerAuthDAOImpl();
    	
    private SellerAuthDAOImpl() {
    }

    public static SellerAuthDAOImpl getInstance() {
        return instance;
    }

    // 1. 판매자 회원가입
    @Override
    public int insert(Connection conn, SellerDTO seller) throws SQLException {
        String sql =
                " INSERT INTO seller ( "
                        + "     seller_id, email, password, business_number "
                        + "   , representative_name, mail_order_number "
                        + "   , business_address, representative_contact "
                        + "   , customer_service_phone, status )"
                        + " VALUES (seq_seller.NEXTVAL , ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING') ";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString( 1, seller.getEmail() );
            pstmt.setString( 2, seller.getPassword() );
            pstmt.setString( 3, seller.getBusinessNumber() );
            pstmt.setString( 4, seller.getRepresentativeName() );
            pstmt.setString( 5, seller.getMailOrderNumber() );
            pstmt.setString( 6, seller.getBusinessAddress() );
            pstmt.setString( 7, seller.getRepresentativeContact() );
            pstmt.setString( 8, seller.getCustomerServicePhone() );

            return pstmt.executeUpdate();
        }
    } 

    // 2. 이메일로 판매자 정보 조회
    @Override
    public SellerDTO selectByEmail(Connection conn, String email) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement("select * from seller where email = ?");
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            SellerDTO seller = null;
            if (rs.next()) {
                seller = SellerDTO.builder()
                        .sellerId(rs.getInt("seller_id"))
                        .email(rs.getString("email"))
                        .password(rs.getString("password"))
                        .businessNumber(rs.getString("business_number"))
                        .representativeName(rs.getString("representative_name"))
                        .mailOrderNumber(rs.getString("mail_order_number"))
                        .businessAddress(rs.getString("business_address"))
                        .representativeContact(rs.getString("representative_contact"))
                        .customerServicePhone(rs.getString("customer_service_phone"))
                        .status(rs.getString("status"))
                        .build();
            }
            return seller;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    } 

    // 3. 이메일 중복 검사 
    @Override
    public String emailCheck(Connection conn, String email) {
        String sql = "SELECT COUNT(*) cnt FROM seller WHERE LOWER(email) = LOWER(?)";
        
        ResultSet rs = null;
        String jsonResult = null;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt("cnt");
                jsonResult = String.format("{\"count\":%d}", count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResult = "{\"count\":0,\"code\":\"SERVER_ERROR\"}";
        } finally {
            JdbcUtil.close(rs);
        }
        return jsonResult;
    }

    // 4. 사업자등록번호 중복 검사 
    @Override
    public String businessNumberCheck(Connection conn, String business_number) {
        String sql = " select count(*) cnt from seller where business_number = ?"; 
        ResultSet rs = null; 
        String jsonResult = null; 

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, business_number ); 
            rs = pstmt.executeQuery(); 
            if(rs.next()) { 
                int cnt = rs.getInt("cnt"); 
                jsonResult = String.format("{ \"count\":%d }", cnt); 
            }
        } catch(Exception e) { 
            e.printStackTrace(); 
        } finally { 
            JdbcUtil.close(rs); 
        }
        return jsonResult; 
    }
    
    // 5. 통신판매업 신고번호 중복 검사 
    @Override
    public String mailOrderNumberCheck(Connection conn, String mail_Order_Number) {
        String sql = " select count(*) cnt from seller where mail_Order_Number = ?"; 
        ResultSet rs = null; 
        String jsonResult = null;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, mail_Order_Number ); 
            rs = pstmt.executeQuery(); 
            if(rs.next()) {
                int cnt = rs.getInt("cnt"); 
                jsonResult = String.format("{ \"count\":%d }", cnt); 
            }
        } catch(Exception e) { 
            e.printStackTrace(); 
        } finally { 
            JdbcUtil.close(rs); 
        }
        return jsonResult; 
    }
    
    // 6. 판매자 비밀번호 변경
    @Override
    public int updatePassword(Connection conn, long sellerId, String newPassword) throws SQLException {
        String sql =
                "UPDATE seller "
              + "SET password = ? "
              + "WHERE seller_id = ?";

        try ( PreparedStatement pstmt = conn.prepareStatement(sql) ) {
            pstmt.setString(1, newPassword);
            pstmt.setLong(2, sellerId);
            return pstmt.executeUpdate();
        }
    }
}