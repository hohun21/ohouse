package com.ohouse.seller.handler;

import java.io.PrintWriter;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerAuthenticationException;
import com.ohouse.seller.service.SellerSignupStatusService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SellerSignupStatusHandler
        implements CommandHandler {

    private static final String FORM_VIEW =
            "/WEB-INF/views/seller/sellerSignupStatus.jsp";

    private SellerSignupStatusService statusService =
            new SellerSignupStatusService();

    @Override
    public String process(
            HttpServletRequest req,
            HttpServletResponse res) throws Exception {

        if (req.getMethod().equalsIgnoreCase("GET")) {
            return processForm(req, res);
        } else if (req.getMethod().equalsIgnoreCase("POST")) {
            processSubmit(req, res);
            return null;
        } else {
            res.setStatus( HttpServletResponse.SC_METHOD_NOT_ALLOWED );
            return null;
        }
    }

    private String processForm( 
    		HttpServletRequest req, HttpServletResponse res) {
        return FORM_VIEW;
    }

    private void processSubmit(
            HttpServletRequest req,
            HttpServletResponse res) {

        res.setContentType(
                "application/json; charset=UTF-8"
        );

        res.setCharacterEncoding("UTF-8");

        try {
            String email =
                    req.getParameter("email");

            String password =
                    req.getParameter("password");

            String businessNumber =
                    req.getParameter("businessNumber");

            if (email != null) {
                email = email.trim();
            }

            if (businessNumber != null) {
                businessNumber =
                        businessNumber.replaceAll(
                                "[^0-9]",
                                ""
                        );
            }

            if (email == null || email.isBlank()
                    || password == null
                    || password.isBlank()
                    || businessNumber == null
                    || !businessNumber.matches("\\d{10}")) {

                writeJson(
                        res,
                        false,
                        null,
                        "입력값을 다시 확인해 주세요."
                );

                return;
            }

            String status =
                    statusService.checkSignupStatus(
                            email,
                            password,
                            businessNumber
                    );

            writeJson(
                    res,
                    true,
                    status,
                    "입점 상태 조회가 완료되었습니다."
            );

        } catch (SellerAuthenticationException e) {

            writeJson(
                    res,
                    false,
                    null,
                    "이메일, 비밀번호 또는 사업자등록번호가 일치하지 않습니다."
            );

        } catch (Exception e) {
            e.printStackTrace();

            writeJson(
                    res,
                    false,
                    null,
                    "입점 상태를 조회하는 중 서버 오류가 발생했습니다."
            );
        }
    }

    private void writeJson(
            HttpServletResponse res,
            boolean success,
            String status,
            String message) {

        try {
            String statusJson =
                    status == null
                    ? "null"
                    : "\"" + escapeJson(status) + "\"";

            String json =
                    "{"
                  + "\"success\":" + success + ","
                  + "\"status\":" + statusJson + ","
                  + "\"message\":\""
                  + escapeJson(message)
                  + "\""
                  + "}";

            PrintWriter out = res.getWriter();

            out.print(json);
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}