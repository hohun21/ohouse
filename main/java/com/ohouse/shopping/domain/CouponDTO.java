package com.ohouse.shopping.domain;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CouponDTO {

    private String coupon_name;
    private String discount_type;
    private double discount_value;
    private long min_order_price;
    private long max_discount;
    private Date start_date;
    private Date end_date;
    private Date issued_date;
    private Date used_date;
    private String status;

}
