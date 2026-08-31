package com.ohouse.product.productDetail.dto;

public class CategoryDTO {

    private long category_id; 
    private String category_name;

    public CategoryDTO(long category_id, String category_name) {
        this.category_id = category_id;
        this.category_name = category_name;
    }

    public long getcategory_id() {
        return category_id;
    }

    public void setcategory_id(long category_id) {
        this.category_id = category_id;
    }

    public String getcategory_name() {
        return category_name;
    }

    public void setcategory_name(String category_name) {
        this.category_name = category_name;
    }
}