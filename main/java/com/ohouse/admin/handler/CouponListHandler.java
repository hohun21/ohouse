package com.ohouse.admin.handler;

import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.admin.service.CouponService;
import com.ohouse.admin.dto.CouponDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CouponListHandler implements CommandHandler {
    
    private CouponService couponService = new CouponService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        List<CouponDTO> couponList = couponService.getCouponList();
        request.setAttribute("couponList", couponList);
        
        return "/WEB-INF/views/admin/coupon_list.jsp";
    }
}