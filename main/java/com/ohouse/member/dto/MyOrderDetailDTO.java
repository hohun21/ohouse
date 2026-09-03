package com.ohouse.member.dto;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MyOrderDetailDTO {
    private int orders_detail_id;
    private int order_id;
    private int product_option_id;
    private String product_name;
    private String option_name;
    private int price;
    private int quantity;
    private int brand_id;
    private String brand_name;
    private String image_url;
    private int delivery_status;
    private Date delivered_date;
    private Date purchase_confirmed_date;
}
