package com.ohouse.product.productDetail.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.product.productDetail.dto.ProductImageDTO;

public interface ProductImageDAO {

    List<ProductImageDTO> viewImage(
            Connection conn,
            long product_id
    ) throws SQLException;
}