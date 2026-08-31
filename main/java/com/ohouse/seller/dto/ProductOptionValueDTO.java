package com.ohouse.seller.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ProductOptionValueDTO {
    private int productOptionValueId;
    private int productOptionId;
    private int optionValueId;
}
