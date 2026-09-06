package com.ohouse.member.dao;

import com.ohouse.member.dto.CouponDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CouponDAO {



    public List<CouponDTO> selectAllCoupons(Connection conn, int member_id) {
        CouponDTO cdto = null;
        List<CouponDTO> clist = new ArrayList<>();

        String sql = """
                   SELECT c.coupon_name
                        ,c.discount_type
                        ,c.discount_value
                        ,c.min_order_price
                        ,c.max_discount
                        ,c.start_date
                        ,c.end_date
                       ,mc.member_coupon_id
                        ,mc.issued_date
                        ,mc.used_date
                        ,mc.status
                   FROM coupon c
                            JOIN member_coupon mc
                                 ON c.coupon_id = mc.coupon_id
                   WHERE mc.member_id = ?
                """;
        try (
                PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setInt(1, member_id);
            try (ResultSet rs = pstmt.executeQuery();) {

                while (rs.next()) {

                    cdto = CouponDTO.builder()
                            .member_coupon_id(rs.getInt("member_coupon_id"))
                            .coupon_name((rs.getString("coupon_name")))
                            .discount_type(rs.getString("discount_type"))
                            .discount_value(rs.getDouble(("discount_value")))
                            .min_order_price(rs.getLong(("min_order_price")))
                            .max_discount(rs.getLong(("max_discount")))
                            .start_date(rs.getDate("start_date"))
                            .end_date(rs.getDate("end_date"))
                            .issued_date(rs.getDate("issued_date"))
                            .used_date(rs.getTimestamp("used_date"))
                            .status(rs.getString("status"))
                            .build();
                    clist.add(cdto);
                }

            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return clist;
    }
    public int getCouponCount(Connection conn, int member_id) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM MEMBER_COUPON
                WHERE MEMBER_ID = ?
                """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, member_id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }
}
