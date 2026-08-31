package com.ohouse.seller.dao;

import java.sql.SQLException;
import java.util.List;

import com.ohouse.seller.dto.BrandDTO;
import com.ohouse.seller.dto.OptionGroupDTO;
import com.ohouse.seller.dto.OptionValueDTO;
import com.ohouse.seller.dto.ProductDTO;
import com.ohouse.seller.dto.ProductImageDTO;
import com.ohouse.seller.dto.ProductOptionDTO;
import com.ohouse.seller.dto.ProductOptionValueDTO;
import com.ohouse.seller.dto.SellerDTO;

public interface SellerDAO {
    

    // 1. 판매자 관리
	
    List<SellerDTO> getPendingSellers() throws SQLException;
    int updateSellerStatus(int sellerId, String status) throws SQLException;
    int getPendingSellerCount() throws SQLException;
    List<SellerDTO> getPendingSellersWithPaging(int startRow, int endRow) throws SQLException;
    int getTotalSellerCount() throws SQLException;
    List<SellerDTO> getSellerListWithPaging(int startRow, int endRow) throws SQLException;
    int deleteSeller(int sellerId) throws SQLException;
    List<ProductDTO> getProductListByBrandId(int brandId) throws SQLException;
    List<ProductDTO> getAllProductsForAdmin() throws SQLException;

    // 2. 상품 등록 및 관리
    
    int getBrandId(String brandName) throws SQLException;

    int insertProduct(ProductDTO dto) throws SQLException;
    ProductDTO getProductById(int productId) throws SQLException;
    int updateProduct(ProductDTO dto) throws SQLException;
    int deleteProduct(int productId) throws SQLException;
    
    int insertOptionGroup(OptionGroupDTO dto) throws SQLException;
    int insertOptionValue(OptionValueDTO dto) throws SQLException;
    List<OptionGroupDTO> getOptionGroups(int productId) throws SQLException;
    List<OptionValueDTO> getOptionValues(int optionGroupId) throws SQLException;
    void deleteOptionGroupsByProductId(int productId) throws SQLException;

    int insertProductOption(ProductOptionDTO dto) throws SQLException;
    int insertProductOptionValue(ProductOptionValueDTO dto) throws SQLException;
    List<ProductOptionDTO> getProductOptions(int productId) throws SQLException;
    int updateProductOption(ProductOptionDTO dto) throws SQLException;
    int deleteProductOption(int productOptionId) throws SQLException;
    
    int insertProductImage(ProductImageDTO imageDTO) throws SQLException;
    int deleteProductImages(int productId) throws SQLException;
    int getTotalProductCount(int brandId) throws SQLException;
    int getSoldOutProductCount(int brandId) throws SQLException;
     
}