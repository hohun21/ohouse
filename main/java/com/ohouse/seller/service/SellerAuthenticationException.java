package com.ohouse.seller.service;

public class SellerAuthenticationException extends RuntimeException {
	private static final long serialVersionUID = 1L;

	public SellerAuthenticationException() {
		super("입력한 판매자 정보가 일치하지 않습니다.");
	}
}
