package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerService;
import com.ohouse.seller.dto.SellerAuthDTO; // 💡 DTO 임포트

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

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
        
        Map<String, Integer> stats = sellerService.getDashboardStats(myBrandName);
       
        request.setAttribute("stats", stats);
        
        return "/WEB-INF/views/seller/dashboard.jsp";
    }
}