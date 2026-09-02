package com.ohouse.product.productDetail.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ProductOptionDTO {
    private long brand_id;
    private String brand_name;
    private long product_option_id;
    private long product_id;
    private String sku;
    private long price;
    private long stock;
    private String status;
}
