package com.ohouse.product.order.handler;

import com.ohouse.address.dto.ShippingAddressDTO;
import com.ohouse.address.service.ShippingAddressService;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.product.order.dto.OrderItemDTO;
import com.ohouse.product.productDetail.service.ProductService;
import com.ohouse.shopping.domain.CouponDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

public class OrderHandler implements CommandHandler {


    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String from = request.getParameter("from");
        HttpSession session = request.getSession();
        if ("cart".equals(from)) {
            List<OrderItemDTO> orderdto =
                    (List<OrderItemDTO>) request.getSession()
                            .getAttribute("orderItems");

            request.setAttribute("orderdto", orderdto);
        } else {
            List<OrderItemDTO> orderdto =
                    (List<OrderItemDTO>) request.getSession().getAttribute("orderItems");

            request.setAttribute("orderdto", orderdto);

            AuthUserDTO memberDTO =
                    (AuthUserDTO) request.getSession().getAttribute("authUser");

            // 회원 쿠폰 조회
            if (memberDTO != null) {
                int member_id = memberDTO.getMemberId();
                ProductService psvc = new ProductService();
                List<CouponDTO> clist =
                        psvc.getCouponList(member_id);

                request.setAttribute("clist", clist);
            }
        }
        
        AuthUserDTO authUser = (AuthUserDTO) session.getAttribute("authUser");
        if (authUser != null) {
        	ShippingAddressService addressService = new ShippingAddressService();
        	
            List<ShippingAddressDTO> addressList = addressService.getAddressList(authUser.getMemberId());
            request.setAttribute("addressList", addressList);
        }


        return "/WEB-INF/views/shopping/order.jsp";
    }
}