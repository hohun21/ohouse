package com.ohouse.seller.handler;

import java.util.List;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.seller.dto.SellerAuthDTO;
import com.ohouse.seller.dto.SellerOrderDTO;
import com.ohouse.seller.service.SellerOrderService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SellerSettlementListHandler implements CommandHandler {

    private SellerOrderService orderService = new SellerOrderService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("sellerAuth") == null) {
            return "redirect:" + request.getContextPath() + "/seller/login.htm";
        }
        
        SellerAuthDTO auth = (SellerAuthDTO) session.getAttribute("sellerAuth");
        String brandName = auth.getBrandName();

        List<SellerOrderDTO> settlementList = orderService.getSettlementList(brandName);

        long totalSales = 0;
        for (SellerOrderDTO item : settlementList) {
            totalSales += (long) item.getPrice() * item.getQuantity();
        }
        long totalCommission = (long) (totalSales * 0.02);
        long finalSettlement = totalSales - totalCommission;

        request.setAttribute("settlementList", settlementList);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalCommission", totalCommission);
        request.setAttribute("finalSettlement", finalSettlement);
        
        return "/WEB-INF/views/seller/settlement.jsp";
    }
}