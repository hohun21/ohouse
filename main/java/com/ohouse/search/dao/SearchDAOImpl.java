package com.ohouse.search.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.search.dto.KeyWordDTO;
import com.ohouse.search.dto.ProductSearchDTO;

public class SearchDAOImpl implements SearchDAO {

    @Override
    public void upsertKeyword(Connection conn, String keyword) throws Exception {
        String sql = "MERGE INTO keyword k " +
                     "USING (SELECT ? AS search_keyword FROM DUAL) src " +
                     "ON (k.keyword = src.search_keyword) " +
                     "WHEN MATCHED THEN " +
                     "    UPDATE SET k.search_count = k.search_count + 1 " +
                     "WHEN NOT MATCHED THEN " +
                     "    INSERT (keyword_id, keyword, search_count, reg_date) " +
                     "    VALUES (keyword_seq.NEXTVAL, src.search_keyword, 1, SYSDATE)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, keyword);
            pstmt.executeUpdate();
        }
    }

    @Override
    public List<ProductSearchDTO> selectProductsByKeyword(Connection conn, String keyword) throws Exception {
        List<ProductSearchDTO> productList = new ArrayList<>();
        
        String sql = "SELECT p.product_id, " +
                     "       b.brand_name, " +
                     "       p.product_name, " +
                     "       p.price, " +
                     "       p.discount_rate, " +
                     "       img.image_url, " +
                     "       p.status, " +
                     "       COUNT(po.product_id) AS option_count, " + 
                     "       NVL(SUM(po.stock), 0) AS total_stock, " +
                     "       NVL(r.avg_rating, 0) AS avgRating, " +
                     "       NVL(r.review_count, 0) AS reviewCount " +
                     "FROM product p " +
                     "JOIN brand b ON p.brand_id = b.brand_id " +
                     "LEFT JOIN product_image img ON p.product_id = img.product_id AND img.image_type = 'THUMBNAIL' " +
                     "LEFT JOIN product_option po ON p.product_id = po.product_id " +
                     "LEFT JOIN ( " +
                     "    SELECT product_id, AVG(rating) AS avg_rating, COUNT(review_id) AS review_count " +
                     "    FROM review GROUP BY product_id " +
                     ") r ON p.product_id = r.product_id " +
                     "WHERE p.product_name LIKE '%' || ? || '%' " +
                     "  AND p.status != 'STOP' " +
                     "GROUP BY p.product_id, b.brand_name, p.product_name, p.price, p.discount_rate, img.image_url, p.status, r.avg_rating, r.review_count " +
                     "ORDER BY p.product_id DESC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, keyword);    
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int optionCount = rs.getInt("option_count");
                    int totalStock = rs.getInt("total_stock");
                    String currentStatus = rs.getString("status");

                    if (optionCount > 0 && totalStock <= 0) {
                        currentStatus = "SOLD_OUT";
                    }

                    ProductSearchDTO product = ProductSearchDTO.builder()
                            .productId(rs.getInt("product_id"))
                            .brandName(rs.getString("brand_name"))
                            .productName(rs.getString("product_name"))
                            .price(rs.getInt("price"))
                            .discountRate(rs.getInt("discount_rate"))
                            .imageUrl(rs.getString("image_url"))
                            .status(currentStatus)
                            .avgRating(rs.getDouble("avgRating"))
                            .reviewCount(rs.getInt("reviewCount"))
                            .build();
                    
                    productList.add(product);
                }
            }
        }
        
        return productList;
    }

    @Override
    public void updateKeywordRanks(Connection conn) throws Exception {
        String sql = "MERGE INTO keyword k " +
                     "USING ( " +
                     "    SELECT keyword_id, ROW_NUMBER() OVER (ORDER BY search_count DESC, keyword_id ASC) as rnk " +
                     "    FROM keyword " +
                     ") src " +
                     "ON (k.keyword_id = src.keyword_id) " +
                     "WHEN MATCHED THEN " +
                     "UPDATE SET k.previous_rank = k.current_rank, " +
                     "           k.current_rank = src.rnk";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.executeUpdate();
        }
    }
    
    @Override
    public List<KeyWordDTO> selectTop10Keywords(Connection conn) throws Exception {
        List<KeyWordDTO> list = new ArrayList<>();
        
        String sql = "SELECT keyword_id, keyword, search_count, current_rank, previous_rank, reg_date, " +
                "       CASE WHEN reg_date >= SYSDATE - 1 THEN 1 ELSE 0 END AS is_new " +
                "FROM keyword " +
                "WHERE current_rank <= 10 " +
                "ORDER BY current_rank ASC";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
             
            while (rs.next()) {
                KeyWordDTO dto = KeyWordDTO.builder()
                        .keywordId(rs.getInt("keyword_id"))
                        .keyword(rs.getString("keyword"))
                        .searchCount(rs.getInt("search_count"))
                        .currentRank(rs.getInt("current_rank"))
                        .previousRank(rs.getInt("previous_rank"))
                        .regDate(rs.getDate("reg_date"))
                        .isNew(rs.getInt("is_new"))
                        .build();
                list.add(dto);
            }
        }
        return list;
    }
}