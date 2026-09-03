package com.ohouse.seller.dao;

import java.sql.Connection;
import java.sql.SQLException;

import com.ohouse.seller.dto.SellerDTO;

public interface SellerAuthDAO {
	
	 // 판매자 회원가입
    int insert( Connection conn, SellerDTO seller) throws SQLException;

    // 이메일로 판매자 정보 조회
    SellerDTO selectByEmail( Connection conn, String email ) throws SQLException;
    
    // 이메일 중복 검사 후 json 데이터 반환
    String emailCheck(Connection conn, String email) throws SQLException;
    
    // 사업자등록번호 중복 검사 후 json 데이터 반환
    String businessNumberCheck(Connection conn, String buisiness_number) throws SQLException;
    
    // 통신판매업 신고번호 중복 검사 후 json 데이터 반환
    String mailOrderNumberCheck(Connection conn, String mail_Order_Number) throws SQLException;

    // 판매자 status 검사 후 json 데이터 반환
    String statusCheck(Connection conn, String email) throws SQLException;

    // 판매자 비밀번호 변경
    int updatePassword( Connection conn, long sellerId, String newPassword) throws SQLException;
}
