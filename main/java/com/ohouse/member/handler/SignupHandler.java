package com.ohouse.member.handler;

import java.util.HashMap;
import java.util.Map;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.service.DuplicateEmailException;
import com.ohouse.member.service.LoginService;
import com.ohouse.member.service.SignupRequest;
import com.ohouse.member.service.SignupService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SignupHandler implements CommandHandler {

    private static final String FORM_VIEW = "/WEB-INF/views/member/signup.jsp";
    
    private SignupService signupService = new SignupService();
    private LoginService loginService = new LoginService();
    
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
        
        SignupRequest signupReq = new SignupRequest();
        
        // 💡 JSP의 name 속성에 맞춰 파라미터 추출
        signupReq.setId(req.getParameter("id"));
        signupReq.setName(req.getParameter("name"));
        signupReq.setPassword(req.getParameter("password"));
        signupReq.setPasswordConfirm(req.getParameter("passwordConfirm"));
        
        Map<String, Boolean> errors = new HashMap<>();
        req.setAttribute("errors", errors);
        
        signupReq.validate(errors);
        
        if (!errors.isEmpty()) {
            return FORM_VIEW;
        }
        
        try {
            signupService.signup(signupReq);
            
            AuthUserDTO authUser = loginService.login(
                    signupReq.getId(),
                    signupReq.getPassword()               
            );
                    
            req.getSession().setAttribute("authUser", authUser);
            
            res.sendRedirect(req.getContextPath() + "/main.htm?signup_popup=true");
            
            return null;
            
        } catch (DuplicateEmailException e) {
            errors.put("duplicateId", Boolean.TRUE);
            return FORM_VIEW;
        }
    }
}