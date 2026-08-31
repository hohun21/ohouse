package com.ohouse.seller.service;

public class SellerInvalidPasswordException extends RuntimeException {
	private static final long serialVersionUID = 1L;

    public SellerInvalidPasswordException() {
    	super("현재 비밀번호가 일치하지 않습니다.");
    }
}
