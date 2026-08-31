package com.ohouse.seller.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.ohouse.seller.dto.BrandDTO;
import com.ohouse.util.conn.JdbcUtil;

public class BrandDAOImpl implements BrandDAO {

    private static final BrandDAOImpl instance = new BrandDAOImpl();

    private BrandDAOImpl() {
    }

    public static BrandDAOImpl getInstance() {
        return instance;
    }

    // 1. 브랜드 추가
    @Override
    public int insert(Connection conn, BrandDTO brand) throws SQLException {
        String sql =
                " INSERT INTO brand ( brand_id, brand_name, seller_id )"
                        + " VALUES (seq_brand.NEXTVAL , ?, ?) ";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            // 💡 getBrand_name -> getBrandName 으로 수정
            pstmt.setString( 1, brand.getBrandName() );
            pstmt.setInt( 2, brand.getSellerId() );

            return pstmt.executeUpdate();
        }
    } 

    // 2. 브랜드 이름으로 조회
    @Override
    public BrandDTO selectByBrandName(Connection conn, String brandName) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement("select * from brand where brand_name = ?");
            pstmt.setString(1, brandName);
            rs = pstmt.executeQuery();

            BrandDTO brand = null;
            if (rs.next()) {
                // 💡 언더바 다 빼고 깔끔하게!
                brand = BrandDTO.builder()
                        .brandId(rs.getInt("brand_Id"))
                        .brandName(rs.getString("brand_name"))
                        .sellerId(rs.getInt("seller_Id"))
                        .build();
            }
            return brand;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    } 
    
    // 3. 판매자 ID로 조회
    @Override
    public BrandDTO selectBySellerId(Connection conn, int sellerId) throws SQLException {
        String sql =
                "SELECT brand_id, brand_name, seller_id "
              + "FROM brand "
              + "WHERE seller_id = ?";

        try ( PreparedStatement pstmt = conn.prepareStatement(sql) ) {
            pstmt.setInt(1, sellerId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // 💡 여기도 언더바 싹 제거
                    return BrandDTO.builder()
                            .brandId( rs.getInt("brand_id") )
                            .brandName( rs.getString("brand_name") )
                            .sellerId( rs.getInt("seller_id") )
                            .build();
                }
            }
        }
        return null;
    } 
    
    // 4. 브랜드명 중복 검사
    @Override
    public String brandNameCheck(Connection conn, String brandName) {
        String sql = " select count(*) cnt from brand where brand_name = ?"; 
        ResultSet rs = null; 
        String jsonResult = null;
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, brandName ); 
            rs = pstmt.executeQuery(); 
            
            if (rs.next()) {
                int cnt = rs.getInt("cnt"); 
                jsonResult = String.format("{ \"count\":%d }", cnt); 
            }
            
        } catch (Exception e) { 
            e.printStackTrace(); 
            jsonResult = "{\"count\":0,\"code\":\"SERVER_ERROR\"}";
        } finally { 
            JdbcUtil.close(rs); 
        }
        return jsonResult; 
    }
}