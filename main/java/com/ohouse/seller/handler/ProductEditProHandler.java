package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.dto.ProductFormDTO; // 💡 DTO 임포트
import com.ohouse.seller.service.SellerService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ProductEditProHandler implements CommandHandler {

    private static final String UPLOAD_DIR = "C:/ohouse_uploads/products";

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        request.setCharacterEncoding("UTF-8");

        // 1. 이미지 처리
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) uploadDir.mkdirs(); 

        List<String> imageUrls = new ArrayList<>();
        List<String> imageTypes = new ArrayList<>();
        List<Integer> sortOrders = new ArrayList<>();

        int sortOrder = 1;
        for (Part part : request.getParts()) {
            if ("productImages".equals(part.getName()) && part.getSize() > 0) {
                String originalFileName = part.getSubmittedFileName();
                String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                part.write(UPLOAD_DIR + File.separator + savedFileName);
                String imageUrl = "/uploads/products/" + savedFileName;
                String imageType = (sortOrder == 1) ? "THUMBNAIL" : "DETAIL";

                imageUrls.add(imageUrl);
                imageTypes.add(imageType);
                sortOrders.add(sortOrder);
                sortOrder++;
            }
        }

        ProductFormDTO formDTO = ProductFormDTO.builder()
                .productId(Integer.parseInt(request.getParameter("productId")))
                .categoryId(Integer.parseInt(request.getParameter("categoryId")))
                .brandName(request.getParameter("brandName"))
                .productName(request.getParameter("productName"))
                .description(request.getParameter("description"))
                .originalPrice(Integer.parseInt(request.getParameter("originalPrice")))
                .discountRate(Integer.parseInt(request.getParameter("discountRate")))
                .price(Integer.parseInt(request.getParameter("price")))
                
                .optionNames(request.getParameterValues("optionNames"))
                .optionValues(request.getParameterValues("optionValues"))
                .skuNames(request.getParameterValues("skuNames"))
                .skuPrices(request.getParameterValues("skuPrices"))
                .skuStocks(request.getParameterValues("skuStocks"))
                .extraNames(request.getParameterValues("extraNames"))
                .extraPrices(request.getParameterValues("extraPrices"))
                .extraStocks(request.getParameterValues("extraStocks"))
                
                .imageUrls(imageUrls)
                .imageTypes(imageTypes)
                .sortOrders(sortOrders)
                .build();

        SellerService service = new SellerService();
        boolean isSuccess = service.updateProduct(formDTO);

        if (isSuccess) {
            return "redirect:" + request.getContextPath() + "/seller/detailTest.htm?productId=" + formDTO.getProductId();
        } else {
            return "redirect:" + request.getContextPath() + "/seller/editForm.htm?productId=" + formDTO.getProductId() + "&error=1";
        }
    }
}