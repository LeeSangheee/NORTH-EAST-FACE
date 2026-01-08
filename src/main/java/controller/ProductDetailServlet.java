package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String id = request.getParameter("id");
        
        // TODO: 상품 정보 DB 조회 로직 추가
        request.setAttribute("productId", id);
        
        request.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(request, response);
    }
}
