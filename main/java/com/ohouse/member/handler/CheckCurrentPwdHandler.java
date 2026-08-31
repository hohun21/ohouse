package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.service.ChangePasswordService;
import com.ohouse.seller.dto.SellerAuthDTO;
import com.ohouse.seller.service.SellerChangePasswordService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CheckCurrentPwdHandler implements CommandHandler {

    private ChangePasswordService memberPwdService = new ChangePasswordService();
    private SellerChangePasswordService sellerPwdService = new SellerChangePasswordService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("authUser") == null && session.getAttribute("sellerAuth") == null)) {
            response.getWriter().write("{\"isMatch\": false}");
            return null;
        }
        
        String currentPwd = request.getParameter("currentPwd");
        boolean isMatch = false;
        
        Object sellerAuthObj = session.getAttribute("sellerAuth");
        if (sellerAuthObj != null) {
            SellerAuthDTO sellerAuth = (SellerAuthDTO) sellerAuthObj;
            isMatch = sellerPwdService.checkCurrentPassword(sellerAuth.getEmail(), currentPwd);
        }
        
        Object authUserObj = session.getAttribute("authUser");
        if (authUserObj != null) {
            AuthUserDTO authUser = (AuthUserDTO) authUserObj;
            isMatch = memberPwdService.checkCurrentPassword(authUser.getId(), currentPwd);
        }
        
        response.getWriter().write("{\"isMatch\": " + isMatch + "}");
        return null;
    }
}