package com.ohouse.seller.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ProductOptionDTO {
    private Integer productOptionId;
    private Integer productId;
    private String sku;
    private Integer price;
    private Integer stock;
    private String status;
}
