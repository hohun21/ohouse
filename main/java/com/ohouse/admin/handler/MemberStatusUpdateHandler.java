package com.ohouse.admin.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.AdminService;

public class MemberStatusUpdateHandler implements CommandHandler {
    
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String memberIdStr = request.getParameter("member_id");
        String statusStr = request.getParameter("status");
        
        if (memberIdStr != null && !memberIdStr.isEmpty() && statusStr != null && !statusStr.isEmpty()) {
            
            int memberId = Integer.parseInt(memberIdStr);
            int status = Integer.parseInt(statusStr);
            
            AdminService service = new AdminService();
            service.changeMemberStatus(memberId, status);
        }
        
        return "redirect:" + request.getContextPath() + "/admin/memberList.htm";
    }
}