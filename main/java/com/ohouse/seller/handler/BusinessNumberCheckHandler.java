package com.ohouse.seller.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerSignupService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BusinessNumberCheckHandler implements CommandHandler {

	private final SellerSignupService sellerSignupService = new SellerSignupService();

	@Override
	public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
		String businessNumber = trim(req.getParameter("businessNumber"));

		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");

		if (businessNumber == null || !businessNumber.matches("\\d{10}")) {
			res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			res.getWriter().write("{\"count\":0,\"code\":\"INVALID_BUSINESS_NUMBER\"}");
			return null;
		}

		try {
			res.getWriter().write(sellerSignupService.buisinessNumberCheck(businessNumber));
		} catch (Exception e) {
			e.printStackTrace();
			res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			res.getWriter().write("{\"count\":0,\"code\":\"SERVER_ERROR\"}");
		}
		return null;
	}

	private String trim(String value) {
		return value == null ? null : value.trim();
	}
}