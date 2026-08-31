package com.ohouse.product.cart.handler;

import com.google.gson.Gson;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.cart.dto.CartOptionEditRequestDTO;
import com.ohouse.product.cart.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CartOptionEditHandler implements CommandHandler {
    private final Gson gson = new Gson();
    private final CartService cartService = new CartService();

    @Override
    public String process(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        AuthUserDTO mdto =
                (AuthUserDTO) session.getAttribute("authUser");

        if (mdto == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return null;
        }

        int member_id = mdto.getMemberId();

        CartOptionEditRequestDTO dto =
                gson.fromJson(
                        request.getReader(),
                        CartOptionEditRequestDTO.class
                );

        cartService.updateCartOption(
                dto,
                member_id
        );

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.getWriter().write("""
                {"success":true}
                """);

        return null;
    }
}