package com.ohouse.admin.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminDashboardHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        return "/WEB-INF/views/admin/admin_dashboard.jsp";
    }
}