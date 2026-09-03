package com.ohouse.member.dto;

import lombok.*;

import java.util.Date;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class MyOrderDTO {
    private int orders_id;
    private int member_id;
    private String order_name;
    private int total_price;
    private int coupon_discount;
    private int delivery_fee;
    private int payment_price;
    private int member_coupon_id;
    private int order_status;
    private Date order_date;
    private String request_msg;
    private int address_id;
    private String toss_order_id;

    private List<MyOrderDetailDTO> orderDetails;

}
