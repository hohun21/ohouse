package com.ohouse.product.productDetail.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

import com.ohouse.product.productDetail.dto.ProductOptionDTO;

public class ProductOptionDAOImple implements ProductOptionDAO {

    @Override
    public ProductOptionDTO findProductOption(
            Connection conn,
            long product_id,
            List<Long> optionValueIds
    ) throws SQLException {

        String placeholders = String.join(
                ", ",
                Collections.nCopies(
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
                    po.status
                FROM product_option po
                JOIN product_option_value pov
                    ON po.product_option_id = pov.product_option_id
                WHERE po.product_id = ?
                  AND pov.option_value_id IN (%s)
                GROUP BY
                    po.product_option_id,
                    po.product_id,
                    po.sku,
                    po.price,
                    po.stock,
                    po.status
                HAVING COUNT(DISTINCT pov.option_value_id) = ?
                """.formatted(placeholders);

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int index = 1;

            pstmt.setLong(index++, product_id);

            for (Long optionValueId : optionValueIds) {
                pstmt.setLong(index++, optionValueId);
            }

            pstmt.setInt(index, optionValueIds.size());

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    return new ProductOptionDTO(
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
}