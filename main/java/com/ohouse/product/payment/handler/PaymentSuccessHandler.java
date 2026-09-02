package com.ohouse.product.payment.handler;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.payment.dto.OrderRequsetDTO;
import com.ohouse.product.payment.service.OrderService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class PaymentSuccessHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String paymentKey = request.getParameter("paymentKey");
        String orderId = request.getParameter("orderId");
        int amount = Integer.parseInt(request.getParameter("amount"));

        System.out.println("paymentKey = " + paymentKey);
        System.out.println("orderId = " + orderId);
        System.out.println("amount = " + amount);

        // 시크릿 키
        String secretKey = "test_sk_KNbdOvk5rkDEJ0aoRkdn8n07xlzm";

        // 시크릿 키 + ":" -> Base64
        String encodedAuth = Base64.getEncoder()
                .encodeToString((secretKey + ":").getBytes(StandardCharsets.UTF_8));

        String json = String.format(
                "{\"paymentKey\":\"%s\",\"orderId\":\"%s\",\"amount\":%d}",
                paymentKey,
                orderId,
                amount
        );

        HttpRequest httpRequest = HttpRequest.newBuilder()
                .uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
                .header("Authorization","Basic " + encodedAuth)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(json))
                .build();

        HttpClient client = HttpClient.newHttpClient();

        HttpResponse<String> result = client.send(
                httpRequest,
                HttpResponse.BodyHandlers.ofString()
        );

        System.out.println("===== 토스 승인 응답 =====");
        System.out.println("HTTP Status = " + result.statusCode());
        System.out.println("Response = " + result.body());

        OrderService orderService = new OrderService();
        if (result.statusCode() == 200) {
            System.out.println("===== 결제 승인 성공 =====");
            System.out.println(result.body());


            JsonObject payment = JsonParser.parseString(result.body()).getAsJsonObject();
            String tossOrderId = payment.get("orderId").getAsString();
            int tossAmount = payment.get("totalAmount").getAsInt();

            if("DONE".equals(payment.get("status").getAsString())) {
                OrderRequsetDTO dto = (OrderRequsetDTO) request.getSession()
                        .getAttribute("orderdata");

                if(dto == null) {
                    throw new IllegalStateException("주문 정보가 세션에 없습니다.");
                }
                if(tossAmount != dto.getPaymentPrice()){
                    throw new IllegalStateException("결제 금액이 일치하지 않습니다.");
                }
                dto.setTossOrderId(orderId);
                AuthUserDTO authUser = (AuthUserDTO) request.getSession().getAttribute("authUser");
                int memberId = authUser.getMemberId();
                orderService.insertOrder(memberId,dto);


            }

        } else {
            System.out.println("===== 결제 승인 실패 =====");
            System.out.println(result.body());
        }

        return "/WEB-INF/views/product/ordersuccess.jsp";
    }
}
