package com.ohouse.admin.handler;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.admin.service.AdminService;

public class MemberDeleteHandler implements CommandHandler {
    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String memberIdStr = request.getParameter("memberId");
        if (memberIdStr != null && !memberIdStr.isEmpty()) {
            int memberId = Integer.parseInt(memberIdStr);
            AdminService service = new AdminService();
            service.deleteMember(memberId);
        }
        return "redirect:/admin/memberList.htm";
    }
}