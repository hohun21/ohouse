package com.ohouse.seller.handler;

import java.util.HashMap;
import java.util.Map;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.dto.SellerAuthDTO;
import com.ohouse.seller.service.SellerLoginFailException;
import com.ohouse.seller.service.SellerLoginService;
import com.ohouse.seller.service.SellerNotActiveException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SellerLoginHandler implements CommandHandler {

	private static final String FORM_VIEW =
			"/WEB-INF/views/seller/sellerLogin.jsp";

	private SellerLoginService loginService =
			new SellerLoginService();

	@Override
	public String process(
		HttpServletRequest req, HttpServletResponse res) throws Exception {

		if (req.getMethod().equalsIgnoreCase("GET")) {
			return processForm(req, res);

		} else if ( req.getMethod().equalsIgnoreCase("POST")) {
			return processSubmit(req, res);
		
		} else { res.setStatus( HttpServletResponse.SC_METHOD_NOT_ALLOWED );
			return null;
		}
	}

	private String processForm( HttpServletRequest req, HttpServletResponse res) {
		/*
         * 이미 판매자로 로그인한 상태라면 로그인 페이지 대신 메인 페이지로 이동
         */
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("sellerAuth") != null) {
            try { res.sendRedirect( req.getContextPath() + "/main.htm" );
                return null;
            } catch (Exception e) { throw new RuntimeException(e); }
        }
		return FORM_VIEW;
	}

	private String processSubmit(
	    HttpServletRequest req, HttpServletResponse res) throws Exception {

	    String email = trim(req.getParameter("email"));
	    String password = req.getParameter("password");
	    String businessNumber = normalizeBusinessNumber( req.getParameter("businessNumber"));

	    Map<String, Boolean> errors = new HashMap<>();
	    req.setAttribute("errors", errors);
	    // 오류가 발생해도 이메일과 사업자등록번호 유지
	    req.setAttribute("email", email);
	    req.setAttribute( "businessNumber", businessNumber );

	    if (email == null || email.isEmpty()) {
	        errors.put( "email", Boolean.TRUE );
	    }
	    if (password == null || password.isEmpty()) {
	        errors.put( "password", Boolean.TRUE );
	    }
	    if (businessNumber == null || !businessNumber.matches("\\d{10}")) {
	        errors.put( "businessNumber", Boolean.TRUE );
	    }

	    if (!errors.isEmpty()) {
	        return FORM_VIEW;
	    }

	    try {
            SellerAuthDTO sellerAuth =
                loginService.login( email, password, businessNumber );

	        HttpSession oldSession = req.getSession(false);
	        if (oldSession != null) { oldSession.invalidate(); }

            HttpSession session = req.getSession(true);
            session.setAttribute( "sellerAuth", sellerAuth );
            
	        res.sendRedirect( req.getContextPath() + "/main.htm" );
	        return null;

	    } catch (SellerNotActiveException e) {
	        errors.put( "notActive", Boolean.TRUE );
	        return FORM_VIEW;

	    } catch (SellerLoginFailException e) {
	        errors.put( "emailOrPwNotMatch", Boolean.TRUE );
	        return FORM_VIEW;
	    }
	}

	private String trim(String str) {
		return str == null ? null : str.trim();
	}
	
	private String normalizeBusinessNumber( String businessNumber ) {
	    if (businessNumber == null) {
	        return null;
	    }

	    return businessNumber.replaceAll( "[^0-9]", "" );
	}
}