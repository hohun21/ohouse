package com.ohouse.shopping.only.handler;

import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.shopping.only.dto.OnlyDTO;
import com.ohouse.shopping.only.service.OnlyService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class OnlyHandler implements CommandHandler {
	
	private OnlyService onlyService = new OnlyService();
	
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

		System.out.println("OnlyHandler.process() 실행 ");
		
		List<OnlyDTO> products =
				onlyService.getOnlyProducts();

		request.setAttribute("products", products);
		request.setAttribute("activeMenu", "only");
		return "/WEB-INF/views/shopping/only/only.jsp";
	}

}
