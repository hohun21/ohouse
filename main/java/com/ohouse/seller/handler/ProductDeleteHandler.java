package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductDeleteHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        SellerService service = new SellerService();
        boolean result = service.deleteProduct(productId);
        
        if (result) {
        	return "redirect:" + request.getContextPath() + "/seller/productList.htm";
        } else {
            response.setContentType("text/html; charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();
            out.print("<script>alert('삭제 실패!'); history.back();</script>");
            out.flush();
            return null;
        }
    }
}