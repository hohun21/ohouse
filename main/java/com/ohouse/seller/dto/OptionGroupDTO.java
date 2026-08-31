package com.ohouse.seller.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class OptionGroupDTO {
    private Integer optionGroupId;
    private Integer productId;
    private String groupName;
    private Integer sortOrder;
    private Integer required;
}