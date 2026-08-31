package com.ohouse.product.review.dto;

import java.util.List;

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
public class OptionFilterDTO {
    private int optionValueId;         // 1차 옵션값 ID (예: K, S/SS 등)
    private String optionValueName;     // 1차 옵션값 이름 (예: "K")
    private List<SubOptionDTO> subOptions; // 2차 세부 옵션 목록
}