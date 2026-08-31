package com.ohouse.seller.service;

public class SellerNotActiveException
        extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String status;


    public SellerNotActiveException(String status) {

        super("아직 입점 승인이 완료되지 않았습니다.");

        this.status = status;
    }


    public String getStatus() {

        return status;
    }
}