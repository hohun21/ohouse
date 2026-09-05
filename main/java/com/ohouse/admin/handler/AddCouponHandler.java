package com.ohouse.admin.handler;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.CouponService;
import com.ohouse.admin.dto.CouponDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AddCouponHandler implements CommandHandler {
    
    private CouponService couponService = new CouponService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            return "redirect:" + request.getContextPath() + "/admin/couponList.htm";
        }

        String couponName = request.getParameter("couponName");
        String discountType = request.getParameter("discountType");
        int discountValue = Integer.parseInt(request.getParameter("discountValue"));
        
        int minOrderPrice = Integer.parseInt(request.getParameter("minOrderPrice"));
        
        Integer maxDiscount = null;
        String maxDiscountStr = request.getParameter("maxDiscount");
        if (maxDiscountStr != null && !maxDiscountStr.trim().isEmpty()) {
            maxDiscount = Integer.parseInt(maxDiscountStr);
        }

        String endDateStr = request.getParameter("endDate"); 

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date endDate = sdf.parse(endDateStr);

        CouponDTO coupon = CouponDTO.builder()
                .couponName(couponName)
                .discountType(discountType)
                .discountValue(discountValue)
                .minOrderPrice(minOrderPrice)
                .maxDiscount(maxDiscount)
                .endDate(endDate)
                .build();

        couponService.addCoupon(coupon);

        return "redirect:" + request.getContextPath() + "/admin/couponList.htm";
    }
}