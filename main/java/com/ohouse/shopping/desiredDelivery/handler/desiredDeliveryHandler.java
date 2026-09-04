package com.ohouse.shopping.desiredDelivery.handler;

import com.ohouse.common.handler.CommandHandler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class desiredDeliveryHandler implements CommandHandler {
    @Override
    public String process(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {
    	request.setAttribute("activeMenu", "desiredDelivery");
        return "/WEB-INF/views/shopping/desiredDelivery/desired_delivery.jsp";
    }
}
