package com.ohouse.shopping.best.handler;

import java.util.List;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.shopping.best.dto.BestDTO;
import com.ohouse.shopping.best.service.BestService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BestHandler implements CommandHandler {
	
	private BestService bestService = new BestService();
	
	@Override
	public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {

		System.out.println("BestHandler.process() 실행 ");
		
		List<BestDTO> bestProducts =
				bestService.getBestProducts();

		request.setAttribute("bestProducts", bestProducts);
		
		return "/WEB-INF/views/shopping/best/best.jsp";
	}
}
