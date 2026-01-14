package controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MemberDAO;
import dao.ProductDAO;
import model.Member;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Object memberIdAttr = request.getAttribute("memberId");
        if (memberIdAttr == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        long memberId = (memberIdAttr instanceof Number)
                ? ((Number) memberIdAttr).longValue()
                : Long.parseLong(String.valueOf(memberIdAttr));

        try {
            MemberDAO memberDAO = new MemberDAO();
            Member member = memberDAO.findById(memberId);
            if (member != null) {
                request.setAttribute("member", member);
            }
        } catch (Exception e) {
            // ignore and proceed with empty fields
        }

        // 바로구매 상품 정보 처리
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        
        if (productIdParam != null && !productIdParam.isEmpty()) {
            try {
                long productId = Long.parseLong(productIdParam);
                int quantity = 1;
                if (quantityParam != null && !quantityParam.isEmpty()) {
                    quantity = Integer.parseInt(quantityParam);
                }
                
                ProductDAO productDAO = new ProductDAO();
                ProductDAO.Product product = productDAO.getProductById(productId);
                
                if (product != null) {
                    Map<String, Object> directItem = new HashMap<>();
                    directItem.put("productId", product.getProductId());
                    directItem.put("productName", product.getName());
                    directItem.put("quantity", quantity);
                    directItem.put("price", product.getPrice());
                    directItem.put("imageFileName", product.getImageFileName());
                    request.setAttribute("directItem", directItem);
                }
            } catch (Exception e) {
                // ignore and process as cart checkout
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }
}
