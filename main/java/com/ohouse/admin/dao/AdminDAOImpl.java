package com.ohouse.admin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.member.dto.MemberDTO;

public class AdminDAOImpl implements AdminDAO {

    private Connection conn = null;

    public AdminDAOImpl(Connection conn) {
        this.conn = conn;
    }

    @Override
    public List<MemberDTO> getAllMembers() throws SQLException {
        List<MemberDTO> list = new ArrayList<>();
        String sql = "SELECT member_id, id, name, role, reg_date FROM member ORDER BY member_id DESC";
        
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                list.add(MemberDTO.builder()
                        .memberId(rs.getInt("member_id"))
                        .id(rs.getString("id"))     
                        .name(rs.getString("name"))
                        .role(rs.getString("role"))
                        .regDate(rs.getDate("reg_date"))
                        .build());
            }
        }
        return list;
    }

    @Override
    public int getTotalMemberCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM member";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    @Override
    public List<MemberDTO> getMemberListWithPaging(int startRow, int endRow) throws SQLException {
        List<MemberDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                   + "  SELECT a.*, ROWNUM rnum FROM ("
                   + "    SELECT member_id, id, name, role, reg_date FROM member ORDER BY member_id DESC"
                   + "  ) a WHERE ROWNUM <= ?"
                   + ") WHERE rnum >= ?";

        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, endRow);
            pstmt.setInt(2, startRow);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(MemberDTO.builder()
                            .memberId(rs.getInt("member_id"))
                            .id(rs.getString("id"))
                            .name(rs.getString("name"))
                            .role(rs.getString("role"))
                            .regDate(rs.getDate("reg_date"))
                            .build());
                }
            }
        }
        return list;
    }

    @Override
    public int deleteMember(int memberId) throws SQLException {
        String sql = "DELETE FROM member WHERE member_id = ?";
        try (PreparedStatement pstmt = this.conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            return pstmt.executeUpdate();
        }
    }
}