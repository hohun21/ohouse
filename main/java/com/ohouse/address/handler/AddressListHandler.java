package com.ohouse.address.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.address.dto.ShippingAddressDTO;
import com.ohouse.address.service.ShippingAddressService;
import com.ohouse.common.handler.CommandHandler;

public class AddressListHandler implements CommandHandler {

    private ShippingAddressService addressService = new ShippingAddressService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        List<ShippingAddressDTO> addressList = addressService.getAddressList(authUser.getMemberId());
        request.setAttribute("addressList", addressList);
        
        return "/WEB-INF/views/member/addressList.jsp";
    }
}