package com.ohouse.seller.service;

public class SellerNotFoundException extends RuntimeException {
	private static final long serialVersionUID = 1L;

    public SellerNotFoundException() {
        super("판매자 정보를 찾을 수 없습니다.");
    }
}
