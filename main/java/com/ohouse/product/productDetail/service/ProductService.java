package com.ohouse.product.productDetail.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.shopping.category.dao.CategoryDAO;
import com.ohouse.shopping.category.dao.CategoryDAOImple;
import com.ohouse.product.productDetail.dao.OptionDAO;
import com.ohouse.product.productDetail.dao.OptionDAOImple;
import com.ohouse.product.productDetail.dao.ProductDAO;
import com.ohouse.product.productDetail.dao.ProductDAOImpl;
import com.ohouse.product.productDetail.dao.ProductImageDAO;
import com.ohouse.product.productDetail.dao.ProductImageDAOImple;
import com.ohouse.product.productDetail.dao.ProductOptionDAOImple;
import com.ohouse.shopping.category.dto.CategoryDTO;
import com.ohouse.product.productDetail.dto.OptionDTO;
import com.ohouse.product.productDetail.dto.ProductDTO;
import com.ohouse.product.productDetail.dto.ProductDetailDTO;
import com.ohouse.product.productDetail.dto.ProductImageDTO;
import com.ohouse.product.productDetail.dto.ProductOptionDTO;
import com.ohouse.shopping.domain.CouponDTO;
import com.ohouse.shopping.persistence.CouponDAO;
import com.ohouse.util.conn.ConnectionProvider;

public class ProductService {

    private ProductDAO productdao = new ProductDAOImpl();

    private ProductImageDAO imageDAO = new ProductImageDAOImple();
    private OptionDAO optionDAO = new OptionDAOImple();
    private CategoryDAO categoryDAO = new CategoryDAOImple();
    private ProductOptionDAOImple productOptionDAO = new ProductOptionDAOImple();

    public List<ProductDTO> getProductListByCategories(
            Connection conn,
            List<Integer> categoryIds
    ) throws SQLException {

        return productdao.viewProductByCategories(conn, categoryIds);
    }
    
    private CouponDAO couponDAO = new CouponDAO();

    // 상품 상세 조회
    public ProductDetailDTO getProductDetail(long product_id) throws Exception {

        try (Connection conn = ConnectionProvider.getConnection()) {

            ProductDTO product =
                    productdao.viewProduct(conn, product_id);

            List<ProductImageDTO> images =
                    productdao.viewImage(conn, product_id);

            List<OptionDTO> options =
                    productdao.viewOption(conn, product_id);

            List<CategoryDTO> categories =
                    productdao.viewCategory(conn, product_id);

            ProductDetailDTO detail = new ProductDetailDTO();

            detail.setProductDTO(product);
            detail.setImageDTOList(images);
            detail.setOptionDTOList(options);
            detail.setCategoryDTOList(categories);

            return detail;
        }
    }

    // 선택한 옵션 조합의 상품 옵션 조회
    public ProductOptionDTO getProductOption(
            long product_id,
            List<Long> optionValueIds
    ) throws Exception {

        try (Connection conn = ConnectionProvider.getConnection()) {

            return productdao.findProductOption(
                    conn,
                    product_id,
                    optionValueIds
            );
        }
    }

    // 쇼핑홈에서 전체 상품 가져오기
    public List<ProductDTO> getProductList() throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {

            List<ProductDTO> pdto = productdao.allviewProduct(conn);
            return pdto;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
    // 쿠폰 조회하기
    public List<CouponDTO> getCouponList(int member_id) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            List<CouponDTO> clist = couponDAO.selectAllCoupons(conn, member_id);
            return clist;
        }
    }
}