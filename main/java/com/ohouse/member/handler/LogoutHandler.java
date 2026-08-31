package com.ohouse.member.handler;

import com.ohouse.common.handler.CommandHandler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LogoutHandler implements CommandHandler {

	   @Override
	   public String process(HttpServletRequest req, HttpServletResponse res) 
	   throws Exception {
		   
	      HttpSession session = req.getSession(false);
	      
	      if (session != null) {
	         session.invalidate();
	      }
	      res.sendRedirect(req.getContextPath() + "/main.htm");
	      return null;
	   }

	}