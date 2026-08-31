package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.service.SignupService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class NameCheckHandler implements CommandHandler{

    private SignupService signupService = new SignupService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
        res.setCharacterEncoding("UTF-8");
        res.setContentType("application/json");

        String name = trim(req.getParameter("name"));   

        System.out.println("> NameCheckHandler .... ");
        
        if (name == null || name.length() < 2 || name.length() > 20) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            res.getWriter().write(
                    "{\"available\":false,\"code\":\"INVALID_NAME\"}"
            );
            return null;
        }
        
        try {
            String nameCheckJson = signupService.nameCheck(name); 
            res.getWriter().write(nameCheckJson);
            return null;
        } catch ( Exception e) {
            e.printStackTrace();
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write(
                    "{\"available\":false,\"code\":\"SERVER_ERROR\"}"
            );
            return null;
        } 
    }

    private String trim(String str) {
        return str == null ? null : str.trim();
    }
}