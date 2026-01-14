package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.Member;
import util.DBConnection;

public class MemberDAO {

    public Member findById(long memberId) throws SQLException {
        String sql = "SELECT member_id, username, email, phone FROM members WHERE member_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, memberId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Member m = new Member();
                    m.setMemberId(rs.getLong("member_id"));
                    m.setUsername(rs.getString("username"));
                    m.setEmail(rs.getString("email"));
                    m.setPhone(rs.getString("phone"));
                    return m;
                }
            }
        }
        return null;
    }
}
