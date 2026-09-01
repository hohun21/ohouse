package com.ohouse.address.service;

import java.sql.Connection;
import java.util.List;

import com.ohouse.util.conn.ConnectionProvider;
import com.ohouse.address.dao.ShippingAddressDAO;
import com.ohouse.address.dao.ShippingAddressDAOImpl;
import com.ohouse.address.dto.ShippingAddressDTO;

public class ShippingAddressService {

    private ShippingAddressDAO addressDao = ShippingAddressDAOImpl.getInstance();

    public int addShippingAddress(ShippingAddressDTO dto) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            
            try {
                int count = addressDao.getAddressCount(conn, dto.getMember_id());
                if (count >= 3) {
                    return -1; 
                }
                
                if ("Y".equals(dto.getIs_default())) {
                    addressDao.resetDefaultAddress(conn, dto.getMember_id());
                } else if (count == 0) {
                    dto.setIs_default("Y");
                }
                
                int result = addressDao.insertAddress(conn, dto);
                
                conn.commit();
                return result;
                
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }


    public List<ShippingAddressDTO> getAddressList(int memberId) throws Exception {     
        try (Connection conn = ConnectionProvider.getConnection()) {
            return addressDao.getAddressList(conn, memberId);
        }
    }
    
    public boolean setDefaultAddress(int addressId, int memberId) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            conn.setAutoCommit(false);
            try {
                addressDao.resetDefaultAddress(conn, memberId);
                int result = addressDao.updateDefaultAddress(conn, addressId, memberId);
                
                conn.commit();
                return result > 0;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }

    public boolean deleteAddress(int addressId, int memberId) throws Exception {
        try (Connection conn = ConnectionProvider.getConnection()) {
            int result = addressDao.deleteAddress(conn, addressId, memberId);
            return result > 0;
        }
    }
}