package com.ohouse.product.productDetail.handler;

import com.google.gson.Gson;
import com.ohouse.common.handler.CommandHandler;

import com.ohouse.product.productDetail.dto.ProductOptionDTO;
import com.ohouse.product.productDetail.service.ProductService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.List;

public class ProductOptionHandler implements CommandHandler {

    @Override
    public String process(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws Exception {

        long product_id =
                Long.parseLong(
                        request.getParameter("product_id")
                );

        String[] values =
                request.getParameter("option_value_ids")
                        .split(",");

        List<Long> option_value_ids =
                new ArrayList<>();

        for (String value : values) {

            option_value_ids.add(
                    Long.parseLong(value)
            );
        }

        ProductService service =
                new ProductService();

        ProductOptionDTO product_option =
                service.getProductOption(
                        product_id,
                        option_value_ids
                );

        Gson gson = new Gson();

        String json =
                gson.toJson(product_option);

        response.setContentType(
                "application/json"
        );

        response.setCharacterEncoding(
                "UTF-8"
        );

        response.getWriter().write(json);

        return null;
    }
}