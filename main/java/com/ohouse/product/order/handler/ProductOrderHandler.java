package com.ohouse.product.order.handler;

import java.lang.reflect.Type;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.order.dto.OrderItemDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductOrderHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Gson gson = new Gson();
        Type listType = new TypeToken<List<OrderItemDTO>>(){}.getType();

        List<OrderItemDTO> orderItems =
                gson.fromJson(
                        request.getReader(),
                        listType
                );

        // 주문 정보 세션에 저장
        request.getSession().setAttribute("orderItems", orderItems);
        // 주문 페이지로 이동
        return null;
    }
}