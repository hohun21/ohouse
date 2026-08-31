package com.ohouse.member.service;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ohouse.member.dao.MemberDAO;
import com.ohouse.member.dao.MemberDAOImpl;
import com.ohouse.member.dto.AuthUserDTO;
import com.ohouse.member.dto.MemberDTO;
import com.ohouse.util.conn.ConnectionProvider;


public class LoginService {

    public AuthUserDTO login(String id, String password) {
        
        try (Connection conn = ConnectionProvider.getConnection()) {
            
            MemberDAO memberDao = new MemberDAOImpl(conn);
            
            MemberDTO member = memberDao.selectByEmail(conn, id);
            
            if (member == null) {
                throw new LoginFailException();
            }
            
            if (!member.getPassword().equals(password)) {
                throw new LoginFailException();
            }
            
            return new AuthUserDTO(
                member.getMemberId(), 
                member.getId(),
                member.getName(), 
                member.getRole()
            );
            
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        }
    }
}