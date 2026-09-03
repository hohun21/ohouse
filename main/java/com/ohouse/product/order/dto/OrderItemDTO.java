package com.ohouse.product.order.dto;


import com.ohouse.product.order.dto.OrderOptionDTO;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class OrderItemDTO {
    private long brand_id;
    private String brand_name;
    private String product_name;
    private String image_url;
    private long product_option_id;
    private long product_id;
    private String sku;
    private int price;
    private int quantity;

    private List<OrderOptionDTO> options;

}
