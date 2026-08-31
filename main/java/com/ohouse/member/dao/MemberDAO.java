package com.ohouse.member.dao;

import java.sql.Connection;
import java.sql.SQLException;

import com.ohouse.member.dto.MemberDTO;

public interface MemberDAO {
    // 로그인 및 회원가입 관련 메서드
    MemberDTO selectByEmail(Connection conn, String email) throws SQLException;
    void insert(Connection conn, MemberDTO mem) throws SQLException;
    void update(Connection conn, MemberDTO member) throws SQLException;
    
    // 중복 체크
    String nameCheck(Connection conn, String name);
    String idCheck(Connection conn, String id);
}