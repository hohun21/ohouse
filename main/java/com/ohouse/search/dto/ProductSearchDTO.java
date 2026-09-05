package com.ohouse.search.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ProductSearchDTO {
    private Integer productId;
    private String brandName;
    private String productName;
    private Integer price;
    private Integer discountRate;
    private String imageUrl;
    private String status;
    private Double avgRating;
    private Integer reviewCount;
}