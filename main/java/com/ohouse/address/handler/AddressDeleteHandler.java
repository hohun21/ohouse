package com.ohouse.address.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.address.service.ShippingAddressService;
import com.ohouse.common.handler.CommandHandler;

public class AddressDeleteHandler implements CommandHandler {
    private ShippingAddressService addressService = new ShippingAddressService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        int addressId = Integer.parseInt(request.getParameter("address_id"));
        addressService.deleteAddress(addressId, authUser.getMemberId());
        
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('배송지가 삭제되었습니다.');");
        out.println("location.href='" + request.getContextPath() + "/addressList.htm?openModal=true';");
        out.println("</script>");
        out.flush();
        out.close();
        
        return null;
    }
}