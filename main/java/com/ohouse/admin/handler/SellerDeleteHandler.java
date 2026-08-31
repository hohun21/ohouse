package com.ohouse.admin.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.AdminService;

public class SellerDeleteHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String sellerIdStr = request.getParameter("sellerId");
        
        if (sellerIdStr != null && !sellerIdStr.isEmpty()) {
            int sellerId = Integer.parseInt(sellerIdStr);
            AdminService service = new AdminService();
            service.deleteSeller(sellerId);
        }
        return "redirect:/admin/sellerList.htm";
    }
}