package com.ohouse.address.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.address.dto.ShippingAddressDTO;
import com.ohouse.address.service.ShippingAddressService;
import com.ohouse.common.handler.CommandHandler;

public class AddressAddProHandler implements CommandHandler {

    private ShippingAddressService addressService = new ShippingAddressService();

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        
        
        ShippingAddressDTO dto = new ShippingAddressDTO();
        dto.setMember_id(authUser.getMemberId());
        dto.setAddress_name(request.getParameter("address_name"));
        dto.setRecipient_name(request.getParameter("recipient_name"));
        dto.setPhone(request.getParameter("phone"));
        dto.setZip_code(request.getParameter("zip_code"));
        dto.setBase_address(request.getParameter("base_address"));
        dto.setDetail_address(request.getParameter("detail_address"));
        dto.setRequest_msg(request.getParameter("request_msg"));
        
        String isDefault = request.getParameter("is_default");
        dto.setIs_default(isDefault != null ? "Y" : "N");
        
        int result = addressService.addShippingAddress(dto);
        
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        if (result == -1) {
            out.println("alert('배송지는 최대 3개까지만 등록할 수 있습니다.');");
            out.println("history.back();");
        } else if (result > 0) {
            out.println("alert('배송지가 성공적으로 등록되었습니다.');");
            out.println("location.href='" + request.getContextPath() + "/addressList.htm?openModal=true';"); // 여기도 꼬리표 추가!
        } else {
            out.println("alert('등록에 실패했습니다. 다시 시도해주세요.');");
            out.println("history.back();");
        }
        out.println("</script>");
        out.flush();
        out.close();
        
        return null; 
    }
}