package com.ohouse.seller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductImageDTO {
	private Integer imageId;
	private Integer productId;
	private Integer sortOrder;
	private String imageUrl;
	private String imageType;
}
