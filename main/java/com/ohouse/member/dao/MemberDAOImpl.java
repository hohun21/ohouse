package com.ohouse.member.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.ohouse.member.dto.MemberDTO;
import com.ohouse.util.conn.JdbcUtil;

public class MemberDAOImpl implements MemberDAO {

    private Connection conn = null;

    public MemberDAOImpl(Connection conn) {
        this.conn = conn;
    }

    private java.sql.Date toDate(java.sql.Timestamp date) {
        return date == null ? null : new java.sql.Date(date.getTime());
    }
    
    @Override
    public int delete(Connection conn, int memberId) throws SQLException {
        String sql = """
                DELETE FROM member
                WHERE member_id = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public MemberDTO selectByEmail(Connection conn, String email) throws SQLException {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            pstmt = conn.prepareStatement("SELECT * FROM member WHERE id = ?");
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();

            MemberDTO member = null;
            if (rs.next()) {
                member = MemberDTO.builder()
                        .memberId(rs.getInt("member_id"))
                        .id(rs.getString("id"))
                        .password(rs.getString("password"))
                        .name(rs.getString("name"))
                        .regDate(toDate(rs.getTimestamp("reg_date")))
                        .role(rs.getString("role"))
                        .rank(rs.getString("rank"))
                        .build();
            }
            return member;
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(pstmt);
        }
    }

    @Override
    public int insert(Connection conn, MemberDTO mem) throws SQLException {
        String sql = "INSERT INTO member " +
                "(member_id, id, password, name, reg_date, rank, role) " +
                "VALUES (seq_member.NEXTVAL, ?, ?, ?, SYSDATE, 'NORMAL', 'USER')";

        try (PreparedStatement pstmt = conn.prepareStatement(
                sql, new String[]{"MEMBER_ID"})) {

            pstmt.setString(1, mem.getId());
            pstmt.setString(2, mem.getPassword());
            pstmt.setString(3, mem.getName());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new SQLException("회원 ID를 가져오지 못했습니다.");
    }

    @Override
    public void update(Connection conn, MemberDTO member) throws SQLException {
        try (PreparedStatement pstmt = conn.prepareStatement(
                "UPDATE member SET password = ? WHERE id = ?")) {
            pstmt.setString(1, member.getPassword());
            pstmt.setString(2, member.getId());
            pstmt.executeUpdate();
        }
    }

    @Override
    public String nameCheck(Connection conn, String name) {
        String sql = "SELECT COUNT(*) cnt FROM member WHERE name = ?";
        ResultSet rs = null;
        String jsonResult = null;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int cnt = rs.getInt("cnt");
                jsonResult = String.format("{ \"count\":%d }", cnt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs);
        }
        return jsonResult;
    }

    @Override
    public String idCheck(Connection conn, String id) {
        String sql = "SELECT COUNT(*) cnt FROM member WHERE id = ?";
        ResultSet rs = null;
        String jsonResult = null;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt("cnt");
                jsonResult = String.format("{\"count\":%d}", count);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            jsonResult = "{\"count\":0,\"code\":\"SERVER_ERROR\"}";
        } finally {
            JdbcUtil.close(rs);
        }
        return jsonResult;
    }
}