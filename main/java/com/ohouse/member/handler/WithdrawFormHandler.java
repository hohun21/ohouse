package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class WithdrawFormHandler implements CommandHandler {

    private static final String FORM_VIEW =
            "/WEB-INF/views/member/withdraw.jsp";

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession(false);

        // 로그인하지 않은 경우
        if (session == null || session.getAttribute("authUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.htm");
            return null;
        }

        AuthUserDTO authUser =
                (AuthUserDTO) session.getAttribute("authUser");

        req.setAttribute("authUser", authUser);

        return FORM_VIEW;
    }
}