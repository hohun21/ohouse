package com.ohouse.admin.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.CouponService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CouponIssueHandler implements CommandHandler {
    
    private CouponService couponService = new CouponService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int couponId = Integer.parseInt(request.getParameter("couponId"));

        couponService.issueCouponToAll(couponId);

        return "redirect:" + request.getContextPath() + "/admin/couponList.htm";
    }
}