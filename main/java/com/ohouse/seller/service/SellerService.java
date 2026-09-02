package com.ohouse.seller.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ohouse.seller.dao.SellerDAO;
import com.ohouse.seller.dao.SellerDAOImpl;
import com.ohouse.seller.dto.OptionGroupDTO;
import com.ohouse.seller.dto.OptionValueDTO;
import com.ohouse.seller.dto.ProductDTO;
import com.ohouse.seller.dto.ProductFormDTO;
import com.ohouse.seller.dto.ProductImageDTO;
import com.ohouse.seller.dto.ProductOptionDTO;
import com.ohouse.seller.dto.ProductOptionValueDTO;
import com.ohouse.seller.dto.SellerDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class SellerService {

    // 1-1. 상품 단건 조회
    public ProductDTO getProductById(int productId) {
        Connection conn = null;
        ProductDTO product = null;
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            product = dao.getProductById(productId);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return product;
    }
    
    // 1-2. 상품 옵션 목록 조회
    public List<ProductOptionDTO> getOptionsByProductId(int productId) {
        Connection conn = null;
        List<ProductOptionDTO> optionList = null;
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            optionList = dao.getProductOptions(productId);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
        return optionList;
    }

    // 2. 상품 등록 로직 (성공 시 생성된 productId 반환, 실패 시 -1 반환)
    public int registerProduct(ProductFormDTO form) {
        
        Connection conn = null;
        int generatedProductId = -1;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); 
            
            SellerDAO dao = new SellerDAOImpl(conn);

            int brandId = dao.getBrandId(form.getBrandName());
            if (brandId == -1) {
                throw new SQLException("등록된 브랜드 정보를 찾을 수 없습니다: " + form.getBrandName());
            }
            
            ProductDTO productDTO = ProductDTO.builder()
                    .categoryId(form.getCategoryId())
                    .brandId(brandId)
                    .productName(form.getProductName())
                    .description(form.getDescription())
                    .originalPrice(form.getOriginalPrice())
                    .discountRate(form.getDiscountRate())
                    .price(form.getPrice())
                    .build();
            int productId = dao.insertProduct(productDTO);

            if (form.getImageUrls() != null && !form.getImageUrls().isEmpty()) {
                for (int i = 0; i < form.getImageUrls().size(); i++) {
                    ProductImageDTO imageDTO = ProductImageDTO.builder()
                            .productId(productId)
                            .imageUrl(form.getImageUrls().get(i))
                            .imageType(form.getImageTypes().get(i))
                            .sortOrder(form.getSortOrders().get(i))
                            .build();
                    dao.insertProductImage(imageDTO);
                }
            }

            Map<String, Integer> optionValueIdMap = new HashMap<>();
            int optionGroupCount = 0;

            // 1) 필수 옵션 그룹 및 옵션 값 등록
            if (form.getOptionNames() != null && form.getOptionValues() != null) {
                for (int i = 0; i < form.getOptionNames().length; i++) {
                    if (form.getOptionNames()[i].trim().equals("")) continue;

                    optionGroupCount++;

                    OptionGroupDTO groupDTO = OptionGroupDTO.builder()
                            .productId(productId)
                            .groupName(form.getOptionNames()[i])
                            .sortOrder(optionGroupCount)
                            .required(1)
                            .build();
                    int optionGroupId = dao.insertOptionGroup(groupDTO);
                    
                    String[] values = form.getOptionValues()[i].split(",");
                    for (int j = 0; j < values.length; j++) {
                        String optName = values[j].trim();
                        if (optName.equals("")) continue;
                        
                        OptionValueDTO valueDTO = OptionValueDTO.builder()
                                .optionGroupId(optionGroupId)
                                .optionName(optName)
                                .sortOrder(j + 1)
                                .build();
                    
                        int optionValueId = dao.insertOptionValue(valueDTO);
                        optionValueIdMap.put(optName, optionValueId);
                    }
                }
            }

            // 2) 필수 옵션 조합 (SKU) 등록
            if (form.getSkuNames() != null) {
                for (int i = 0; i < form.getSkuNames().length; i++) {
                    String currentSku = form.getSkuNames()[i];
                    ProductOptionDTO skuDTO = ProductOptionDTO.builder()
                            .productId(productId)
                            .sku(currentSku)
                            .price(Integer.parseInt(form.getSkuPrices()[i]))
                            .stock(Integer.parseInt(form.getSkuStocks()[i]))
                            .build();
                    
                    int productOptionId = dao.insertProductOption(skuDTO);

                    for (String optName : optionValueIdMap.keySet()) {
                        if (currentSku.contains(optName)) {
                            ProductOptionValueDTO mappingDTO = ProductOptionValueDTO.builder()
                                    .productOptionId(productOptionId)
                                    .optionValueId(optionValueIdMap.get(optName))
                                    .build();
                            dao.insertProductOptionValue(mappingDTO);
                        }
                    }
                }
            }

            // 3) 추가 상품 등록 로직
            if (form.getExtraNames() != null && form.getExtraNames().length > 0) {
                OptionGroupDTO extraGroupDTO = OptionGroupDTO.builder()
                        .productId(productId)
                        .groupName("추가상품")
                        .sortOrder(optionGroupCount + 1) 
                        .required(0)
                        .build();
                int extraGroupId = dao.insertOptionGroup(extraGroupDTO);

                for (int i = 0; i < form.getExtraNames().length; i++) {
                    if (form.getExtraNames()[i].trim().equals("")) continue;

                    String extraName = form.getExtraNames()[i].trim();
                    int extraPrice = Integer.parseInt(form.getExtraPrices()[i]);
                    int extraStock = Integer.parseInt(form.getExtraStocks()[i]);

                    OptionValueDTO extraValueDTO = OptionValueDTO.builder()
                            .optionGroupId(extraGroupId)
                            .optionName(extraName)
                            .sortOrder(i + 1)
                            .build();
                    int extraValueId = dao.insertOptionValue(extraValueDTO);

                    ProductOptionDTO extraSkuDTO = ProductOptionDTO.builder()
                            .productId(productId)
                            .sku("[추가상품] " + extraName)
                            .price(extraPrice)
                            .stock(extraStock)
                            .build();
                    int productOptionId = dao.insertProductOption(extraSkuDTO);

                    ProductOptionValueDTO mappingDTO = ProductOptionValueDTO.builder()
                            .productOptionId(productOptionId)
                            .optionValueId(extraValueId)
                            .build();
                    dao.insertProductOptionValue(mappingDTO);
                }
            }

            conn.commit();
            generatedProductId = productId; // 성공 시 생성된 상품 번호 저장

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
        } finally {
            if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) {} }
        }
        return generatedProductId;
    }

    // 3. 상품 수정 로직
    public boolean updateProduct(ProductFormDTO form) {  
        
        Connection conn = null;
        boolean isSuccess = false;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); 
            SellerDAO dao = new SellerDAOImpl(conn);

            int brandId = dao.getBrandId(form.getBrandName());
            if (brandId == -1) {
                throw new SQLException("등록된 브랜드 정보를 찾을 수 없습니다: " + form.getBrandName());
            }
            
            ProductDTO productDTO = ProductDTO.builder()
                    .productId(form.getProductId())
                    .categoryId(form.getCategoryId())
                    .brandId(brandId)
                    .productName(form.getProductName())
                    .description(form.getDescription())
                    .originalPrice(form.getOriginalPrice())
                    .discountRate(form.getDiscountRate())
                    .price(form.getPrice())
                    .build();
            dao.updateProduct(productDTO);

            // 새 이미지를 선택해서 업로드했을 때만 기존 이미지를 지우고 교체합니다!
            if (form.getImageUrls() != null && !form.getImageUrls().isEmpty()) {
                dao.deleteProductImages(form.getProductId());
                for (int i = 0; i < form.getImageUrls().size(); i++) {
                    ProductImageDTO imageDTO = ProductImageDTO.builder()
                            .productId(form.getProductId())
                            .imageUrl(form.getImageUrls().get(i))
                            .imageType(form.getImageTypes().get(i))
                            .sortOrder(form.getSortOrders().get(i))
                            .build();
                    dao.insertProductImage(imageDTO);
                }
            }

            // 기존 옵션 그룹 및 상품 옵션 데이터 전체 삭제 (장바구니 제약조건 고려한 DAO 사용)
            dao.deleteProductOptionsByProductId(form.getProductId());
            dao.deleteOptionGroupsByProductId(form.getProductId());

            Map<String, Integer> optionValueIdMap = new HashMap<>();
            int optionGroupCount = 0;

            // 필수 옵션 그룹 및 값 재등록
            if (form.getOptionNames() != null && form.getOptionValues() != null) {
                for (int i = 0; i < form.getOptionNames().length; i++) {
                    if (form.getOptionNames()[i].trim().equals("")) continue;

                    optionGroupCount++;

                    OptionGroupDTO groupDTO = OptionGroupDTO.builder()
                            .productId(form.getProductId())
                            .groupName(form.getOptionNames()[i])
                            .sortOrder(optionGroupCount)
                            .required(1)
                            .build();
                    int optionGroupId = dao.insertOptionGroup(groupDTO);
                    
                    String[] values = form.getOptionValues()[i].split(",");
                    for (int j = 0; j < values.length; j++) {
                        String optName = values[j].trim();
                        if (optName.equals("")) continue;
                        
                        OptionValueDTO valueDTO = OptionValueDTO.builder()
                                .optionGroupId(optionGroupId)
                                .optionName(optName)
                                .sortOrder(j + 1)
                                .build();
                    
                        int optionValueId = dao.insertOptionValue(valueDTO);
                        optionValueIdMap.put(optName, optionValueId);
                    }
                }
            }

            // 수정 시 추가 상품 그룹 및 값 재등록
            if (form.getExtraNames() != null && form.getExtraNames().length > 0) {
                OptionGroupDTO extraGroupDTO = OptionGroupDTO.builder()
                        .productId(form.getProductId())
                        .groupName("추가상품")
                        .sortOrder(optionGroupCount + 1)
                        .required(0)
                        .build();
                int extraGroupId = dao.insertOptionGroup(extraGroupDTO);

                for (int i = 0; i < form.getExtraNames().length; i++) {
                    if (form.getExtraNames()[i].trim().equals("")) continue;

                    String extraName = form.getExtraNames()[i].trim();
                    int extraPrice = Integer.parseInt(form.getExtraPrices()[i]);
                    int extraStock = Integer.parseInt(form.getExtraStocks()[i]);

                    OptionValueDTO extraValueDTO = OptionValueDTO.builder()
                            .optionGroupId(extraGroupId)
                            .optionName(extraName)
                            .sortOrder(i + 1)
                            .build();
                    int extraValueId = dao.insertOptionValue(extraValueDTO);

                    ProductOptionDTO extraSkuDTO = ProductOptionDTO.builder()
                            .productId(form.getProductId())
                            .sku("[추가상품] " + extraName)
                            .price(extraPrice)
                            .stock(extraStock)
                            .build();
                    int productOptionId = dao.insertProductOption(extraSkuDTO);

                    ProductOptionValueDTO mappingDTO = ProductOptionValueDTO.builder()
                            .productOptionId(productOptionId)
                            .optionValueId(extraValueId)
                            .build();
                    dao.insertProductOptionValue(mappingDTO);
                }
            }

            // 필수 옵션 SKU 재등록
            if (form.getSkuNames() != null) {
                for (int i = 0; i < form.getSkuNames().length; i++) {
                    String currentSku = form.getSkuNames()[i];
                    int skuPrice = Integer.parseInt(form.getSkuPrices()[i]);
                    int skuStock = Integer.parseInt(form.getSkuStocks()[i]);

                    ProductOptionDTO skuDTO = ProductOptionDTO.builder()
                            .productId(form.getProductId())
                            .sku(currentSku)
                            .price(skuPrice)
                            .stock(skuStock)
                            .build();
                
                    int productOptionId = dao.insertProductOption(skuDTO);

                    for (String optName : optionValueIdMap.keySet()) {
                        if (currentSku.contains(optName)) {
                            ProductOptionValueDTO mappingDTO = ProductOptionValueDTO.builder()
                                    .productOptionId(productOptionId) 
                                    .optionValueId(optionValueIdMap.get(optName))  
                                    .build();
                            dao.insertProductOptionValue(mappingDTO);
                        }
                    }
                }
            }

            conn.commit();
            isSuccess = true;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
        } finally {
            if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) {} }
        }
        return isSuccess;
    }
    
    // 4. 상품 정보 삭제 로직
    public boolean deleteProduct(int productId) {
        Connection conn = null;
        boolean isSuccess = false;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); 
            
            SellerDAO dao = new SellerDAOImpl(conn);
            int result = dao.deleteProduct(productId);
            
            if (result > 0) {
                conn.commit();
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
        } finally {
            if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) {} }
        }
        return isSuccess;
    }
    
    // 5. 상품 수정 폼을 위한 옵션 포맷팅
    public List<Map<String, String>> getOptionItemsForEdit(int productId) {
        List<Map<String, String>> optionItems = new ArrayList<>();
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            List<OptionGroupDTO> groups = dao.getOptionGroups(productId);
            
            for (OptionGroupDTO group : groups) {
                if ("추가상품".equals(group.getGroupName())) {
                    continue;
                }
                
                List<OptionValueDTO> values = dao.getOptionValues(group.getOptionGroupId());
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < values.size(); i++) {
                    sb.append(values.get(i).getOptionName());
                    if (i < values.size() - 1) {
                        sb.append(",");
                    }
                }
                Map<String, String> item = new HashMap<>();
                item.put("groupName", group.getGroupName());
                item.put("valuesStr", sb.toString());
                optionItems.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return optionItems;
    }
    
    // 6. 판매자 대시보드 통계 (💡 판매중지 카운트 연동 및 계산식 수정)
    public Map<String, Integer> getDashboardStats(String brandName) {
        Map<String, Integer> stats = new HashMap<>();
        Connection conn = null;
        
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            
            int brandId = dao.getBrandId(brandName);
            
            int totalCount = dao.getTotalProductCount(brandId);
            int soldOutCount = dao.getSoldOutProductCount(brandId);
            int stopCount = dao.getStopProductCount(brandId); // DB에서 판매중지 카운트 가져오기
            
            // 판매중 = 전체 - (품절 + 판매중지)
            int onSaleCount = totalCount - soldOutCount - stopCount;
            if (onSaleCount < 0) onSaleCount = 0;
            
            stats.put("totalCount", totalCount);
            stats.put("soldOutCount", soldOutCount);
            stats.put("onSaleCount", onSaleCount);
            stats.put("stopCount", stopCount); // 변수로 교체
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
        return stats;
    }

    public List<SellerDTO> getPendingSellers() {
        Connection conn = null;
        List<SellerDTO> list = null;
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            list = dao.getPendingSellers();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return list;
    }

    public boolean updateSellerStatus(int sellerId, String status) {
        Connection conn = null;
        boolean result = false;
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            int count = dao.updateSellerStatus(sellerId, status);
            if (count > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return result;
    }
    
    // 💡 관리자: 상품 상태(판매중지/판매재개) 변경 기능 추가
    public boolean updateProductStatus(int productId, String status) {
        Connection conn = null;
        boolean result = false;
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            int count = dao.updateProductStatus(productId, status);
            if (count > 0) result = true;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return result;
    }
    
    public List<ProductDTO> getProductListByBrandName(String brandName) {
        List<ProductDTO> list = new ArrayList<>();
        Connection conn = null;
        
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            
            int brandId = dao.getBrandId(brandName);
            
            int totalCount = dao.getTotalProductCount(brandId); 
            if (brandId != -1) {
                list = dao.getProductListByBrandId(brandId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
        return list;
    }
}