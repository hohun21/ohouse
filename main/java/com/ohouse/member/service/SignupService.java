package com.ohouse.member.service;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import com.ohouse.member.dao.MemberDAO;
import com.ohouse.member.dao.MemberDAOImpl;
import com.ohouse.member.dto.MemberDTO;
import com.ohouse.product.cart.dao.CartDAO;
import com.ohouse.product.cart.dao.CartDAOImpl;
import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.util.conn.JdbcUtil;


public class SignupService {

    public MemberDTO signup(SignupRequest signupReq) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            MemberDAO memberDao = new MemberDAOImpl(conn);
            CartDAO cartDao = new CartDAOImpl();

            String id = signupReq.getId();
            String name = signupReq.getName();          

            // DAO 메서드명은 유지하되, 파라미터는 새로 바뀐 id를 전달합니다.
            MemberDTO foundMember = memberDao.selectById(conn, id);
            if (foundMember != null) {
                JdbcUtil.rollback(conn);
                throw new DuplicateEmailException(); // 예외 이름은 그대로 유지
            }
            
            int member_id = memberDao.insert(conn,
                    new MemberDTO(
                            id, 
                            signupReq.getPassword(),
                            name) 
                    );
            cartDao.createCart(conn,member_id);
            
            MemberDTO newMember = memberDao.selectById(conn, id);

            conn.commit();

            return newMember;

        } catch (SQLException | NamingException e) {
            JdbcUtil.rollback(conn);
            throw new RuntimeException(e);
        } finally {
            JdbcUtil.close(conn);
        }
    }

    // 💡 메서드명 변경: JSP의 Ajax가 호출할 id 중복 체크
    public String idCheck(String id) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            MemberDAO memberDao = new MemberDAOImpl(conn); 
            
            String idCheckJson = memberDao.idCheck(conn, id); 
            return idCheckJson;
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        } 
    }

    // 💡 메서드명 변경: JSP의 Ajax가 호출할 닉네임(이름) 중복 체크
    public String nameCheck(String name) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            MemberDAO memberDao = new MemberDAOImpl(conn); 
            
            String nameCheckJson = memberDao.nameCheck(conn, name); 
            return nameCheckJson;
        } catch (SQLException | NamingException e) {
            throw new RuntimeException(e);
        } 
    }
}