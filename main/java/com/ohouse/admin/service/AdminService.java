package com.ohouse.admin.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import com.ohouse.admin.dao.AdminDAO;
import com.ohouse.admin.dao.AdminDAOImpl;
import com.ohouse.member.dto.MemberDTO;
import com.ohouse.seller.dao.SellerDAO;
import com.ohouse.seller.dao.SellerDAOImpl;
import com.ohouse.seller.dto.ProductDTO;
import com.ohouse.seller.dto.SellerDTO;
import com.ohouse.util.conn.ConnectionProvider;

public class AdminService {

    public List<SellerDTO> getPendingSellers() {
        Connection conn = null;
        List<SellerDTO> pendingList = null;

        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn); 
            pendingList = dao.getPendingSellers();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
        return pendingList;
    }

    // 2. 판매자 상태 변경
    public boolean updateSellerStatus(int sellerId, String status) {
        Connection conn = null;
        boolean isSuccess = false;

        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); 

            SellerDAO dao = new SellerDAOImpl(conn);
            int result = dao.updateSellerStatus(sellerId, status);

            if (result > 0) {
                conn.commit();
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception e) {}
            }
        }
        return isSuccess;
    }

    public int getPendingSellerCount() {
        Connection conn = null;
        int count = 0;
        try {
            conn = ConnectionProvider.getConnection();
            count = new SellerDAOImpl(conn).getPendingSellerCount();
        } catch (Exception e) {
            e.printStackTrace(); 
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {} 
        }
        return count;
    }

    public List<SellerDTO> getPendingSellersWithPaging(int startRow, int endRow) {
        Connection conn = null;
        List<SellerDTO> list = null;
        try {
            conn = ConnectionProvider.getConnection();
            list = new SellerDAOImpl(conn).getPendingSellersWithPaging(startRow, endRow);
        } catch (Exception e) {
            e.printStackTrace(); 
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {} 
        }
        return list;
    }
    
    public int getTotalSellerCount() {
        Connection conn = null;
        int count = 0;
        try {
            conn = ConnectionProvider.getConnection();
            count = new SellerDAOImpl(conn).getTotalSellerCount();
        } catch (Exception e) { e.printStackTrace(); } 
        finally { if (conn != null) try { conn.close(); } catch (Exception e) {} }
        return count;
    }

    public List<SellerDTO> getSellerListWithPaging(int startRow, int endRow) {
        Connection conn = null;
        List<SellerDTO> list = null;
        try {
            conn = ConnectionProvider.getConnection();
            list = new SellerDAOImpl(conn).getSellerListWithPaging(startRow, endRow);
        } catch (Exception e) { e.printStackTrace(); } 
        finally { if (conn != null) try { conn.close(); } catch (Exception e) {} }
        return list;
    }

    public boolean deleteSeller(int sellerId) {
        Connection conn = null;
        boolean isSuccess = false;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            
            SellerDAO dao = new SellerDAOImpl(conn);
            int result = dao.deleteSeller(sellerId);
            
            if (result > 0) {
                conn.commit();
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
        } finally {
            if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) {} }
        }
        return isSuccess;
    }


    public List<MemberDTO> getAllMembers() {
        Connection conn = null;
        List<MemberDTO> list = null;
        try {
            conn = ConnectionProvider.getConnection();
            AdminDAO dao = new AdminDAOImpl(conn);
            list = dao.getAllMembers();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
        return list;
    }

    public int getTotalMemberCount() {
        Connection conn = null;
        int count = 0;
        try {
            conn = ConnectionProvider.getConnection();
            count = new AdminDAOImpl(conn).getTotalMemberCount();
        } catch (Exception e) {
            e.printStackTrace(); 
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {} 
        }
        return count;
    }

    public List<MemberDTO> getMemberListWithPaging(int startRow, int endRow) {
        Connection conn = null;
        List<MemberDTO> list = null;
        try {
            conn = ConnectionProvider.getConnection();
            list = new AdminDAOImpl(conn).getMemberListWithPaging(startRow, endRow);
        } catch (Exception e) {
            e.printStackTrace(); 
        } finally { 
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        return list;
    }

    // 💡 기존 deleteMember 대신 새로 추가된 논리적 삭제(상태 변경) 로직
    public boolean changeMemberStatus(int memberId, int status) {
        Connection conn = null;
        boolean isSuccess = false;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false); // 안전하게 트랜잭션 처리
            
            AdminDAO dao = new AdminDAOImpl(conn);
            int result = dao.updateMemberStatus(conn, memberId, status);
            
            if (result > 0) {
                conn.commit();
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
        } finally {
            if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) {} }
        }
        return isSuccess;
    }

    public List<ProductDTO> getAllProductsForAdmin() {
        Connection conn = null;
        List<ProductDTO> list = null;
        try {
            conn = ConnectionProvider.getConnection();
            SellerDAO dao = new SellerDAOImpl(conn);
            list = dao.getAllProductsForAdmin();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) { try { conn.close(); } catch (Exception e) {} }
        }
        return list;
    }

    public boolean deleteProductByAdmin(int productId) {
        Connection conn = null;
        boolean isSuccess = false;
        try {
            conn = ConnectionProvider.getConnection();
            conn.setAutoCommit(false);
            
            SellerDAO dao = new SellerDAOImpl(conn);
            int result = dao.deleteProduct(productId);
            
            if (result > 0) {
                conn.commit();
                isSuccess = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) { try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
        } finally {
            if (conn != null) { try { conn.setAutoCommit(true); conn.close(); } catch (Exception e) {} }
        }
        return isSuccess;
    }
}