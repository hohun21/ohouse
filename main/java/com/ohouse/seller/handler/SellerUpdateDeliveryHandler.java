package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerOrderService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SellerUpdateDeliveryHandler implements CommandHandler {

    private SellerOrderService orderService = new SellerOrderService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sellerAuth") == null) {
            return "redirect:" + request.getContextPath() + "/seller/login.htm";
        }
        
        int orderDetailId = Integer.parseInt(request.getParameter("orderDetailId"));
        int status = Integer.parseInt(request.getParameter("status")); 
        
        String from = request.getParameter("from");

        boolean success = orderService.changeDeliveryStatus(orderDetailId, status);

        if (success) {
            String redirectUrl = request.getContextPath() + "/seller/orderList.htm";
            
            if ("claim".equals(from)) {
                redirectUrl = request.getContextPath() + "/seller/claimList.htm";
            }
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('처리가 완료되었습니다.'); location.href='" + redirectUrl + "';</script>");
            return null;
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('처리에 실패했습니다.'); history.back();</script>");
            return null;
        }
    }
}