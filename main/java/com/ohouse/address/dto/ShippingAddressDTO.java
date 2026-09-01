package com.ohouse.address.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ShippingAddressDTO {
    private Integer address_id;
    private Integer member_id;
    private String address_name;
    private String recipient_name;
    private String phone;
    private String zip_code;
    private String base_address;
    private String detail_address;
    private String is_default;
    private String request_msg;
}