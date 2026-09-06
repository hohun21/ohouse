package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.dto.CouponDTO;
import com.ohouse.product.productDetail.service.ProductService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

public class CouponCountHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        ProductService productService = new ProductService();

        AuthUserDTO adto = (AuthUserDTO) session.getAttribute("authUser");

        int member_id = adto.getMemberId();
        int count = productService.getmyCouponCount(member_id);

        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write(String.valueOf(count));

        return null;
    }
}
