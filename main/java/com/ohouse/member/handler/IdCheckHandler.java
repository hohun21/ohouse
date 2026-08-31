package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.service.SignupService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class IdCheckHandler implements CommandHandler{

    private SignupService signupService = new SignupService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String id = trim(req.getParameter("id"));   

        System.out.println("> IdCheckHandler .... ");

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        if (id == null || id.isBlank()) {
            res.setStatus( HttpServletResponse.SC_BAD_REQUEST );
            res.getWriter().write(
                    "{\"count\":0,\"code\":\"ID_REQUIRED\"}"
            );
            return null;
        }
        
        try {
            String jsonResult = signupService.idCheck(id);
            System.out.println( "idCheck JSON: " + jsonResult );

            res.setContentType("application/json");
            res.setCharacterEncoding("UTF-8");
            
            res.getWriter().write(jsonResult);

            return null;

        } catch (Exception e) {
            e.printStackTrace();

            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            res.getWriter().write(
                    "{\"count\":0,\"code\":\"SERVER_ERROR\"}"
            );
            return null;
        }
    }

    private String trim(String str) {
        return str == null ? null : str.trim();
    }
}