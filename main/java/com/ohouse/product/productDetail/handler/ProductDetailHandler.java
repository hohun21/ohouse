package com.ohouse.product.productDetail.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.product.productDetail.dto.ProductDetailDTO;
import com.ohouse.product.productDetail.service.ProductService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductDetailHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        System.out.println("1. ProductDetailHandler 진입");

        if (request.getMethod().equals("GET")) {

            String product_id = request.getParameter("product_id");
            System.out.println("2. product_id = " + product_id);

            long pId = Long.parseLong(product_id);

            ProductService psvc = new ProductService();

            System.out.println("3. Service 호출 전");

            ProductDetailDTO pdto = psvc.getProductDetail(pId);

            System.out.println("4. Service 호출 후");

            request.setAttribute("pdto", pdto);

            System.out.println("5. JSP forward");

            return "/WEB-INF/views/shopping/product_detail.jsp";
        }

        return null;
    }
}