package com.ohouse.member.handler;

import java.util.HashMap;
import java.util.Map;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.service.LoginFailException;
import com.ohouse.member.service.LoginService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginHandler implements CommandHandler {

    private static final String FORM_VIEW = "/WEB-INF/views/member/login.jsp";
    private LoginService loginService = new LoginService();

    @Override
    public String process(HttpServletRequest req, HttpServletResponse res) 
            throws Exception {
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

    private String processSubmit(HttpServletRequest req, HttpServletResponse res) 
            throws Exception {
        
        // 💡 핵심 변경: JSP 폼에 맞춰 email 대신 id로 파라미터를 받습니다.
        String id = trim(req.getParameter("id"));
        String password = trim(req.getParameter("password"));

        Map<String, Boolean> errors = new HashMap<>();
        req.setAttribute("errors", errors);

        // 변수명도 id로 통일
        if (id == null || id.isEmpty())
            errors.put("id", Boolean.TRUE);
        if (password == null || password.isEmpty())
            errors.put("password", Boolean.TRUE);

        if (!errors.isEmpty()) {
            return FORM_VIEW;
        }

        try {
            // Service로 넘길 때도 id를 넘겨줍니다.
            AuthUserDTO authUser = loginService.login(id, password);
            
            HttpSession session = req.getSession();
            session.setAttribute("authUser", authUser);

            String contextPath = req.getContextPath();
            String location;
            
            if ( "Seller".equals(authUser.getRole()) ) {
                location = contextPath + "/seller/main.htm";
            } else {
                location = contextPath + "/main.htm";
            }
            String referer = (String) session.getAttribute("referer");
            
            if( referer != null && referer.startsWith( contextPath + "/")) {
                location = referer;
            }
            session.removeAttribute("referer");
            
            res.sendRedirect(location);
            return null;
            
        } catch (LoginFailException e) {
            errors.put("idOrPwNotMatch", Boolean.TRUE);
            return FORM_VIEW;
        }
    }

    private String trim(String str) {
        return str == null ? null : str.trim();
    }
}