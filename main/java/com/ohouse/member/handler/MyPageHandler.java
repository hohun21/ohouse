package com.ohouse.member.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.common.handler.CommandHandler;

public class MyPageHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        Object sellerAuth = session.getAttribute("sellerAuth");
       
        if (authUser == null && sellerAuth == null) {
            System.out.println("접근 거부: 로그인이 필요합니다.");
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        return "/WEB-INF/views/member/mypage.jsp";
    }
}