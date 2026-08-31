package com.ohouse.shopping.handler;



import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.productDetail.dto.ProductDTO;
import com.ohouse.product.productDetail.service.ProductService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class shoppingHomeHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

        ProductService psvc = new ProductService();
        List<ProductDTO> pdto = psvc.getProductList();

        request.setAttribute("pdto", pdto);

        return "/WEB-INF/views/shopping/shoppinghome.jsp";
    }
}
