package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerService;
import com.ohouse.seller.dto.SellerAuthDTO;
import com.ohouse.seller.dto.ProductDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

public class SellerProductListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        SellerAuthDTO sellerAuth = (SellerAuthDTO) session.getAttribute("sellerAuth");
        
        if (sellerAuth == null) {
            return "redirect:" + request.getContextPath() + "/seller/login.htm";
        }
        
        String brandName = sellerAuth.getBrandName();
        
        SellerService sellerService = new SellerService();
        List<ProductDTO> productList = sellerService.getProductListByBrandName(brandName);
        
        request.setAttribute("productList", productList);
        
        return "/WEB-INF/views/seller/seller_product_list.jsp";
    }
}