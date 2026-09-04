package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.dto.ProductFormDTO;
import com.ohouse.seller.service.SellerService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ProductEditProHandler implements CommandHandler {

    // R2 연동 상수 추가
    private static final String R2_ENDPOINT = "https://c118a7efdddd35d3edac1db3a63ed76d.r2.cloudflarestorage.com";
    private static final String R2_ACCESS_KEY = "8f8a91958a3c06d4ce11ba80f5d60e2f";
    private static final String R2_SECRET_KEY = "5ab97a22e5baa3fe630165a9e770f0eada870d8672aaea80d3258ccbc2440667";
    private static final String R2_BUCKET = "productimage";
    private static final String R2_PUBLIC_URL = "https://pub-3490b121289f419194b634a98c9d4ba5.r2.dev";

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        request.setCharacterEncoding("UTF-8");

        List<String> imageUrls = new ArrayList<>();
        List<String> imageTypes = new ArrayList<>();
        List<Integer> sortOrders = new ArrayList<>();

        // S3 클라이언트 생성 및 설정
        S3Configuration s3Configuration = S3Configuration.builder()
                .chunkedEncodingEnabled(false)
                .build();
                
        try (S3Client s3Client = S3Client.builder()
                .endpointOverride(URI.create(R2_ENDPOINT))
                .region(Region.of("auto"))
                .credentialsProvider(
                        StaticCredentialsProvider.create(
                                AwsBasicCredentials.create(R2_ACCESS_KEY, R2_SECRET_KEY)
                        )
                )
                .serviceConfiguration(s3Configuration)
                .build()) {

            int sortOrder = 1;

            // Multipart 이미지 파일 처리 및 R2 업로드
            for (Part part : request.getParts()) {
                if ("productImages".equals(part.getName()) && part.getSize() > 0) {
                    
                    String originalFileName = part.getSubmittedFileName();
                    String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
                    String objectKey = "products/" + savedFileName;

                    // R2에 실제 객체 저장 (Put)
                    PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                            .bucket(R2_BUCKET)
                            .key(objectKey)
                            .contentType(part.getContentType())
                            .build();

                    s3Client.putObject(
                            putObjectRequest,
                            RequestBody.fromInputStream(part.getInputStream(), part.getSize())
                    );

                    String imageUrl = R2_PUBLIC_URL + "/" + objectKey;
                    String imageType = (sortOrder == 1) ? "THUMBNAIL" : "DETAIL";

                    imageUrls.add(imageUrl);
                    imageTypes.add(imageType);
                    sortOrders.add(sortOrder);
                    sortOrder++;
                }
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
            return "redirect:" + request.getContextPath() + "/product/productDetail.htm?product_id=" + formDTO.getProductId();
        } else {
            return "redirect:" + request.getContextPath() + "/seller/editForm.htm?productId=" + formDTO.getProductId() + "&error=1";
        }
    }
}