package com.ohouse.shopping.only.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@Builder
public class OnlyDTO {
	
	private String brandName;
	private int productId;
	private String productName;
	private double discountRate;
	private long price;
	private double reviewScore;
	private int reviewCount;
	private String imageUrl;
	private Date created;
	
}
