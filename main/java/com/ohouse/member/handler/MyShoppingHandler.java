package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.dto.MyOrderDTO;
import com.ohouse.member.service.MyShoppingService;
import com.ohouse.product.payment.dto.OrderStatusCountDTO;
import com.ohouse.product.payment.service.OrderService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

public class MyShoppingHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();

        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        int member_id = authUser.getMemberId();
        MyShoppingService shoppingService = new MyShoppingService();
        List<MyOrderDTO> orderdto = shoppingService.selectorder(member_id);
        OrderService orderService = new OrderService();

        OrderStatusCountDTO statusCount = orderService.getOrderStatusCount(member_id);

        request.setAttribute("statusCount", statusCount);
        request.setAttribute("orderdto", orderdto);

        return "/WEB-INF/views/member/myShopping.jsp";
    }
}
