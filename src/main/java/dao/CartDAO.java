package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import util.DBConnection;

public class CartDAO {
    
    /**
     * 사용자의 장바구니 아이템 조회
     */
    public List<Map<String, Object>> getCartItems(long memberId) throws SQLException {
        List<Map<String, Object>> items = new ArrayList<>();
        String sql = "SELECT c.cart_item_id, c.product_id, c.quantity, p.name, p.price " +
                     "FROM cart_item c " +
                     "JOIN product p ON c.product_id = p.product_id " +
                     "WHERE c.member_id = ? " +
                     "ORDER BY c.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("cartItemId", rs.getLong("cart_item_id"));
                    item.put("productId", rs.getLong("product_id"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("name", rs.getString("name"));
                    item.put("price", rs.getInt("price"));
                    items.add(item);
                }
            }
        }
        return items;
    }
    
    /**
     * 장바구니에 아이템 추가 (존재하면 수량 증가)
     */
    public void addOrUpdateCartItem(long memberId, long productId, int quantity) throws SQLException {
        String checkSql = "SELECT quantity FROM cart_item WHERE member_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO cart_item (member_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE cart_item SET quantity = quantity + ? WHERE member_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            // 기존 아이템 확인
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setLong(1, memberId);
                ps.setLong(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // 업데이트
                        try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                            updatePs.setInt(1, quantity);
                            updatePs.setLong(2, memberId);
                            updatePs.setLong(3, productId);
                            updatePs.executeUpdate();
                        }
                    } else {
                        // 삽입
                        try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                            insertPs.setLong(1, memberId);
                            insertPs.setLong(2, productId);
                            insertPs.setInt(3, quantity);
                            insertPs.executeUpdate();
                        }
                    }
                }
            }
        }
    }
    
    /**
     * 특정 장바구니 아이템 삭제
     */
    public void deleteCartItem(long memberId, long cartItemId) throws SQLException {
        String sql = "DELETE FROM cart_item WHERE cart_item_id = ? AND member_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartItemId);
            ps.setLong(2, memberId);
            ps.executeUpdate();
        }
    }
    
    /**
     * 사용자의 전체 장바구니 비우기
     */
    public void clearCart(long memberId) throws SQLException {
        String sql = "DELETE FROM cart_item WHERE member_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, memberId);
            ps.executeUpdate();
        }
    }
    
    /**
     * 로컬스토리지에서 받은 아이템들을 일괄 추가 (기존 카트는 유지)
     */
    public void addBulkCartItems(long memberId, List<Map<String, Object>> items) throws SQLException {
        if (items == null || items.isEmpty()) {
            return;
        }
        
        for (Map<String, Object> item : items) {
            Object productIdObj = item.get("productId");
            Object qtyObj = item.get("qty");
            
            if (productIdObj == null || qtyObj == null) {
                continue;
            }
            
            try {
                long productId = Long.parseLong(productIdObj.toString());
                int quantity = Integer.parseInt(qtyObj.toString());
                if (quantity > 0) {
                    addOrUpdateCartItem(memberId, productId, quantity);
                }
            } catch (NumberFormatException e) {
                System.err.println("[WARN] Invalid cart item format: " + item);
            }
        }
    }
}
