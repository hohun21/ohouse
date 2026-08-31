package com.ohouse.product.productDetail.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.product.productDetail.dto.ProductImageDTO;

public class ProductImageDAOImple implements ProductImageDAO {

    @Override
    public List<ProductImageDTO> viewImage(
            Connection conn,
            long product_id
    ) throws SQLException {

        String sql = """
                SELECT image_url,
                       sort_order
                FROM product_image
                WHERE product_id = ?
                ORDER BY sort_order
                """;

        List<ProductImageDTO> list = new ArrayList<>();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, product_id);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {

                    ProductImageDTO dto = new ProductImageDTO();

                    dto.setImage_url(rs.getString("image_url"));
                    dto.setSort_order(rs.getInt("sort_order"));

                    list.add(dto);
                }
            }
        }

        return list;
    }
}