package com.ohouse.product.payment.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderRequsetDTO {
    private long addressId;
    private String requestMsg;
    private String orderName;
    private int totalPrice;
    private int couponDiscount;
    private int deliveryFee;
    private int paymentPrice;
    private Long memberCouponId;
    private String tossOrderId;
    private List<OrderDetailRequestDTO> orderDetails;

}
