package com.ohouse.seller.handler;

import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.dto.SellerAuthDTO;
import com.ohouse.seller.dto.SellerOrderDTO;
import com.ohouse.seller.service.SellerOrderService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SellerOrderListHandler implements CommandHandler {

    private SellerOrderService orderService = new SellerOrderService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sellerAuth") == null) {
           
            return "redirect:" + request.getContextPath() + "/seller/login.htm";
        }
        
        SellerAuthDTO auth = (SellerAuthDTO) session.getAttribute("sellerAuth");
        String brandName = auth.getBrandName();

        List<SellerOrderDTO> orderList = orderService.getOrderList(brandName);

        request.setAttribute("orderList", orderList);
        
        return "/WEB-INF/views/seller/order_list.jsp"; 
    }
}