package com.ohouse.product.cart.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.cart.dto.CartItemDTO;
import com.ohouse.product.cart.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

public class CartListHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        
        // 💡 세션 이름("authUser") 및 DTO(AuthUserDTO)로 변경
        AuthUserDTO mdto = (AuthUserDTO) session.getAttribute("authUser");
        int member_id = mdto.getMemberId();
        
        CartService csvc = new CartService();
        List<CartItemDTO> cdto = csvc.selectCartList(member_id);

        request.setAttribute("cdto", cdto);
        return "/WEB-INF/views/shopping/cart.jsp";
    }
}