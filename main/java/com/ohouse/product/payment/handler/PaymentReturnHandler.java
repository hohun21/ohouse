package com.ohouse.product.payment.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.payment.service.OrderService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class PaymentReturnHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int orders_detail_id = Integer.parseInt(request.getParameter("orders_detail_id"));
        OrderService orderService = new OrderService();
        orderService.payreturn(orders_detail_id);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":true}");
        return null;
    }
}
