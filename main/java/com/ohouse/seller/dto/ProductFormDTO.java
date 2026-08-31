package com.ohouse.seller.dto;

import java.util.List;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ProductFormDTO {
 
    private int productId;
    private int categoryId;
    private String brandName;
    private String productName;
    private String description;
    
    private int originalPrice;
    private int discountRate;
    private int price; 

    private String[] optionNames;
    private String[] optionValues;

    private String[] skuNames;
    private String[] skuPrices;
    private String[] skuStocks;

    private String[] extraNames;
    private String[] extraPrices;
    private String[] extraStocks;

    private List<String> imageUrls;
    private List<String> imageTypes;
    private List<Integer> sortOrders;
}