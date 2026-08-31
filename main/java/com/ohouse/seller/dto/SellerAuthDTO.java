package com.ohouse.seller.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SellerAuthDTO {
    private long sellerId;
    private String email;
    private String businessNumber;
    private String brandName;
    private String status;
}