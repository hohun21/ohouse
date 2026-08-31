package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerSignupService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class EmailCheckHandler implements CommandHandler {

    private final SellerSignupService sellerSignupService = new SellerSignupService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
        String email = trim(req.getParameter("email"));

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        if (email == null || email.isBlank()) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            res.getWriter().write("{\"count\":0,\"code\":\"EMAIL_REQUIRED\"}");
            return null;
        }

        try {
            res.getWriter().write(sellerSignupService.emailCheck(email));
        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write("{\"count\":0,\"code\":\"SERVER_ERROR\"}");
        }
        return null;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}