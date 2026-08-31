package com.ohouse.product.productDetail.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.product.productDetail.dto.OptionDTO;

public class OptionDAOImple implements OptionDAO {

    @Override
    public List<OptionDTO> viewOption(
            Connection conn,
            long product_id
    ) throws SQLException {

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

        List<OptionDTO> list = new ArrayList<>();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

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
            }
        }

        return list;
    }
}