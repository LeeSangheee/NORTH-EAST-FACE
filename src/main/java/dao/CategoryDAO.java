package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBConnection;

public class CategoryDAO {
    
    public static class Category {
        private long categoryId;
        private String name;
        private int displayOrder;
        private boolean isActive;
        
        public Category(long categoryId, String name, int displayOrder, boolean isActive) {
            this.categoryId = categoryId;
            this.name = name;
            this.displayOrder = displayOrder;
            this.isActive = isActive;
        }
        
        public long getCategoryId() { return categoryId; }
        public String getName() { return name; }
        public int getDisplayOrder() { return displayOrder; }
        public boolean isActive() { return isActive; }
    }
    
    public List<Category> getAllActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, name, display_order, is_active " +
                     "FROM categories WHERE is_active = TRUE " +
                     "ORDER BY display_order ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categories.add(new Category(
                    rs.getLong("category_id"),
                    rs.getString("name"),
                    rs.getInt("display_order"),
                    rs.getBoolean("is_active")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
}
