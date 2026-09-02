package com.ohouse.seller.dto;

import java.util.Date;

import lombok.Data;

@Data
public class SellerOrderDTO {
    private Integer orderDetailId;
    private Date orderDate;
    private String productName;
    private String optionName;
    private Integer quantity;
    private Integer price;
    private Integer deliveryStatus;
    private String brandName;
}