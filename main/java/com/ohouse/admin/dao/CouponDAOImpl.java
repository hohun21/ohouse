package com.ohouse.admin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.admin.dto.CouponDTO;

public class CouponDAOImpl implements CouponDAO {

    @Override
    public List<CouponDTO> selectAllCoupons(Connection conn) throws Exception {
        List<CouponDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM coupon ORDER BY coupon_id DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
             
            while (rs.next()) {
                CouponDTO dto = CouponDTO.builder()
                        .couponId(rs.getInt("coupon_id"))
                        .couponName(rs.getString("coupon_name"))
                        .discountType(rs.getString("discount_type"))
                        .discountValue(rs.getInt("discount_value"))
                        .minOrderPrice(rs.getInt("min_order_price"))
                        .maxDiscount(rs.getObject("max_discount") != null ? rs.getInt("max_discount") : null)
                        .startDate(rs.getDate("start_date"))
                        .endDate(rs.getDate("end_date"))
                        .status(rs.getInt("status"))
                        .build();
                list.add(dto);
            }
        }
        return list;
    }

    @Override
    public void insertCoupon(Connection conn, CouponDTO coupon) throws Exception {
        String sql = "INSERT INTO coupon (coupon_id, coupon_name, discount_type, discount_value, min_order_price, max_discount, start_date, end_date) " +
                     "VALUES (coupon_seq.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE, ?)";
                     
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, coupon.getCouponName());
            pstmt.setString(2, coupon.getDiscountType());
            pstmt.setInt(3, coupon.getDiscountValue());
            pstmt.setInt(4, coupon.getMinOrderPrice());
            
            if (coupon.getMaxDiscount() != null) {
                pstmt.setInt(5, coupon.getMaxDiscount());
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            pstmt.setDate(6, new java.sql.Date(coupon.getEndDate().getTime()));
            pstmt.executeUpdate();
        }
    }

    @Override
    public void updateCouponStatus(Connection conn, int couponId, int status) throws Exception {
        String sql = "UPDATE coupon SET status = ? WHERE coupon_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, status);
            pstmt.setInt(2, couponId);
            pstmt.executeUpdate();
        }
    }

    @Override
    public List<Integer> selectAllActiveMemberIds(Connection conn) throws Exception {
        List<Integer> memberIds = new ArrayList<>();
        String sql = "SELECT member_id FROM member WHERE status = 1";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                memberIds.add(rs.getInt("member_id"));
            }
        }
        return memberIds;
    }

    @Override
    public void insertMemberCouponBatch(Connection conn, int couponId, List<Integer> memberIds) throws Exception {
        String sql = "INSERT INTO member_coupon (member_coupon_id, member_id, coupon_id, issued_date, status) " +
                     "VALUES (member_coupon_seq.NEXTVAL, ?, ?, SYSDATE, 'AVAILABLE')";
                     
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int memberId : memberIds) {
                pstmt.setInt(1, memberId);
                pstmt.setInt(2, couponId);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }
}