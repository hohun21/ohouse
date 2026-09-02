package com.ohouse.admin.handler;

import java.util.List;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.admin.service.AdminSettlementService;
import com.ohouse.seller.dto.SellerOrderDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminSettlementListHandler implements CommandHandler {

    private AdminSettlementService settlementService = new AdminSettlementService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        if (authUser == null || !"ADMIN".equals(authUser.getRole())) {
            return "redirect:" + request.getContextPath() + "/login.htm";
        }

        List<SellerOrderDTO> settlementList = settlementService.getAdminSettlementList();

        request.setAttribute("settlementList", settlementList);

        return "/WEB-INF/views/admin/settlement_list.jsp";
    }
}