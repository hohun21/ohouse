package com.ohouse.admin.dao;

import java.sql.SQLException;
import java.util.List;

import com.ohouse.member.dto.MemberDTO;

public interface AdminDAO {
    List<MemberDTO> getAllMembers() throws SQLException;
    int getTotalMemberCount() throws SQLException;
    List<MemberDTO> getMemberListWithPaging(int startRow, int endRow) throws SQLException;
    int deleteMember(int memberId) throws SQLException;
}