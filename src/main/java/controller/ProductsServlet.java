package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CategoryDAO;
import dao.ProductDAO;

@WebServlet("/products")
public class ProductsServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String categoryIdParam = request.getParameter("categoryId");
        List<ProductDAO.Product> products;
        String categoryName = null;
        
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                long categoryId = Long.parseLong(categoryIdParam);
                products = productDAO.getProductsByCategory(categoryId);
                CategoryDAO.Category category = categoryDAO.getCategoryById(categoryId);
                if (category != null) {
                    categoryName = category.getName();
                }
            } catch (NumberFormatException e) {
                products = productDAO.getAllProducts();
            }
        } else {
            products = productDAO.getAllProducts();
        }
        
        request.setAttribute("products", products);
        request.setAttribute("categoryName", categoryName);
        request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
    }
}
