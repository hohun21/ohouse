package com.ohouse.shopping.best.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@Builder
public class BestDTO {
	
	private int rank;
	private String brandName;
	private int productId;
	private String productName;
	private double discountRate;
	private long price;
	private double reviewScore;
	private int reviewCount;
	private String imageUrl;
	private int salesQty;
}
