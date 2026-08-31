package com.ohouse.seller.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class OptionValueDTO {
    private Integer optionValueId;
    private Integer optionGroupId;
    private String optionName;
    private Integer sortOrder;
}
