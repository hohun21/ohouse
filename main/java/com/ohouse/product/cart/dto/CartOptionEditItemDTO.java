package com.ohouse.product.cart.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartOptionEditItemDTO {
    private Integer cart_items_id;
    private long product_option_id;
    private int quantity;

    private boolean is_new;
}