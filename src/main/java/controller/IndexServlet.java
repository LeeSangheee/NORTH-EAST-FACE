package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.ProductDAO;

@WebServlet(value = {"/", "/index"}, name = "IndexServlet")
public class IndexServlet extends HttpServlet {
    
    private ProductDAO productDAO = new ProductDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get latest 8 products for NEW Arrivals section
        List<ProductDAO.Product> newArrivals = productDAO.getLatestProducts(8);
        request.setAttribute("newArrivals", newArrivals);
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}
