package com.ohouse.product.productDetail.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.product.productDetail.dto.ProductOptionDTO;

public interface ProductOptionDAO {

    ProductOptionDTO findProductOption(
            Connection conn,
            long product_id,
            List<Long> optionValueIds
    ) throws SQLException;
}