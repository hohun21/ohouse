package com.ohouse.product.cart.dto;



import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItemDTO {
    private int cart_group_id;
    private int cart_id;
    private int cart_items_id;
    private String brand_name;
    private String product_name;
    private String image_url;
    private long product_option_id;
    private long product_id;
    private String sku;
    private int price;
    private int quantity;

    private List<CartOptionDTO> options;

}
