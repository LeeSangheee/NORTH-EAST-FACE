package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CategoryDAO;
import dao.ProductDAO;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }
        
        try {
            long productId = Long.parseLong(idParam);
            ProductDAO.Product product = productDAO.getProductById(productId);
            
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "상품을 찾을 수 없습니다.");
                return;
            }
            
            // Get category name if categoryId exists
            if (product.getCategoryId() != null) {
                CategoryDAO.Category category = categoryDAO.getCategoryById(product.getCategoryId());
                if (category != null) {
                    request.setAttribute("categoryName", category.getName());
                }
            }
            
            request.setAttribute("product", product);
            request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
