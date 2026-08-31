package com.ohouse.shopping.persistence;

import com.ohouse.product.productDetail.dto.CategoryDTO;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public List<CategoryDTO> viewCategory(Connection conn, long category_id) throws SQLException {

        String sql = """
                
                 SELECT CATEGORY_ID, CATEGORY_NAME
                FROM CATEGORY
                START WITH CATEGORY_ID = (
                    SELECT CATEGORY_ID
                    FROM PRODUCT
                    WHERE PRODUCT_ID = ?
                )
                CONNECT BY PRIOR PARENT_ID = CATEGORY_ID
                """;
        List<CategoryDTO> list = null;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, category_id);

            try (ResultSet rs = pstmt.executeQuery()) {
                list = new ArrayList<>();
                while (rs.next()) {
                    list.add(
                            new CategoryDTO(
                                    rs.getLong("CATEGORY_ID"),
                                    rs.getString("CATEGORY_NAME")
                            )
                    );
                }

                return list;
            }
        }


    }
}
