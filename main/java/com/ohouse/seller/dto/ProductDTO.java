package com.ohouse.seller.dto;

import lombok.Builder;
import lombok.Data;
import java.util.Date;

@Data
@Builder
public class ProductDTO {
    private Integer productId;
    private Integer categoryId;
    private Integer brandId;
    private String brandName;
    private String productName;
    private Integer price;
    private String description;
    private Integer originalPrice;
    private Integer discountRate;
    private Date created;
    private Date updated;
    private String status;
}
