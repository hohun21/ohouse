package com.ohouse.shopping.handler;


import com.ohouse.common.handler.CommandHandler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class HousetourHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "/WEB-INF/views/housetour/housetour.jsp";
    }
}
