package com.ohouse.member.service;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.NamingException;

import com.ohouse.member.dao.MemberDAO;
import com.ohouse.member.dao.MemberDAOImpl;
import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.util.conn.JdbcUtil;

public class WithdrawService {

    public void withdraw(int memberId) {
        Connection conn = null;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);

            MemberDAO memberDao = new MemberDAOImpl(conn);

            int result = memberDao.delete(conn, memberId);

            if (result == 0) {
                throw new RuntimeException("회원 정보를 찾을 수 없습니다.");
            }

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