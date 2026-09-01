package com.ohouse.address.dao;

import java.sql.Connection;
import java.util.List;

import com.ohouse.address.dto.ShippingAddressDTO;

public interface ShippingAddressDAO {
	
    int getAddressCount(Connection conn, int memberId) throws Exception;

    int resetDefaultAddress(Connection conn, int memberId) throws Exception;

    int insertAddress(Connection conn, ShippingAddressDTO dto) throws Exception;
    
    List<ShippingAddressDTO> getAddressList(Connection conn, int memberId) throws Exception;
    
    int updateDefaultAddress(Connection conn, int addressId, int memberId) throws Exception;
    
    int deleteAddress(Connection conn, int addressId, int memberId) throws Exception;
}