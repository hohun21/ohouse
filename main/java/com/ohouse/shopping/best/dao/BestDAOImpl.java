package com.ohouse.shopping.best.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.shopping.best.dto.BestDTO;

public class BestDAOImpl implements BestDAO {

	@Override
	public List<BestDTO> getBestProducts(Connection conn) 
									throws SQLException {
		List<BestDTO> bestProducts = new ArrayList<>();
		
		String sql = """
				WITH sales AS (
				    SELECT
				        po.product_id,
				        SUM(od.quantity) AS sales_quantity
				    FROM orders_detail od
				    JOIN product_option po
				      ON po.product_option_id = od.product_option_id
				    GROUP BY po.product_id
				),
				review_score AS (
				    SELECT
				        r.product_id,
				        ROUND(AVG(r.rating), 1) AS review_score,
				        COUNT(*) AS review_count
				    FROM review r
				    GROUP BY r.product_id
				),
				main_image AS (
				    SELECT
				        product_id,
				        image_url
				    FROM product_image
				    WHERE image_type = 'THUMBNAIL'
				)
				SELECT
				    ROW_NUMBER() OVER (
				        ORDER BY s.sales_quantity DESC
				    ) AS rank,
				
				    p.product_id,
				    b.brand_name,
				    p.product_name,
				    p.discount_rate,
				    p.price,
				
				    NVL(rs.review_score, 0) AS review_score,
				    NVL(rs.review_count, 0) AS review_count,
				
				    mi.image_url,
				    s.sales_quantity
				
				FROM sales s
				JOIN product p
				  ON p.product_id = s.product_id
				JOIN brand b
				  ON b.brand_id = p.brand_id
				LEFT JOIN review_score rs
				  ON rs.product_id = p.product_id
				LEFT JOIN main_image mi
				  ON mi.product_id = p.product_id
				
				ORDER BY s.sales_quantity DESC
				FETCH FIRST 100 ROWS ONLY
					 """;
		
		 try (PreparedStatement pstmt = conn.prepareStatement(sql);
	             ResultSet rs = pstmt.executeQuery()) {

	            while (rs.next()) {
	                BestDTO dto = BestDTO.builder()
	                        .rank(rs.getInt("ranking"))
	                        .productId(rs.getInt("product_id"))
	                        .brandName(rs.getString("brand_name"))
	                        .productName(rs.getString("product_name"))
	                        .discountRate(rs.getDouble("discount_rate"))
	                        .price(rs.getLong("price"))
	                        .reviewScore(rs.getDouble("review_score"))
	                        .reviewCount(rs.getInt("review_count"))
	                        .imageUrl(rs.getString("image_url"))
	                        .salesQty(rs.getInt("sales_quantity"))
	                        .build();
	                bestProducts.add(dto);
	            }
	        }
		return bestProducts;
	}

}
