package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PasswordChangeFormHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        
        if (session == null || 
           (session.getAttribute("authUser") == null && session.getAttribute("sellerAuth") == null)) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        return "/WEB-INF/views/member/password_change.jsp";
    }
}