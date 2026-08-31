package com.ohouse.seller.dao;

import java.sql.Connection;
import java.sql.SQLException;

import com.ohouse.seller.dto.BrandDTO;

public interface BrandDAO {
    // 1. 브랜드 추가
    int insert(Connection conn, BrandDTO brand) throws SQLException;

    // 2. 브랜드 이름으로 브랜드 정보 조회
    BrandDTO selectByBrandName(Connection conn, String brandName) throws SQLException;
    
    // 3. 판매자 ID로 브랜드 정보 조회 (long -> int 로 통일)
    BrandDTO selectBySellerId(Connection conn, int sellerId) throws SQLException;
    
    // 4. 상호명 중복 검사 후 json 데이터 반환
    String brandNameCheck(Connection conn, String brandName) throws SQLException;
}