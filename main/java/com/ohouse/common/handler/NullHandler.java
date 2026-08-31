package com.ohouse.common.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class NullHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.sendError(HttpServletResponse.SC_NOT_FOUND);
		return null;
	}

}
