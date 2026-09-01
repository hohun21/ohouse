package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.service.WithdrawService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class WithdrawProHandler implements CommandHandler {

    private WithdrawService withdrawService = new WithdrawService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res)
            throws Exception {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("authUser") == null) {
            res.sendRedirect(req.getContextPath() + "/login.htm");
            return null;
        }

        AuthUserDTO authUser =
                (AuthUserDTO) session.getAttribute("authUser");

        int memberId = authUser.getMemberId();

        withdrawService.withdraw(memberId);

        session.invalidate();

        res.sendRedirect(req.getContextPath() + "/main.htm");
        return null;
    }
}