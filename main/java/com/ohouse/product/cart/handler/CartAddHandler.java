package com.ohouse.product.cart.handler;

import java.lang.reflect.Type;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.cart.dto.CartItemDTO;
import com.ohouse.product.cart.service.CartService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CartAddHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        Gson gson = new Gson();
        Type listType = new TypeToken<List<CartItemDTO>>(){}.getType();

        // JSON -> List
        List<CartItemDTO> cartItems = gson.fromJson(request.getReader(), listType);
        
        //
        AuthUserDTO member = (AuthUserDTO) request.getSession().getAttribute("authUser");
        int member_id = member.getMemberId();
        
        CartService cartsvc = new CartService();
        cartsvc.insert(cartItems, member_id);
        
        response.getWriter().write("{\"success\":true}");
        return null;
    }
}