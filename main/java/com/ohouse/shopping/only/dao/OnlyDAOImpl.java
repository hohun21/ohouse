package com.ohouse.shopping.only.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.shopping.best.dto.BestDTO;
import com.ohouse.shopping.only.dto.OnlyDTO;

public class OnlyDAOImpl implements OnlyDAO {

	@Override
	public List<OnlyDTO> getAllOnlyProducts(Connection conn) throws SQLException {
		List<OnlyDTO> allProducts = new ArrayList<>();

		String sql = """
				WITH review_score AS (
					SELECT
						r.product_id,
						ROUND(AVG(r.rating), 1) AS review_score,
						COUNT(*) AS review_count
					FROM review r
					GROUP BY r.product_id
				),main_image AS (
					SELECT product_id, image_url
					FROM product_image
					WHERE image_type = 'THUMBNAIL'
				)
				SELECT p.product_id,
				    b.brand_name,
				    p.product_name,
				    p.price,
				    p.created,
				    p.discount_rate,
				    NVL(rs.review_score, 0) AS review_score,
				    NVL(rs.review_count, 0) AS review_count,
				    mi.image_url
				FROM product p
				JOIN brand b ON b.brand_id = p.brand_id
				LEFT JOIN review_score rs ON rs.product_id = p.product_id
				LEFT JOIN main_image mi ON mi.product_id = p.product_id
				WHERE p.product_name LIKE '[오늘의집 단독]%' AND p.status = 'ACTIVE'
				ORDER BY p.created DESC
				""";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql);
	             ResultSet rs = pstmt.executeQuery()) {

	            while (rs.next()) {
	                OnlyDTO dto = OnlyDTO.builder()
	                        .productId(rs.getInt("product_id"))
	                        .brandName(rs.getString("brand_name"))
	                        .productName(rs.getString("product_name"))
	                        .discountRate(rs.getDouble("discount_rate"))
	                        .price(rs.getLong("price"))
	                        .reviewScore(rs.getDouble("review_score"))
	                        .reviewCount(rs.getInt("review_count"))
	                        .imageUrl(rs.getString("image_url"))
	                        .created(rs.getDate("created"))
	                        .build();
	                allProducts.add(dto);
	            }
	        }
		return allProducts;
	}
	
	@Override
	public List<OnlyDTO> getOnlyProductsByMainCategory(
	        Connection conn,
	        int mainCategoryId
	) throws SQLException {

	    List<OnlyDTO> onlyProducts = new ArrayList<>();

	    String sql = """
	            WITH category_tree AS (
	                SELECT category_id
	                FROM category
	                START WITH category_id = ?
	                CONNECT BY PRIOR category_id = parent_id
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
	                p.product_id,
	                b.brand_name,
	                p.product_name,
	                p.price,
	                p.created,
	                p.discount_rate,
	                NVL(rs.review_score, 0) AS review_score,
	                NVL(rs.review_count, 0) AS review_count,
	                mi.image_url
	            FROM product p
	            JOIN brand b
	              ON b.brand_id = p.brand_id
	            LEFT JOIN review_score rs
	              ON rs.product_id = p.product_id
	            LEFT JOIN main_image mi
	              ON mi.product_id = p.product_id
	            WHERE p.category_id IN (
	                SELECT category_id
	                FROM category_tree
	            )
	              AND p.product_name LIKE '[오늘의집 단독]%'
	              AND p.status = 'ACTIVE'
	            ORDER BY p.created DESC
	            """;

	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, mainCategoryId);

	        try (ResultSet rs = pstmt.executeQuery()) {

	            while (rs.next()) {

	                OnlyDTO dto = OnlyDTO.builder()
	                        .productId(rs.getInt("product_id"))
	                        .brandName(rs.getString("brand_name"))
	                        .productName(rs.getString("product_name"))
	                        .discountRate(rs.getDouble("discount_rate"))
	                        .price(rs.getLong("price"))
	                        .reviewScore(rs.getDouble("review_score"))
	                        .reviewCount(rs.getInt("review_count"))
	                        .imageUrl(rs.getString("image_url"))
	                        .created(rs.getDate("created"))
	                        .build();

	                onlyProducts.add(dto);
	            }
	        }
	    }

	    return onlyProducts;
	}
	
}
