package com.ohouse.seller.handler;

import java.util.HashMap;
import java.util.Map;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.service.DuplicateEmailException;
import com.ohouse.seller.service.SellerSignupRequest;
import com.ohouse.seller.service.SellerSignupService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SellerSignupHandler implements CommandHandler {

	private static final String FORM_VIEW =
	        "/WEB-INF/views/seller/sellerSignup.jsp";
	private SellerSignupService sellerSignupService = new SellerSignupService();
   
	@Override
   public String process(HttpServletRequest req, HttpServletResponse res) throws Exception {
      if (req.getMethod().equalsIgnoreCase("GET")) {
         return processForm(req, res);
      } else if (req.getMethod().equalsIgnoreCase("POST")) {
         return processSubmit(req, res);
      } else {
         res.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
         return null;
      }
   }

   private String processForm(HttpServletRequest req, HttpServletResponse res) {
      return FORM_VIEW;
   }

   private String processSubmit(HttpServletRequest req, HttpServletResponse res) throws Exception {

	   SellerSignupRequest sellerSignupRequest = new SellerSignupRequest();
	      
	   sellerSignupRequest.setEmailId(req.getParameter("emailId"));
	   sellerSignupRequest.setEmailDomain(req.getParameter("emailDomain"));
	   sellerSignupRequest.setPassword(req.getParameter("password"));
	   sellerSignupRequest.setPasswordConfirm(req.getParameter("passwordConfirm"));
	   sellerSignupRequest.setBrandName(req.getParameter("brandName"));
	   sellerSignupRequest.setRepresentativeName(req.getParameter("representativeName"));
	   sellerSignupRequest.setBusinessNumber(req.getParameter("businessNumber"));
	   sellerSignupRequest.setMailOrderNumber(req.getParameter("mailOrderNumber"));
	   sellerSignupRequest.setBusinessAddrLine1(req.getParameter("businessAddrLine1"));
	   sellerSignupRequest.setBusinessAddrLine2(req.getParameter("businessAddrLine2"));
	   sellerSignupRequest.setRepresentativeContact(req.getParameter("representativeContact"));
	   sellerSignupRequest.setCustomerServicePhone(req.getParameter("customerServicePhone"));
	   
	   Map<String, Boolean> errors = new HashMap<>();
	   req.setAttribute("errors", errors);
	      
	   sellerSignupRequest.validate(errors);
	      
	   if (!errors.isEmpty()) {
	      return FORM_VIEW;
	   }
	      
	   try {
		   sellerSignupService.signup(sellerSignupRequest);
		   
		   return "/WEB-INF/views/seller/sellerSignupStatus.jsp";
	    	 
	      } catch (DuplicateEmailException e) {
	         errors.put("duplicateEmail", Boolean.TRUE);
	         return FORM_VIEW;
	      }
	   }
   }
