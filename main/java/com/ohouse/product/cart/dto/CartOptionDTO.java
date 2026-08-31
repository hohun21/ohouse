package com.ohouse.product.cart.dto;


import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartOptionDTO {
    private long product_id;
    private long option_group_id;
    private String option_group_name;
    private long option_value_id;
    private String option_value_name;
}
