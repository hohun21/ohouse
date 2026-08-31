package com.ohouse.member.service;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.NamingException;

import com.ohouse.member.dao.MemberDAO;
import com.ohouse.member.dao.MemberDAOImpl;
import com.ohouse.member.dto.MemberDTO;
import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.util.conn.JdbcUtil;

public class ChangePasswordService {

    public boolean checkCurrentPassword(String userId, String currentPwd) {
        try (Connection conn = ConnectionProvider.getConnection()) {
            MemberDAO memberDao = new MemberDAOImpl(conn);
            MemberDTO member = memberDao.selectByEmail(conn, userId);
            
            if (member == null) {
                return false;
            }
            return currentPwd.equals(member.getPassword());
        } catch (SQLException | NamingException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void changePassword(String userId, String currentPwd, String newPwd) {
        Connection conn = null;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            MemberDAO memberDao = new MemberDAOImpl(conn);
            MemberDTO member = memberDao.selectByEmail(conn, userId);

            if (member == null) {
                throw new RuntimeException("회원 정보를 찾을 수 없습니다.");
            }


            if (!currentPwd.equals(member.getPassword())) {
                throw new RuntimeException("현재 비밀번호가 일치하지 않습니다.");
            }

            member.changePassword(newPwd);
            memberDao.update(conn, member);

            conn.commit();

        } catch (SQLException | NamingException e) {
            JdbcUtil.rollback(conn);
            throw new RuntimeException(e);
        } catch (RuntimeException e) {
            JdbcUtil.rollback(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }
}