package com.ohouse.product.order.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderOptionDTO {

    private long option_group_id;
    private String option_group_name;
    private long option_value_id;
    private String option_value_name;
}
