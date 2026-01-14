package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import util.DBConnection;

public class ProductDAO {
    
    public static class Product {
        private long productId;
        private String name;
        private double price;
        private int stockQty;
        private Long categoryId;
        private String imageFileName;
        
        public Product(long productId, String name, double price, int stockQty, 
                      Long categoryId, String imageFileName) {
            this.productId = productId;
            this.name = name;
            this.price = price;
            this.stockQty = stockQty;
            this.categoryId = categoryId;
            this.imageFileName = imageFileName;
        }
        
        public long getProductId() { return productId; }
        public String getName() { return name; }
        public double getPrice() { return price; }
        public int getStockQty() { return stockQty; }
        public Long getCategoryId() { return categoryId; }
        public String getImageFileName() { return imageFileName; }
    }
    
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT product_id, name, price, stock_qty, category_id, image_file_name " +
                     "FROM products ORDER BY product_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                products.add(new Product(
                    rs.getLong("product_id"),
                    rs.getString("name"),
                    rs.getDouble("price"),
                    rs.getInt("stock_qty"),
                    rs.getObject("category_id", Long.class),
                    rs.getString("image_file_name")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    public List<Product> getProductsByCategory(long categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT product_id, name, price, stock_qty, category_id, image_file_name " +
                     "FROM products WHERE category_id = ? ORDER BY product_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(new Product(
                        rs.getLong("product_id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("stock_qty"),
                        rs.getObject("category_id", Long.class),
                        rs.getString("image_file_name")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    public List<Product> getLatestProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT product_id, name, price, stock_qty, category_id, image_file_name " +
                     "FROM products ORDER BY created_at DESC, product_id DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(new Product(
                        rs.getLong("product_id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("stock_qty"),
                        rs.getObject("category_id", Long.class),
                        rs.getString("image_file_name")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return products;
    }
    
    public Product getProductById(long productId) {
        String sql = "SELECT product_id, name, price, stock_qty, category_id, image_file_name " +
                     "FROM products WHERE product_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, productId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Product(
                        rs.getLong("product_id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("stock_qty"),
                        rs.getObject("category_id", Long.class),
                        rs.getString("image_file_name")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}
