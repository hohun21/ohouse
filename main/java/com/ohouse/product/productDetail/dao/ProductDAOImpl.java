package com.ohouse.product.productDetail.dao;


import com.ohouse.product.productDetail.dto.OptionDTO;
import com.ohouse.product.productDetail.dto.ProductDTO;
import com.ohouse.product.productDetail.dto.ProductImageDTO;
import com.ohouse.product.productDetail.dto.ProductOptionDTO;
import com.ohouse.shopping.category.dto.CategoryDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    ProductImageDAO imageDAO = new ProductImageDAOImple();

	
    public ProductDTO viewProduct(Connection conn, long product_id) throws SQLException {

        String sql = """
                select b.brand_name
                      ,p.product_name
                      ,p.original_price
                      ,p.price
                      ,p.category_id
                      ,p.discount_rate
                      from product p join brand b
                      on p.brand_id = b.brand_id
                      where p.product_id = ?
                """;
        ProductDTO pdto = null;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, product_id);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    pdto = ProductDTO.builder()

                            .brand_name(rs.getString("brand_name"))
                            .product_name(rs.getString("product_name"))
                            .original_price(rs.getLong("original_price"))
                            .price(rs.getLong("price"))
                            .category_id(rs.getLong("category_id"))
                            .discount_rate(rs.getDouble("discount_rate"))
                            .build();
                }
            }
        }

        return pdto;
    }

    // 전체 상품 보기
    public List<ProductDTO> allviewProduct(Connection conn) throws SQLException {
        String sql = """
                        select pi.image_url,
                               p.product_id,
                               b.brand_name,
                               p.product_name,
                               p.discount_rate,
                               p.price
                               from product p join brand b
                               on p.brand_id = b.brand_id
                               join product_image pi
                               on p.product_id = pi.product_id
                """;
        ProductDTO pdto = null;
        List<ProductDTO> list = null;
        try (
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery();
        ) {
            while (rs.next()) {
                list = new ArrayList<>();
                pdto = ProductDTO.builder()
                        .image_url(rs.getString("image_url"))
                        .product_id(rs.getLong("product_id"))
                        .brand_name(rs.getString("brand_name"))
                        .product_name(rs.getString("product_name"))
                        .original_price(rs.getLong("price"))
                        .discount_rate(rs.getDouble("discount_rate"))
                        .build();

                list.add(pdto);
            }
        }
        return list;
    }

    public List<ProductImageDTO> viewImage(Connection conn, long product_id) throws SQLException {

        String sql = """
                
                   select image_url,sort_order
                from product_image
                where product_id = ?
                   order by sort_order
                """;
        List<ProductImageDTO> list = null;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, product_id);

            try (ResultSet rs = pstmt.executeQuery()) {
                list = new ArrayList<>();
                while (rs.next()) {

                    ProductImageDTO dto = new ProductImageDTO();


                    dto.setImage_url(rs.getString("IMAGE_URL"));

                    dto.setSort_order(rs.getInt("SORT_ORDER"));

                    list.add(dto);

                }
            }
        }

        return list;
    }

    public ProductOptionDTO findProductOption(
            Connection conn,
            long product_id,
            List<Long> optionValueIds
    ) throws SQLException {

        String placeholders = String.join(
                ", ",
                java.util.Collections.nCopies(
                        optionValueIds.size(),
                        "?"
                )
        );

        String sql = """
                
                SELECT
                   po.product_option_id,
                   po.product_id,
                   po.sku,
                   po.price,
                   po.stock,
                                                                  po.status,
                                                                  p.brand_id,
                                                                  b.brand_name
                                                              FROM product_option po
                                                              JOIN product_option_value pov
                                                                  ON po.product_option_id = pov.product_option_id
                                                              JOIN product p
                                                                  ON po.product_id = p.product_id
                                                              JOIN brand b
                                                                  ON p.brand_id = b.brand_id
                                                              WHERE po.product_id = ?
                                                                AND pov.option_value_id IN (%s)
                                                              GROUP BY
                                                                  po.product_option_id,
                                                                  po.product_id,
                                                                  po.sku,
                                                                  po.price,
                                                                  po.stock,
                                                                  po.status,
                                                                  p.brand_id,
                                                                  b.brand_name
                                                              HAVING COUNT(DISTINCT pov.option_value_id) = ?
                """.formatted(placeholders);

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int index = 1;

            // product_id
            pstmt.setLong(index++, product_id);

            // option_value_id들
            for (Long option_value_id : optionValueIds) {
                pstmt.setLong(index++, option_value_id);
            }

            // 선택한 옵션 개수
            pstmt.setInt(index, optionValueIds.size());

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    return new ProductOptionDTO(
                            rs.getLong("brand_id"),
                            rs.getString("brand_name"),
                            rs.getLong("product_option_id"),
                            rs.getLong("product_id"),
                            rs.getString("sku"),
                            rs.getLong("price"),
                            rs.getLong("stock"),
                            rs.getString("status")
                    );
                }
            }
        }

        return null;
    }


    public List<OptionDTO> viewOption(Connection conn, long product_id) throws SQLException {

        String sql = """
                  SELECT
                    og.option_group_id,
                    og.group_name,
                    og.required,
                    ov.option_value_id,
                    ov.option_name
                FROM option_group og
                JOIN option_value ov
                    ON og.option_group_id = ov.option_group_id
                WHERE og.product_id = ?
                ORDER BY og.sort_order, ov.sort_order
                """;
        List<OptionDTO> list = null;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            list = new ArrayList<>();
            pstmt.setLong(1, product_id);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    list.add(
                            new OptionDTO(
                                    rs.getLong("option_group_id"),
                                    rs.getString("group_name"),
                                    rs.getString("required"),
                                    rs.getLong("option_value_id"),
                                    rs.getString("option_name")
                            )
                    );
                }

                return list;
            }
        }

    }

    public List<CategoryDTO> viewCategory(Connection conn, long category_id) throws SQLException {

    	String sql = """
    	        SELECT CATEGORY_ID,
    	               CATEGORY_NAME
    	        FROM CATEGORY
    	        START WITH CATEGORY_ID = (
    	            SELECT CATEGORY_ID
    	            FROM PRODUCT
    	            WHERE PRODUCT_ID = ?
    	        )
    	        CONNECT BY PRIOR PARENT_ID = CATEGORY_ID
    	        ORDER BY LEVEL DESC
    	        """;
        List<CategoryDTO> list = null;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, category_id);

            try (ResultSet rs = pstmt.executeQuery()) {
                list = new ArrayList<>();
                while (rs.next()) {
                    list.add(
                            new CategoryDTO(
                                    rs.getInt("CATEGORY_ID"),
                                    rs.getString("CATEGORY_NAME")
                            )
                    );
                }

                return list;
            }
        }


    }

	@Override
	public List<ProductDTO> viewProductByCategories(Connection conn, List<Integer> categoryIds) throws SQLException {
		 if (categoryIds == null || categoryIds.isEmpty()) {
		        return new ArrayList<>();
		    }
		 String placeholders = String.join(
		            ",",
		            categoryIds.stream()
		                    .map(id -> "?")
		                    .toList()
		    );
		    String sql = """
		            SELECT p.product_id,
		                   p.brand_id,
		                   b.brand_name,
		                   p.product_name,
		                   p.original_price,
		                   p.price,
		                   p.category_id,
		                   p.discount_rate
		            FROM product p
		            JOIN brand b
		              ON p.brand_id = b.brand_id
		            WHERE p.category_id IN (%s)
		            ORDER BY p.product_id
		            """.formatted(placeholders);

		    List<ProductDTO> list = new ArrayList<>();
		    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
		        for (int i = 0; i < categoryIds.size(); i++) {
		            pstmt.setInt(i + 1, categoryIds.get(i));
		        }

		        try (ResultSet rs = pstmt.executeQuery()) {
		            while (rs.next()) {
		                ProductDTO pdto = new ProductDTO(
		                        rs.getLong("brand_id"),
		                        rs.getString("product_name"),
		                        rs.getLong("original_price"),
		                        rs.getLong("price"),
		                        rs.getLong("category_id"),
		                        rs.getDouble("discount_rate")
		                );
		                pdto.setBrand_name(
		                        rs.getString("brand_name")
		                );
		                pdto.setProduct_id(
		                        rs.getLong("product_id")
		                );
		                List<ProductImageDTO> images =
		                        imageDAO.viewImage(
		                                conn,
		                                rs.getLong("product_id")
		                        );
		                if (images != null && !images.isEmpty()) {
		                    pdto.setImage_url(
		                            images.get(0).getImage_url()
		                    );
		                }
		                list.add(pdto);
		            }
		        }
		    }
		    return list;
	}
}

