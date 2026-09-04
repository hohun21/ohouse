package com.ohouse.member.handler;

import java.io.PrintWriter;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.service.LoginService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class StatusCheckHandler implements CommandHandler{

    private LoginService loginService = new LoginService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {

        String id = trim(req.getParameter("id"));   

        System.out.println("> statusCheckHandler .... ");

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        
        String json;

        if (id == null || id.isBlank()) {
            res.setStatus( HttpServletResponse.SC_BAD_REQUEST );
            json = """
            		{
            			"success": false,
            			"status": null,
            			"code": "INVALID_ID"
            		}
            		""";
        } else {
			try {
				Integer status = loginService.statusCheck(id);
				
				if ( status == null ) {
					json = """
							{
								"success": false,
								"status": null,
								"code": "NOT_FOUND"
							}
							""";
				}  else if ( status == 0 ) {
					json = """
								{
									"success": true,
									"status": 0,
									"code": "WITHDRAWN"
								}
								""";
		        } else if ( status == -1 ) {
		        	json = """
									{
										"success": true,
										"status": -1,
										"code": "STOP"
									}
									""";
		        } else {
					json = String.format("""
							{
								"success": true,
								"status": %d,
								"code": "ACTIVE"
							}
							""", status);
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