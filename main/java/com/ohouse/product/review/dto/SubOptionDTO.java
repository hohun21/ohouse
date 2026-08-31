package com.ohouse.product.review.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SubOptionDTO {
    private int productOptionId; // 최종 선택될 product_option_id (체크박스 value)
    private String subOptionName; // 세부 옵션명 (예: "파운드만")
}