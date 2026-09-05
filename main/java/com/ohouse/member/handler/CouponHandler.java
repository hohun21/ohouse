package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.productDetail.service.ProductService;
import com.ohouse.member.dto.CouponDTO;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

public class CouponHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        
        AuthUserDTO adto = (AuthUserDTO) session.getAttribute("authUser");
        
        int member_id = adto.getMemberId();
        System.out.println("member_id: " + member_id);
        ProductService ps = new ProductService();

        List<CouponDTO> clist = ps.getCouponList(member_id);
        System.out.println("clist size: " + clist.size());

        request.setAttribute("clist", clist);
        String location = "/WEB-INF/views/member/couponlist.jsp";
        RequestDispatcher rd = request.getRequestDispatcher(location);
        rd.forward(request, response);

        return null;
    }
}