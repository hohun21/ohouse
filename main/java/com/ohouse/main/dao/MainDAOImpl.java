package com.ohouse.main.dao;

import com.ohouse.search.dto.ProductSearchDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MainDAOImpl implements MainDAO {

    @Override
    public List<ProductSearchDTO> selectRandomProducts(Connection conn) throws Exception {
        List<ProductSearchDTO> list = new ArrayList<>();
        
        String sql = """
                SELECT 
                    p.product_id, 
                    b.brand_name, 
                    p.product_name, 
                    p.discount_rate, 
                    p.price,
                    (SELECT image_url FROM product_image pi WHERE pi.product_id = p.product_id AND ROWNUM = 1) AS image_url
                FROM product p
                JOIN brand b ON p.brand_id = b.brand_id
                ORDER BY DBMS_RANDOM.VALUE
                FETCH FIRST 16 ROWS ONLY
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String imgUrl = rs.getString("image_url");
                
                ProductSearchDTO dto = ProductSearchDTO.builder()
                        .productId(rs.getInt("product_id"))
                        .brandName(rs.getString("brand_name"))
                        .productName(rs.getString("product_name"))
                        .discountRate(rs.getInt("discount_rate"))
                        .price(rs.getInt("price"))
                        .imageUrl(imgUrl != null ? imgUrl : "https://via.placeholder.com/400")
                        .build();
                        
                list.add(dto);
            }
        }
        return list;
    }
}