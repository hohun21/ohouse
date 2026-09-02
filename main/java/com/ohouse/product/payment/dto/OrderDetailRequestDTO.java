package com.ohouse.product.payment.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderDetailRequestDTO {
    private Long brandId;
    private Long productOptionId;
    private String productName;
    private String optionName;
    private int price;
    private int quantity;
}
