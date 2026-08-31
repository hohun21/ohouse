package com.ohouse.product.cart.handler;

import com.google.gson.Gson;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.cart.dto.CartItemDTO;
import com.ohouse.product.cart.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartQuantityEditHandler implements CommandHandler {
     private final Gson gson = new Gson();
    private final CartService cartService = new CartService();
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        
        AuthUserDTO member =
                (AuthUserDTO) session.getAttribute("authUser");

        int member_id = member.getMemberId();
        
        CartItemDTO dto = gson.fromJson(request.getReader(), CartItemDTO.class);

        cartService.updateQuantity(dto,member_id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("""
                {"success":true}
                """);

        return null;

    }
}