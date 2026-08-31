package com.ohouse.seller.handler;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.ohouse.category.dto.CategoryDTO;
import com.ohouse.category.service.CategoryService;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.dto.ProductDTO;
import com.ohouse.seller.dto.ProductOptionDTO;
import com.ohouse.seller.service.SellerService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductEditFormHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        SellerService sellerService = new SellerService(); 
        CategoryService categoryService = new CategoryService();
        
        ProductDTO product = sellerService.getProductById(productId);
        
        List<Map<String, String>> optionItems = sellerService.getOptionItemsForEdit(productId);
        
        List<ProductOptionDTO> allOptions = sellerService.getOptionsByProductId(productId);
        List<ProductOptionDTO> skuList = new ArrayList<>();
        List<ProductOptionDTO> extraList = new ArrayList<>();
        
        if (allOptions != null) {
            for (ProductOptionDTO opt : allOptions) {
                if (opt.getSku() != null && opt.getSku().startsWith("[추가상품]")) {
                    extraList.add(opt);
                } else {
                    skuList.add(opt);
                }
            }
        }
        
        List<CategoryDTO> categoryList = categoryService.getLeafCategories();
        
        request.setAttribute("product", product);
        request.setAttribute("optionItems", optionItems);
        request.setAttribute("skuList", skuList);
        request.setAttribute("extraList", extraList);
        request.setAttribute("categoryList", categoryList);

        return "/WEB-INF/views/seller/seller_edit_form.jsp";
    }
}