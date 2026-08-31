package com.ohouse.product.productDetail.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.product.productDetail.dto.OptionDTO;

public interface OptionDAO {

    List<OptionDTO> viewOption(
            Connection conn,
            long product_id
    ) throws SQLException;
}