package com.ohouse.admin.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.AdminService;

public class SellerApprovalHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        int sellerId = Integer.parseInt(request.getParameter("sellerId"));
        String action = request.getParameter("action"); 
        
        String status = "PENDING";
        if ("approve".equals(action)) {
            status = "ACTIVE";
        } else if ("reject".equals(action)) {
            status = "REJECTED";
        }
        
        AdminService adminService = new AdminService();
        
        boolean isSuccess = adminService.updateSellerStatus(sellerId, status); 
        
        return "redirect:/admin/pendingSellers.htm"; 
    }
}