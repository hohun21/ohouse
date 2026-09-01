package com.ohouse.address.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.ohouse.address.dto.ShippingAddressDTO;

public class ShippingAddressDAOImpl implements ShippingAddressDAO {

    private static ShippingAddressDAOImpl instance = new ShippingAddressDAOImpl();
    private ShippingAddressDAOImpl() {}
    public static ShippingAddressDAOImpl getInstance() { return instance; }

    @Override
    public int getAddressCount(Connection conn, int memberId) throws Exception {
        String sql = "SELECT COUNT(*) FROM shipping_address WHERE member_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    @Override
    public int resetDefaultAddress(Connection conn, int memberId) throws Exception {
        String sql = "UPDATE shipping_address SET is_default = 'N' WHERE member_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int insertAddress(Connection conn, ShippingAddressDTO dto) throws Exception {
        String sql = "INSERT INTO shipping_address (address_id, member_id, address_name, recipient_name, phone, zip_code, base_address, detail_address, is_default, request_msg) "
                   + "VALUES (seq_shipping_address.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, dto.getMember_id());
            pstmt.setString(2, dto.getAddress_name());
            pstmt.setString(3, dto.getRecipient_name());
            pstmt.setString(4, dto.getPhone());
            pstmt.setString(5, dto.getZip_code());
            pstmt.setString(6, dto.getBase_address());
            pstmt.setString(7, dto.getDetail_address());
            pstmt.setString(8, dto.getIs_default());
            pstmt.setString(9, dto.getRequest_msg());
            
            return pstmt.executeUpdate();
        }
    }

    public List<ShippingAddressDTO> getAddressList(Connection conn, int memberId) throws Exception {
        List<ShippingAddressDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM shipping_address WHERE member_id = ? ORDER BY is_default DESC, address_id DESC";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ShippingAddressDTO dto = new ShippingAddressDTO();
                    dto.setAddress_id(rs.getInt("address_id"));
                    dto.setMember_id(rs.getInt("member_id"));
                    dto.setAddress_name(rs.getString("address_name"));
                    dto.setRecipient_name(rs.getString("recipient_name"));
                    dto.setPhone(rs.getString("phone"));
                    dto.setZip_code(rs.getString("zip_code"));
                    dto.setBase_address(rs.getString("base_address"));
                    dto.setDetail_address(rs.getString("detail_address"));
                    dto.setIs_default(rs.getString("is_default"));
                    dto.setRequest_msg(rs.getString("request_msg"));
                    list.add(dto);
                }
            }
        }
        return list;
    }
    
    @Override
    public int updateDefaultAddress(Connection conn, int addressId, int memberId) throws Exception {
        String sql = "UPDATE shipping_address SET is_default = 'Y' WHERE address_id = ? AND member_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, addressId);
            pstmt.setInt(2, memberId);
            return pstmt.executeUpdate();
        }
    }

    @Override
    public int deleteAddress(Connection conn, int addressId, int memberId) throws Exception {
        String sql = "DELETE FROM shipping_address WHERE address_id = ? AND member_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, addressId);
            pstmt.setInt(2, memberId);
            return pstmt.executeUpdate();
        }
    }
}