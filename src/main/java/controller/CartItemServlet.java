package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CartDAO;
import util.JwtUtil;

@WebServlet("/api/cart/*")
public class CartItemServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        
        Long memberId = getLoggedInMemberId(request);
        if (memberId == null) {
            sendError(response, 401, "로그인이 필요합니다.");
            return;
        }
        
        CartDAO dao = new CartDAO();
        try {
            List<Map<String, Object>> items = dao.getCartItems(memberId);
            String json = listToJson(items);
            
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
        } catch (SQLException e) {
            sendError(response, 500, "DB 오류: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        Long memberId = getLoggedInMemberId(request);
        if (memberId == null) {
            sendError(response, 401, "로그인이 필요합니다.");
            return;
        }
        
        String action = request.getParameter("action");
        CartDAO dao = new CartDAO();
        
        try {
            if ("add".equals(action)) {
                long productId = Long.parseLong(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                dao.addOrUpdateCartItem(memberId, productId, quantity);
                sendSuccess(response, "아이템이 추가되었습니다.");
                
            } else if ("update".equals(action)) {
                long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                dao.updateCartItemQuantity(memberId, cartItemId, quantity);
                sendSuccess(response, "수량이 변경되었습니다.");
                
            } else if ("delete".equals(action)) {
                long cartItemId = Long.parseLong(request.getParameter("cartItemId"));
                dao.deleteCartItem(memberId, cartItemId);
                sendSuccess(response, "아이템이 삭제되었습니다.");
                
            } else if ("migrate".equals(action)) {
                String jsonStr = request.getParameter("items");
                if (jsonStr == null || jsonStr.isEmpty()) {
                    sendError(response, 400, "마이그레이션할 항목이 없습니다.");
                    return;
                }
                List<Map<String, Object>> items = jsonToList(jsonStr);
                if (items == null || items.isEmpty()) {
                    sendError(response, 400, "장바구니 항목을 인식하지 못했습니다.");
                    return;
                }
                dao.addBulkCartItems(memberId, items);
                sendSuccess(response, "장바구니가 동기화되었습니다.");
                
            } else if ("clear".equals(action)) {
                dao.clearCart(memberId);
                sendSuccess(response, "장바구니가 비워졌습니다.");
                
            } else {
                sendError(response, 400, "알 수 없는 액션입니다.");
            }
        } catch (NumberFormatException e) {
            sendError(response, 400, "잘못된 파라미터: " + e.getMessage());
        } catch (SQLException e) {
            sendError(response, 500, "DB 오류: " + e.getMessage());
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        
        Long memberId = getLoggedInMemberId(request);
        if (memberId == null) {
            sendError(response, 401, "로그인이 필요합니다.");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            sendError(response, 400, "cartItemId가 필요합니다.");
            return;
        }
        
        try {
            long cartItemId = Long.parseLong(pathInfo.substring(1));
            CartDAO dao = new CartDAO();
            dao.deleteCartItem(memberId, cartItemId);
            sendSuccess(response, "아이템이 삭제되었습니다.");
        } catch (NumberFormatException e) {
            sendError(response, 400, "잘못된 cartItemId입니다.");
        } catch (SQLException e) {
            sendError(response, 500, "DB 오류: " + e.getMessage());
        }
    }
    
    private Long getLoggedInMemberId(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("jwtToken".equals(cookie.getName())) {
                    String token = cookie.getValue();
                    if (JwtUtil.isValidToken(token)) {
                        return JwtUtil.validateAndGetMemberId(token);
                    }
                }
            }
        }
        return null;
    }
    
    private String listToJson(List<Map<String, Object>> items) {
        StringBuilder sb = new StringBuilder("{\"items\":[");
        for (int i = 0; i < items.size(); i++) {
            if (i > 0) sb.append(",");
            Map<String, Object> item = items.get(i);
            sb.append("{");
            sb.append("\"cartItemId\":").append(item.get("cartItemId")).append(",");
            sb.append("\"productId\":").append(item.get("productId")).append(",");
            sb.append("\"quantity\":").append(item.get("quantity")).append(",");
            sb.append("\"productName\":\"").append(escapeJson(String.valueOf(item.get("productName")))).append("\",");
            sb.append("\"price\":").append(item.get("price")).append(",");
            sb.append("\"imageFileName\":\"").append(escapeJson(String.valueOf(item.get("imageFileName")))).append("\"");
            sb.append("}");
        }
        sb.append("]}");
        return sb.toString();
    }
    
    private List<Map<String, Object>> jsonToList(String json) {
        List<Map<String, Object>> items = new ArrayList<>();
        if (json == null || json.isEmpty() || !json.startsWith("[")) {
            return items;
        }
        
        String content = json.replaceAll("\\[|\\]", "");
        String[] objects = content.split("\\},\\{");
        
        for (String obj : objects) {
            Map<String, Object> item = new HashMap<>();
            obj = obj.replaceAll("^\\{|\\}$", "");
            
            // Accept either productId:123 or id:"123"
            Pattern p = Pattern.compile("\"productId\":(\\d+)");
            Matcher m = p.matcher(obj);
            if (m.find()) {
                item.put("productId", Long.parseLong(m.group(1)));
            } else {
                p = Pattern.compile("\"id\":\"?(\\d+)\"?");
                m = p.matcher(obj);
                if (m.find()) {
                    item.put("productId", Long.parseLong(m.group(1)));
                }
            }
            
            p = Pattern.compile("\"qty\":(\\d+)");
            m = p.matcher(obj);
            if (m.find()) {
                item.put("qty", Integer.parseInt(m.group(1)));
            }
            
            if (!item.isEmpty()) {
                items.add(item);
            }
        }
        return items;
    }
    
    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
    
    private void sendSuccess(HttpServletResponse response, String message) throws IOException {
        response.setStatus(200);
        String json = "{\"success\":true,\"message\":\"" + escapeJson(message) + "\"}";
        
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
    
    private void sendError(HttpServletResponse response, int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        String json = "{\"success\":false,\"message\":\"" + escapeJson(message) + "\"}";
        
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
}
