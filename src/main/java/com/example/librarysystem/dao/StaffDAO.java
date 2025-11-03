package com.example.librarysystem.dao;
import com.example.librarysystem.model.Member;
import com.example.librarysystem.model.Staff;

import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class StaffDAO {
    private final Connection connection;

    public StaffDAO(Connection connection) {
        this.connection = connection;
    }
    public Staff login(String username, String password) {
        String sql = """
            SELECT 
                m.memberId, m.username, m.password, m.address, m.date, 
                m.email, m.phonenumber, m.role, m.note, m.fullName,
                s.staffId, s.salary, s.staffRole, s.hireDate
            FROM Member m
            JOIN Staff s ON m.memberId = s.memberId
            WHERE m.username = ? AND m.password = ? AND m.role = 'staff'
        """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff();

                    // --- Member fields ---
                    staff.setMemberId(rs.getString("memberId"));
                    staff.setUsername(rs.getString("username"));
                    staff.setPassword(rs.getString("password"));
                    staff.setAddress(rs.getString("address"));

                    Date date = rs.getDate("date");
                    if (date != null) {
                        staff.setDate(date.toLocalDate());
                    }

                    staff.setEmail(rs.getString("email"));
                    staff.setPhoneNumber(rs.getString("phonenumber"));
                    staff.setRole(rs.getString("role"));
                    staff.setNote(rs.getString("note"));
                    staff.setFullName(rs.getString("fullName"));

                    // --- Staff fields ---
                    staff.setStaffId(rs.getString("staffId"));
                    staff.setSalary(rs.getInt("salary"));
                    staff.setStaffRole(rs.getString("staffRole"));

                    Date hireDate = rs.getDate("hireDate");
                    if (hireDate != null) {
                        staff.setHireDate(hireDate.toLocalDate().atStartOfDay());
                    }

                    return staff;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
