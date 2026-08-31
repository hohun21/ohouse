package com.ohouse.filter;



import com.ohouse.member.dto.AuthUserDTO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/order.htm", "/couponlist.htm", "/cart.htm", "/cartAdd.htm"})
public class LoginFilter extends HttpFilter implements Filter {
    public LoginFilter() {
        super();
    }

    @Override
    public void doFilter(ServletRequest frequest, ServletResponse fresponse, FilterChain chain) throws IOException, ServletException {
        System.out.println("AuthenticationFilter.doFilter()....");
        HttpServletRequest request = (HttpServletRequest) frequest;
        HttpServletResponse response = (HttpServletResponse) fresponse;

        // 필터링 작업 코딩
        // 인증세션 : "authUser" 세션이름 저장 AuthUser 객체저장.
        HttpSession session = request.getSession(false); // 세션 없으면 null 반환
        AuthUserDTO mdto = null;
        boolean isLogin = false;
        if (session != null) {
            mdto = (AuthUserDTO)session.getAttribute("authUser");
            if (mdto != null) {
                isLogin = true;
            } // if
        } // if
        if (isLogin) {
            chain.doFilter(request, response);
        } else {
            String referer = request.getRequestURI();
            System.out.println(referer);
            session.setAttribute("referer", referer);

            String location = "/login.htm";
            response.sendRedirect(location);
        }
        // 다음 행동 ㄱㄱ

    }

    @Override
    public void destroy() {

    }


    public void init(FilterConfig fconfig) throws ServletException {

    }
}
