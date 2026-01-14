package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MemberDAO;
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

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }
}
