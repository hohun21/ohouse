package com.ohouse.search.handler;

import java.util.List;

import com.google.gson.Gson;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.search.dto.KeyWordDTO;
import com.ohouse.search.service.SearchService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TopKeywordHandler implements CommandHandler {

    private SearchService searchService = new SearchService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        

    	response.setContentType("application/json; charset=UTF-8");
    	
        List<KeyWordDTO> top10List = searchService.getTop10Keywords();

        String jsonData = new Gson().toJson(top10List);

        return jsonData; 
    }
}