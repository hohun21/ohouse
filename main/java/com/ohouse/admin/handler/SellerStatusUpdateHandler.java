package com.ohouse.admin.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerService;

public class SellerStatusUpdateHandler implements CommandHandler {
    
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String sellerIdStr = request.getParameter("seller_id");
        String status = request.getParameter("status");
        
        if (sellerIdStr != null && !sellerIdStr.isEmpty() && status != null && !status.isEmpty()) {
            int sellerId = Integer.parseInt(sellerIdStr);
            
            SellerService service = new SellerService();
            service.updateSellerStatus(sellerId, status);
        }
        
        return "redirect:" + request.getContextPath() + "/admin/sellerList.htm";
    }
}