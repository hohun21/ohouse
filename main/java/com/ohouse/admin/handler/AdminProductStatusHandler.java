package com.ohouse.admin.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminProductStatusHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        String status = request.getParameter("status");
        
        SellerService service = new SellerService();
        boolean isSuccess = service.updateProductStatus(productId, status);
        
        if (isSuccess) {
            return "redirect:" + request.getContextPath() + "/admin/productList.htm";
        } else {
            return "redirect:" + request.getContextPath() + "/admin/productList.htm?error=statusUpdateFailed";
        }
    }
}