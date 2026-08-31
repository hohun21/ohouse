package com.ohouse.main.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.search.dto.ProductSearchDTO;
import com.ohouse.main.service.MainService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

public class MainHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        MainService mainService = new MainService();
        
        List<ProductSearchDTO> randomProductList = mainService.getRandomProductList();
        
        request.setAttribute("randomProductList", randomProductList);
        
        return "/WEB-INF/views/main/main.jsp";
    }
}