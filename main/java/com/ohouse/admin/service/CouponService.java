package com.ohouse.admin.service;

import java.sql.Connection;
import java.util.List;

import com.ohouse.admin.dao.CouponDAO;
import com.ohouse.admin.dao.CouponDAOImpl;
import com.ohouse.admin.dto.CouponDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class CouponService {
    
    private CouponDAO couponDAO = new CouponDAOImpl();

    public List<CouponDTO> getCouponList() throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            return couponDAO.selectAllCoupons(conn);
        }
    }

    public void addCoupon(CouponDTO coupon) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {
                couponDAO.insertCoupon(conn, coupon);
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public void updateCouponStatus(int couponId, int status) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {
                couponDAO.updateCouponStatus(conn, couponId, status);
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public void issueCouponToAll(int couponId) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {
                List<Integer> memberIds = couponDAO.selectAllActiveMemberIds(conn);
                
                if (memberIds != null && !memberIds.isEmpty()) {
                    couponDAO.insertMemberCouponBatch(conn, couponId, memberIds);
                }
                
                couponDAO.updateCouponStatus(conn, couponId, 1);
                
                conn.commit(); 
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }
}