package com.ohouse.seller.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.seller.dto.OptionGroupDTO;
import com.ohouse.seller.dto.OptionValueDTO;
import com.ohouse.seller.dto.ProductDTO;
import com.ohouse.seller.dto.ProductImageDTO;
import com.ohouse.seller.dto.ProductOptionDTO;
import com.ohouse.seller.dto.ProductOptionValueDTO;
import com.ohouse.seller.dto.SellerDTO;

public class SellerDAOImpl implements SellerDAO {

    private Connection conn = null;

    public SellerDAOImpl(Connection conn) {
        this.conn = conn;
    }

    // 1. 판매자 관리 관련 구현
    
    @Override
    public List<SellerDTO> getPendingSellers() throws SQLException {
        List<SellerDTO> list = new ArrayList<>();
        // 💡 name -> representative_name 으로 통일
        String sql = "SELECT seller_id, email, password, representative_name, status, reg_date " +
                     "FROM seller WHERE status = 'PENDING' ORDER BY seller_id DESC";

        try (PreparedStatement pstmt = this.conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(SellerDTO.builder()
                        .sellerId(rs.getInt("seller_id"))
                        .email(rs.getString("email"))
                        .password(rs.getString("password"))
                        .representativeName(rs.getString("representative_name")) // 💡 여기 수정됨!
                        .status(rs.getString("status"))
                        .regDate(rs.getDate("reg_date"))
                        .build());
            }
        }
        return list;
    }

    @Override
    public int updateSellerStatus(int sellerId, String status) throws SQLException {
        String sql = "UPDATE seller SET status = ? WHERE seller_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, sellerId);
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public int getPendingSellerCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM seller WHERE status = 'PENDING'";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    @Override
    public List<SellerDTO> getPendingSellersWithPaging(int startRow, int endRow) throws SQLException {
        List<SellerDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                   + "  SELECT a.*, ROWNUM rnum FROM ("
                   + "    SELECT seller_id, email, representative_name, status, reg_date FROM seller " // 💡 수정됨
                   + "    WHERE status = 'PENDING' ORDER BY seller_id DESC"
                   + "  ) a WHERE ROWNUM <= ?"
                   + ") WHERE rnum >= ?";

        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, endRow);
            pstmt.setInt(2, startRow);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(SellerDTO.builder()
                            .sellerId(rs.getInt("seller_id"))
                            .email(rs.getString("email"))
                            .representativeName(rs.getString("representative_name")) // 💡 수정됨
                            .status(rs.getString("status"))
                            .regDate(rs.getDate("reg_date"))
                            .build());
                }
            }
        }
        return list;
    }
    
    @Override
    public int getTotalSellerCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM seller";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    @Override
    public List<SellerDTO> getSellerListWithPaging(int startRow, int endRow) throws SQLException {
        List<SellerDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                   + "  SELECT a.*, ROWNUM rnum FROM ("
                   + "    SELECT seller_id, email, representative_name, status, reg_date FROM seller ORDER BY seller_id DESC" // 💡 수정됨
                   + "  ) a WHERE ROWNUM <= ?"
                   + ") WHERE rnum >= ?";

        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, endRow);
            pstmt.setInt(2, startRow);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(SellerDTO.builder()
                            .sellerId(rs.getInt("seller_id"))
                            .email(rs.getString("email"))
                            .representativeName(rs.getString("representative_name")) // 💡 수정됨
                            .status(rs.getString("status"))
                            .regDate(rs.getDate("reg_date"))
                            .build());
                }
            }
        }
        return list;
    }
    
    @Override
    public int deleteSeller(int sellerId) throws SQLException {
        String sql = "DELETE FROM seller WHERE seller_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, sellerId);
            return pstmt.executeUpdate();
        }
    }

    // 2. 상품 등록 및 관리 관련 구현
    @Override
    public int getBrandId(String brandName) throws SQLException {
        String sql = "SELECT brand_id FROM brand WHERE brand_name = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setString(1, brandName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt("brand_id");
            }
        }
        return -1;
    }

    @Override
    public int insertProduct(ProductDTO dto) throws SQLException {
        String sql = "INSERT INTO product (product_id, category_id, brand_id, product_name, price, description, original_price, discount_rate, created, updated, status) "
                   + "VALUES (product_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, SYSDATE, NULL, 'ACTIVE')";
        
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql, new String[] {"product_id"})) {
            pstmt.setInt(1, dto.getCategoryId());
            pstmt.setInt(2, dto.getBrandId());
            pstmt.setString(3, dto.getProductName());
            pstmt.setInt(4, dto.getPrice());
            pstmt.setString(5, dto.getDescription());
            pstmt.setInt(6, dto.getOriginalPrice());
            pstmt.setInt(7, dto.getDiscountRate());
            
            pstmt.executeUpdate();
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    @Override
    public int updateProduct(ProductDTO dto) throws SQLException {
        String sql = "UPDATE product SET category_id = ?, brand_id = ?, product_name = ?, price = ?, description = ?, original_price = ?, discount_rate = ?, updated = SYSDATE WHERE product_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, dto.getCategoryId());
            pstmt.setInt(2, dto.getBrandId());
            pstmt.setString(3, dto.getProductName());
            pstmt.setInt(4, dto.getPrice());
            pstmt.setString(5, dto.getDescription());
            pstmt.setInt(6, dto.getOriginalPrice());
            pstmt.setInt(7, dto.getDiscountRate());
            pstmt.setInt(8, dto.getProductId());
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int insertOptionGroup(OptionGroupDTO dto) throws SQLException {
        String sql = "INSERT INTO option_group (option_group_id, product_id, group_name, sort_order, required) "
                   + "VALUES (option_group_seq.NEXTVAL, ?, ?, ?, ?)";
                   
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql, new String[] {"option_group_id"})) {
            pstmt.setInt(1, dto.getProductId());
            pstmt.setString(2, dto.getGroupName());
            pstmt.setInt(3, dto.getSortOrder());
            
            int requiredVal = (dto.getRequired() != null) ? dto.getRequired() : 1;
            pstmt.setInt(4, requiredVal); 
            
            pstmt.executeUpdate();
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }
    
    @Override
    public int insertOptionValue(OptionValueDTO dto) throws SQLException {
        String sql = "INSERT INTO option_value (option_value_id, option_group_id, option_name, sort_order) VALUES (option_value_seq.NEXTVAL, ?, ?, ?)";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql, new String[] {"option_value_id"})) {
            pstmt.setInt(1, dto.getOptionGroupId());
            pstmt.setString(2, dto.getOptionName());
            pstmt.setInt(3, dto.getSortOrder());
            pstmt.executeUpdate();
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    @Override
    public int insertProductOption(ProductOptionDTO dto) throws SQLException {
        String sql = "INSERT INTO product_option (product_option_id, product_id, sku, price, stock, status) "
                   + "VALUES (product_option_seq.NEXTVAL, ?, ?, ?, ?, ?)";
                   
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql, new String[] {"product_option_id"})) {
            pstmt.setInt(1, dto.getProductId());
            pstmt.setString(2, dto.getSku());
            pstmt.setInt(3, dto.getPrice());
            pstmt.setInt(4, dto.getStock());
            
            String optStatus = (dto.getStock() == 0) ? "SOLD_OUT" : "ACTIVE";
            pstmt.setString(5, optStatus);
            
            pstmt.executeUpdate();
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    @Override
    public int updateProductOption(ProductOptionDTO dto) throws SQLException {
        String sql = "UPDATE product_option SET price = ?, stock = ?, status = ? WHERE product_option_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, dto.getPrice());
            pstmt.setInt(2, dto.getStock());
            
            String optStatus = (dto.getStock() == 0) ? "SOLD_OUT" : "ACTIVE";
            pstmt.setString(3, optStatus);
            
            pstmt.setInt(4, dto.getProductOptionId());
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int deleteProductOption(int productOptionId) throws SQLException {
        String sql = "DELETE FROM product_option WHERE product_option_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, productOptionId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int insertProductOptionValue(ProductOptionValueDTO dto) throws SQLException {
        String sql = "INSERT INTO product_option_value (product_option_value_id, product_option_id, option_value_id) VALUES (product_option_value_seq.NEXTVAL, ?, ?)";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, dto.getProductOptionId());
            pstmt.setInt(2, dto.getOptionValueId());
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public List<ProductOptionDTO> getProductOptions(int productId) throws SQLException {
        List<ProductOptionDTO> list = new ArrayList<>();
        String sql = "SELECT product_option_id, sku, price, stock, status FROM product_option WHERE product_id = ? ORDER BY product_option_id ASC";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(ProductOptionDTO.builder()
                            .productOptionId(rs.getInt("product_option_id"))
                            .productId(productId)
                            .sku(rs.getString("sku"))
                            .price(rs.getInt("price"))
                            .stock(rs.getInt("stock"))
                            .status(rs.getString("status"))
                            .build());
                }
            }
        }
        return list;
    }
    
    @Override
    public int deleteProduct(int productId) throws SQLException {
        String sql = "DELETE FROM product WHERE product_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public ProductDTO getProductById(int productId) throws SQLException {
        String sql = "SELECT p.product_id, p.category_id, p.brand_id, p.product_name, p.price, p.description, p.original_price, p.discount_rate, b.brand_name " +
                     "FROM product p JOIN brand b ON p.brand_id = b.brand_id WHERE p.product_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return ProductDTO.builder()
                            .productId(rs.getInt("product_id"))
                            .categoryId(rs.getInt("category_id"))
                            .brandId(rs.getInt("brand_id"))
                            .brandName(rs.getString("brand_name"))
                            .productName(rs.getString("product_name"))
                            .price(rs.getInt("price"))
                            .description(rs.getString("description"))
                            .originalPrice(rs.getInt("original_price"))
                            .discountRate(rs.getInt("discount_rate"))
                            .build();
                }
            }
        }
        return null;
    }
    
    @Override
    public List<OptionGroupDTO> getOptionGroups(int productId) throws SQLException {
        List<OptionGroupDTO> list = new ArrayList<>();
        String sql = "SELECT option_group_id, product_id, group_name, sort_order, required FROM option_group WHERE product_id = ? ORDER BY sort_order ASC";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(OptionGroupDTO.builder()
                            .optionGroupId(rs.getInt("option_group_id"))
                            .productId(rs.getInt("product_id"))
                            .groupName(rs.getString("group_name"))
                            .sortOrder(rs.getInt("sort_order"))
                            .required(rs.getInt("required"))
                            .build());
                }
            }
        }
        return list;
    }

    @Override
    public List<OptionValueDTO> getOptionValues(int optionGroupId) throws SQLException {
        List<OptionValueDTO> list = new ArrayList<>();
        String sql = "SELECT option_value_id, option_group_id, option_name, sort_order FROM option_value WHERE option_group_id = ? ORDER BY sort_order ASC";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, optionGroupId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(OptionValueDTO.builder()
                            .optionValueId(rs.getInt("option_value_id"))
                            .optionGroupId(rs.getInt("option_group_id"))
                            .optionName(rs.getString("option_name"))
                            .sortOrder(rs.getInt("sort_order"))
                            .build());
                }
            }
        }
        return list;
    }

    @Override
    public void deleteOptionGroupsByProductId(int productId) throws SQLException {
        String sql = "DELETE FROM option_group WHERE product_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            pstmt.executeUpdate();
        }
    }

    @Override
    public int insertProductImage(ProductImageDTO imageDTO) throws SQLException {
        String sql = "INSERT INTO product_image (image_id, product_id, image_url, image_type, sort_order) VALUES (seq_product_image.NEXTVAL, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, imageDTO.getProductId());
            pstmt.setString(2, imageDTO.getImageUrl());
            pstmt.setString(3, imageDTO.getImageType());
            pstmt.setInt(4, imageDTO.getSortOrder());
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public int deleteProductImages(int productId) throws SQLException {
        String sql = "DELETE FROM product_image WHERE product_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            return pstmt.executeUpdate();
        }
    }
    
    @Override
    public int getTotalProductCount(int brandId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM product WHERE brand_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, brandId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    @Override
    public int getSoldOutProductCount(int brandId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM (" +
                     "SELECT p.product_id FROM product p " +
                     "JOIN product_option po ON p.product_id = po.product_id " +
                     "WHERE p.brand_id = ? " + // 💡 내 아이디 필터링
                     "GROUP BY p.product_id HAVING SUM(po.stock) = 0)";
                     
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, brandId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
    
    @Override
    public List<ProductDTO> getProductListByBrandId(int brandId) throws SQLException {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT product_id, category_id, brand_id, product_name, price, description, original_price, discount_rate, status, created, updated " +
                     "FROM product WHERE brand_id = ? ORDER BY product_id DESC";
        
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, brandId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(ProductDTO.builder()
                            .productId(rs.getInt("product_id"))
                            .categoryId(rs.getInt("category_id"))
                            .brandId(rs.getInt("brand_id"))
                            .productName(rs.getString("product_name"))
                            .price(rs.getInt("price"))
                            .description(rs.getString("description"))
                            .originalPrice(rs.getInt("original_price"))
                            .discountRate(rs.getInt("discount_rate"))
                            .status(rs.getString("status"))
                            .created(rs.getDate("created"))
                            .updated(rs.getDate("updated"))
                            .build());
                }
            }
        }
        return list;
    }
    
    public List<ProductDTO> getAllProductsForAdmin() throws SQLException {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.category_id, p.brand_id, b.brand_name, p.product_name, p.price, p.status, p.created " +
                     "FROM product p JOIN brand b ON p.brand_id = b.brand_id ORDER BY p.product_id DESC";
        
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(ProductDTO.builder()
                        .productId(rs.getInt("product_id"))
                        .categoryId(rs.getInt("category_id"))
                        .brandId(rs.getInt("brand_id"))
                        .brandName(rs.getString("brand_name")) // 💡 상호명 세팅
                        .productName(rs.getString("product_name"))
                        .price(rs.getInt("price"))
                        .status(rs.getString("status"))
                        .created(rs.getDate("created"))
                        .build());
            }
        }
        return list;
    }
}