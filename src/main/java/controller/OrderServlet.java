package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.CartDAO;
import util.DBConnection;
import util.JwtUtil;

@WebServlet("/api/order")
public class OrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");

		try {
			// JWT 토큰에서 member_id 추출
			Long memberId = getLoggedInMemberId(request);
			if (memberId == null) {
				sendError(response, 401, "로그인이 필요합니다");
				return;
			}

			// 요청 본문에서 JSON 파싱
			BufferedReader reader = request.getReader();
			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = reader.readLine()) != null) {
				sb.append(line);
			}

			String requestBody = sb.toString();
			double totalAmount = parseJsonDouble(requestBody, "totalAmount");
			boolean directItem = parseJsonBoolean(requestBody, "directItem");
			String itemsJson = extractJsonArray(requestBody, "items");

			if (totalAmount <= 0) {
				sendError(response, 400, "주문 금액이 유효하지 않습니다");
				return;
			}

			// 주문 데이터 저장 시작
			Connection conn = DBConnection.getConnection();
			if (conn == null) {
				sendError(response, 500, "DB 연결 실패");
				return;
			}

			try {
				// orders 테이블에 삽입
				String orderSQL = "INSERT INTO orders (member_id, payment_token, paid_at, shipping_address, total_amount) VALUES (?, NULL, NOW(), ?, ?)";
				long orderId = 0;
				
				try (PreparedStatement orderStmt = conn.prepareStatement(orderSQL,
						PreparedStatement.RETURN_GENERATED_KEYS)) {
					orderStmt.setLong(1, memberId);
					orderStmt.setString(2, "배송 예정");
					orderStmt.setDouble(3, totalAmount);

					int affectedRows = orderStmt.executeUpdate();
					if (affectedRows == 0) {
						sendError(response, 500, "주문 생성 실패");
						return;
					}

					// 생성된 order_id 가져오기
					try (ResultSet generatedKeys = orderStmt.getGeneratedKeys()) {
						if (generatedKeys.next()) {
							orderId = generatedKeys.getLong(1);
						}
					}
				}

				if (orderId == 0) {
					sendError(response, 500, "주문 ID 조회 실패");
					return;
				}

				// order_items 테이블에 삽입
				insertOrderItems(conn, orderId, itemsJson);

				// 직접 구매가 아니면 장바구니 비우기
				if (!directItem) {
					CartDAO cartDAO = new CartDAO();
					cartDAO.clearCart(memberId);
				}

				sendSuccess(response, "주문이 완료되었습니다", orderId);

			} finally {
				if (conn != null) {
					conn.close();
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			sendError(response, 500, "서버 오류: " + e.getMessage());
		}
	}

	private void insertOrderItems(Connection conn, long orderId, String itemsJson) throws Exception {
		String orderItemSQL = "INSERT INTO order_items (order_id, product_id, quantity) VALUES (?, ?, ?)";

		// itemsJson에서 각 항목 추출
		// Format: [{"productId":1,"quantity":2,"price":50000}, ...]
		if (itemsJson == null || itemsJson.trim().equals("[]")) {
			return;
		}

		// [ { ... }, { ... } ] 형식에서 각 항목 추출
		itemsJson = itemsJson.replaceAll("[\\[\\]]", "").trim();
		if (itemsJson.isEmpty()) {
			return;
		}

		// }, { 로 분리하여 각 JSON 객체 파싱
		String[] items = itemsJson.split("\\},\\s*\\{");

		for (String item : items) {
			item = item.replaceAll("^[\\s{]*|[\\s}]*$", "");
			if (item.isEmpty()) {
				continue;
			}

			long productId = parseItemLong(item, "productId");
			int quantity = parseItemInt(item, "quantity");

			if (productId > 0 && quantity > 0) {
				try (PreparedStatement itemStmt = conn.prepareStatement(orderItemSQL)) {
					itemStmt.setLong(1, orderId);
					itemStmt.setLong(2, productId);
					itemStmt.setInt(3, quantity);
					itemStmt.executeUpdate();
				}
			}
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

	private double parseJsonDouble(String json, String key) {
		try {
			String pattern = "\"" + key + "\":(\\d+\\.?\\d*)";
			java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
			java.util.regex.Matcher m = p.matcher(json);
			if (m.find()) {
				return Double.parseDouble(m.group(1));
			}
		} catch (Exception e) {
			// ignore
		}
		return 0;
	}

	private boolean parseJsonBoolean(String json, String key) {
		try {
			String pattern = "\"" + key + "\":(true|false)";
			java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
			java.util.regex.Matcher m = p.matcher(json);
			if (m.find()) {
				return Boolean.parseBoolean(m.group(1));
			}
		} catch (Exception e) {
			// ignore
		}
		return false;
	}

	private String extractJsonArray(String json, String key) {
		try {
			// "items":[...] 형태에서 배열 추출
			String pattern = "\"" + key + "\":\\s*(\\[[^\\]]*(?:\\{[^}]*\\}[^\\]]*)*\\])";
			java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
			java.util.regex.Matcher m = p.matcher(json);
			if (m.find()) {
				return m.group(1);
			}
		} catch (Exception e) {
			// ignore
		}
		return "[]";
	}

	private long parseItemLong(String item, String key) {
		try {
			String pattern = "\"" + key + "\":(\\d+)";
			java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
			java.util.regex.Matcher m = p.matcher(item);
			if (m.find()) {
				return Long.parseLong(m.group(1));
			}
		} catch (Exception e) {
			// ignore
		}
		return 0;
	}

	private int parseItemInt(String item, String key) {
		try {
			String pattern = "\"" + key + "\":(\\d+)";
			java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
			java.util.regex.Matcher m = p.matcher(item);
			if (m.find()) {
				return Integer.parseInt(m.group(1));
			}
		} catch (Exception e) {
			// ignore
		}
		return 0;
	}

	private double parseItemDouble(String item, String key) {
		try {
			String pattern = "\"" + key + "\":(\\d+\\.?\\d*)";
			java.util.regex.Pattern p = java.util.regex.Pattern.compile(pattern);
			java.util.regex.Matcher m = p.matcher(item);
			if (m.find()) {
				return Double.parseDouble(m.group(1));
			}
		} catch (Exception e) {
			// ignore
		}
		return 0;
	}

	private void sendSuccess(HttpServletResponse response, String message, long orderId) throws IOException {
		response.setStatus(200);
		String json = "{\"success\":true,\"message\":\"" + escapeJson(message) + "\",\"orderId\":" + orderId + "}";
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

	private String escapeJson(String value) {
		if (value == null)
			return "";
		return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r")
				.replace("\t", "\\t");
	}
}
