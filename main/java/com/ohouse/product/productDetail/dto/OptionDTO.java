package com.ohouse.product.productDetail.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
public class OptionDTO {
    
    private long option_group_id;
    private String group_name;
    private String required;

    private long option_value_id;
    private String option_name;


}
