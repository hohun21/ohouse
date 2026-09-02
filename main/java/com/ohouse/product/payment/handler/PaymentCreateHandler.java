package com.ohouse.product.payment.handler;

import com.google.gson.Gson;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.payment.dto.OrderRequsetDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class PaymentCreateHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        System.out.println("==== paymentCreateHandler 진입====");

        Gson gson = new Gson();

        OrderRequsetDTO dto = gson.fromJson(
                request.getReader(),
                OrderRequsetDTO.class

        );


        System.out.println("addressId = " + dto.getAddressId());
        System.out.println("requestMsg = " + dto.getRequestMsg());
        System.out.println("paymentPrice = " + dto.getPaymentPrice());

        request.getSession().setAttribute("orderdata",dto);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().write(
                "{\"success\":true}"
        );
        return null;


    }
}

