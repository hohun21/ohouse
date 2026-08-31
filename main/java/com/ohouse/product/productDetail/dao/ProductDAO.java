package com.ohouse.product.productDetail.dao;

import com.ohouse.product.productDetail.dto.ProductDTO;
import com.ohouse.product.productDetail.dto.ProductImageDTO;
import com.ohouse.product.productDetail.dto.ProductOptionDTO;
import com.ohouse.product.productDetail.dto.OptionDTO;
import com.ohouse.shopping.category.dto.CategoryDTO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface ProductDAO {

    ProductDTO viewProduct(Connection conn, long product_id) throws SQLException;

    List<ProductDTO> allviewProduct(Connection conn) throws SQLException;

    List<ProductImageDTO> viewImage(Connection conn, long product_id) throws SQLException;

    ProductOptionDTO findProductOption(Connection conn, long product_id, List<Long> optionValueIds) throws SQLException;

    List<OptionDTO> viewOption(Connection conn, long product_id) throws SQLException;

    List<CategoryDTO> viewCategory(Connection conn, long category_id) throws SQLException;

    List<ProductDTO> viewProductByCategories( Connection conn, List<Integer> categoryIds ) throws SQLException;
}
