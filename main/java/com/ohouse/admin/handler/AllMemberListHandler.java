package com.ohouse.admin.handler;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ohouse.admin.service.AdminService;
import com.ohouse.common.handler.CommandHandler;
import com.ohouse.member.dto.MemberDTO;

public class AllMemberListHandler implements CommandHandler {

    @Override
    public String process(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        AdminService adminService = new AdminService();
        
        String pageParam = request.getParameter("page");
        int currentPage = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
        
        int pageSize = 15;
        int pageBlock = 10;
        
        int startRow = (currentPage - 1) * pageSize + 1;
        int endRow = currentPage * pageSize;
        
        int totalCount = adminService.getTotalMemberCount();
        List<MemberDTO> memberList = adminService.getMemberListWithPaging(startRow, endRow);
        
        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
        int endPage = startPage + pageBlock - 1;
        if (endPage > totalPage) endPage = totalPage;
        
        request.setAttribute("memberList", memberList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        
        return "/WEB-INF/views/admin/all_member_list.jsp";
    }
}