package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerService;
import com.ohouse.seller.service.SellerOrderService; // 💡 1. 주문/정산 서비스 임포트
import com.ohouse.seller.dto.SellerAuthDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;
import java.util.HashMap;

public class SellerDashboardHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        SellerAuthDTO sellerAuth = (SellerAuthDTO) session.getAttribute("sellerAuth");
        
        if (sellerAuth == null) {
            return "redirect:" + request.getContextPath() + "/seller/login.htm";
        }
        
        String myBrandName = sellerAuth.getBrandName(); 
        
        SellerService sellerService = new SellerService();
        SellerOrderService orderService = new SellerOrderService();

        Map<String, Object> stats = new HashMap<>();
        Map<String, Integer> productStats = sellerService.getDashboardStats(myBrandName);
        if (productStats != null) {
            stats.putAll(productStats);
        }
        

        Map<String, Object> orderStats = orderService.getDashboardOrderStats(myBrandName);
        if (orderStats != null) {
            stats.putAll(orderStats);
        }
       
        request.setAttribute("stats", stats);
        
        return "/WEB-INF/views/seller/dashboard.jsp";
    }
}