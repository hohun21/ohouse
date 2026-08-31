package com.ohouse.product.productDetail.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@Builder
public class ProductDTO {

        private long brand_id;
        private String brand_name;
        private String product_name;
        private long product_id;
        private long original_price;
        private String image_url;
        private long price;
        private long category_id;
        private double discount_rate;

        // 기존 DAO에서 사용하던 6개짜리 생성자 유지
        public ProductDTO(
        long brand_id,
        String product_name,
        long original_price,
        long price,
        long category_id,
        double discount_rate
        ) {
        	this.brand_id = brand_id;
        	this.product_name = product_name;
        	this.original_price = original_price;
        	this.price = price;
        	this.category_id = category_id; 
        	this.discount_rate = discount_rate;
        }
        
}
