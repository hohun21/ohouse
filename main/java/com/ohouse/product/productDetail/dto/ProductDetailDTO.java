package com.ohouse.product.productDetail.dto;


import java.util.List;

import com.ohouse.shopping.category.dto.CategoryDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductDetailDTO {

    private ProductDTO productDTO;
    private List<ProductImageDTO> imageDTOList;
    private List<OptionDTO> optionDTOList;
    private List<CategoryDTO> categoryDTOList;
}
