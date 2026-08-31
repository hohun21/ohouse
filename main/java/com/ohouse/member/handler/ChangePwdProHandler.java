package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.service.ChangePasswordService;
import com.ohouse.seller.dto.SellerAuthDTO;
import com.ohouse.seller.service.SellerChangePasswordService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ChangePwdProHandler implements CommandHandler {

    private ChangePasswordService memberPwdService = new ChangePasswordService();
    private SellerChangePasswordService sellerPwdService = new SellerChangePasswordService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("authUser") == null && session.getAttribute("sellerAuth") == null)) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }
        
        String currentPwd = request.getParameter("currentPwd");
        String newPwd = request.getParameter("newPwd");
        
        Object sellerAuthObj = session.getAttribute("sellerAuth");
        String redirectUrl = (sellerAuthObj != null) 
                ? request.getContextPath() + "/seller/login.htm"
                : request.getContextPath() + "/login.htm";
        
        try {
            if (sellerAuthObj != null) {
                SellerAuthDTO sellerAuth = (SellerAuthDTO) sellerAuthObj;
                sellerPwdService.changePassword(sellerAuth.getSellerId(), sellerAuth.getEmail(), currentPwd, newPwd);
            }
            
            Object authUserObj = session.getAttribute("authUser");
            if (authUserObj != null) {
                AuthUserDTO authUser = (AuthUserDTO) authUserObj;
                memberPwdService.changePassword(authUser.getId(), currentPwd, newPwd);
            }
            
            session.invalidate();
            
            request.setAttribute("showAlert", true);
            request.setAttribute("redirectUrl", redirectUrl);
            return "/WEB-INF/views/member/password_change.jsp";
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errors", java.util.Map.of("invalidCurrentPwd", true));
            return "/WEB-INF/views/member/password_change.jsp";
        }
    }
}