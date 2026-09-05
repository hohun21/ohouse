package com.ohouse.admin.dao;

import java.sql.Connection;
import java.util.List;
import com.ohouse.admin.dto.CouponDTO;

public interface CouponDAO {
    List<CouponDTO> selectAllCoupons(Connection conn) throws Exception;
    
    void insertCoupon(Connection conn, CouponDTO coupon) throws Exception;
    
    void updateCouponStatus(Connection conn, int couponId, int status) throws Exception;
    
    List<Integer> selectAllActiveMemberIds(Connection conn) throws Exception;
    
    void insertMemberCouponBatch(Connection conn, int couponId, List<Integer> memberIds) throws Exception;
}