package com.ohouse.admin.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.AdminService;
import com.ohouse.member.dto.AuthUserDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminProductDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        AdminService service = new AdminService();
        service.deleteProductByAdmin(productId);
        
        return "redirect:" + request.getContextPath() + "/admin/productList.htm";
    }
}