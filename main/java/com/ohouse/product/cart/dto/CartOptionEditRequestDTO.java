package com.ohouse.product.cart.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartOptionEditRequestDTO {
    private long product_id;
    
    private List<CartOptionEditItemDTO> items;
    private List<Integer> deleted_cart_items_ids;
}