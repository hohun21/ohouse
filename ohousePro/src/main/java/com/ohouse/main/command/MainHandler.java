package com.ohouse.main.command;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// 아까 만들어둔 공통 규칙(인터페이스)을 불러옵니다.
import com.ohouse.common.command.CommandHandler;

public class MainHandler implements CommandHandler {

	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		return "/WEB-INF/views/main/main.jsp";
	}

}