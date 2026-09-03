package com.ohouse.admin.handler;

import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.admin.service.AdminSettlementService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminExecuteSettlementHandler implements CommandHandler {

    private AdminSettlementService settlementService = new AdminSettlementService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }

        int orderDetailId = Integer.parseInt(request.getParameter("orderDetailId"));

        boolean success = settlementService.executeSettlement(orderDetailId);

        if (success) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('정산이 완료되었습니다.'); location.href='" + request.getContextPath() + "/admin/settlementList.htm';</script>");
            return null;
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('정산 처리에 실패했습니다.'); history.back();</script>");
            return null;
        }
    }
}