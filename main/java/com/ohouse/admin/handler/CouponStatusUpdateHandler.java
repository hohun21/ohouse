package com.ohouse.admin.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.CouponService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CouponStatusUpdateHandler implements CommandHandler {
    
    private CouponService couponService = new CouponService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int couponId = Integer.parseInt(request.getParameter("couponId"));
        int status = Integer.parseInt(request.getParameter("status"));

        couponService.updateCouponStatus(couponId, status);

        return "redirect:" + request.getContextPath() + "/admin/couponList.htm";
    }
}