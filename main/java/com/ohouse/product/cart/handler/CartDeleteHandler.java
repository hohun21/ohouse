package com.ohouse.product.cart.handler;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.cart.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.List;

public class CartDeleteHandler implements CommandHandler {

    private final CartService cartService = new CartService();

    @Override
    public String process(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        HttpSession session = request.getSession();

        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        int member_id = authUser.getMemberId();

        JsonElement jsonElement =
                JsonParser.parseReader(request.getReader());

        List<Integer> cartItemsIds =
                new ArrayList<>();

        /*
         * 개별 삭제
         * {
         *     "cart_items_id": 10
         * }
         */
        if (jsonElement.isJsonObject()) {

            int cartItemsId =
                    jsonElement.getAsJsonObject()
                            .get("cart_items_id")
                            .getAsInt();

            cartItemsIds.add(cartItemsId);

            /*
             * 선택 삭제
             * [10, 11, 12]
             */
        } else if (jsonElement.isJsonArray()) {

            for (JsonElement element : jsonElement.getAsJsonArray()) {
                cartItemsIds.add(
                        element.getAsInt()
                );
            }
        }

        if (cartItemsIds.isEmpty()) {

            response.setStatus(
                    HttpServletResponse.SC_BAD_REQUEST
            );

            response.setContentType(
                    "application/json;charset=UTF-8"
            );

            response.getWriter().write(
                    """
                            {"success":false,"message":"삭제할 상품이 없습니다."}
                            """
            );

            return null;
        }

        int result =
                cartService.deleteCartItems(
                        cartItemsIds,
                        member_id
                );

        response.setContentType(
                "application/json;charset=UTF-8"
        );

        response.getWriter().write(
                """
                        {"success":true,"deletedCount":%d}
                        """.formatted(result)
        );

        return null;
    }
}