package com.ohouse.admin.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.AdminService;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.seller.dto.ProductDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

public class AdminProductListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        AdminService service = new AdminService();
        List<ProductDTO> adminProductList = service.getAllProductsForAdmin();
        
        request.setAttribute("adminProductList", adminProductList);
        
        return "/WEB-INF/views/admin/admin_product_list.jsp";
    }
}