package com.ohouse.seller.service;

public class SellerLoginFailException
        extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public SellerLoginFailException() {
        super("이메일 또는 비밀번호가 일치하지 않습니다.");
    }
}