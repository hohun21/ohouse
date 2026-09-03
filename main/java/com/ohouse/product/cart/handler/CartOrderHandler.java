package com.ohouse.product.cart.handler;

import com.google.gson.Gson;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.cart.dto.CartItemDTO;
import com.ohouse.product.cart.dto.CartOptionDTO;
import com.ohouse.product.order.dto.OrderItemDTO;
import com.ohouse.product.order.dto.OrderOptionDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.List;

public class CartOrderHandler implements CommandHandler {

    @Override
    public String process(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        Gson gson = new Gson();

        CartItemDTO[] cartItems =
                gson.fromJson(
                        request.getReader(),
                        CartItemDTO[].class
                );

        List<OrderItemDTO> orderItems =
                new ArrayList<>();
        List<Integer> cartItemsIds = new ArrayList<>();
        for (CartItemDTO cartItem : cartItems) {
            cartItemsIds.add(cartItem.getCart_items_id());
            OrderItemDTO orderItem =
                    new OrderItemDTO();
            orderItem.setCart_items_id(cartItem.getCart_items_id());

            orderItem.setBrand_id(
                    cartItem.getBrand_id()
            );

            orderItem.setProduct_name(
                    cartItem.getProduct_name()
            );

            orderItem.setImage_url(
                    cartItem.getImage_url()
            );

            orderItem.setProduct_option_id(
                    cartItem.getProduct_option_id()
            );

            orderItem.setProduct_id(
                    cartItem.getProduct_id()
            );

            orderItem.setSku(
                    cartItem.getSku()
            );

            orderItem.setPrice(
                    cartItem.getPrice()
            );

            orderItem.setQuantity(
                    cartItem.getQuantity()
            );

            List<OrderOptionDTO> options =
                    new ArrayList<>();

            if (cartItem.getOptions() != null) {

                for (CartOptionDTO option :
                        cartItem.getOptions()) {

                    options.add(
                            new OrderOptionDTO(
                                    option.getOption_group_id(),
                                    option.getOption_group_name(),
                                    option.getOption_value_id(),
                                    option.getOption_value_name()
                            )
                    );
                }
            }

            orderItem.setOptions(options);

            orderItems.add(orderItem);
        }  // for

        HttpSession session =
                request.getSession();

        session.setAttribute(
                "orderItems",
                orderItems
        );
        session.setAttribute("selectedCartItemsIds",cartItemsIds);

        response.setContentType(
                "application/json;charset=UTF-8"
        );

        response.getWriter().write(
                "{\"success\":true}"
        );

        return null;
    }
}
