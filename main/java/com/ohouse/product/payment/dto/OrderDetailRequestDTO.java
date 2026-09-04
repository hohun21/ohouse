package com.ohouse.product.payment.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderDetailRequestDTO {
    private int cartItemsId;
    private Long brandId;
    private Long productOptionId;
    private String imgUrl;
    private String productName;
    private String optionName;
    private int price;
    private int quantity;
}
