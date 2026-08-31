package com.ohouse.seller.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SellerDTO {
    
    private int sellerId;
    private String email;
    private String password;
    private String businessNumber;
    private String representativeName;
    private String mailOrderNumber;
    private String businessAddress;
    private String representativeContact;
    private String customerServicePhone;    
    private String status;
    private Date regDate;
}