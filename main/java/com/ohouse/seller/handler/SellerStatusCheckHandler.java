package com.ohouse.seller.handler;

import java.io.PrintWriter;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.service.SellerLoginService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SellerStatusCheckHandler implements CommandHandler{

    private SellerLoginService loginService = new SellerLoginService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String email = trim(req.getParameter("email"));   

        System.out.println("> SellerStatusCheckHandler .... ");

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        
        String json;

        if (email == null || email.isBlank()) {
            res.setStatus( HttpServletResponse.SC_BAD_REQUEST );
            json = """
            		{
            			"success": false,
            			"status": null,
            			"code": "INVALID_EMAIL"
            		}
            		""";
        } else {
			try {
				String status = loginService.statusCheck(email);
				
				if (status == null) {
				    json = """
				        {
				            "success": true,
				            "status": null,
				            "code": "NOT_FOUND"
				        }
				        """;
				} else {
				    json = String.format("""
				        {
				            "success": true,
				            "status": "%s",
				            "code": "%s"
				        }
				        """, status, status);
				}
				
			} catch (SQLException | NamingException e) {
            e.printStackTrace();

            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            json = """
					{
						"success": false,
						"status": null,
						"code": "SERVER_ERROR"
					}
					""";
          }
        }
        try (PrintWriter out = res.getWriter()) {
			out.print(json);
		} 
        
        return null;
    }

    private String trim(String str) {
        return str == null ? null : str.trim();
    }
}