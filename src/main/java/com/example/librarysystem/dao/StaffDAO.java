package com.example.librarysystem.dao;
import com.example.librarysystem.model.Member;
import com.example.librarysystem.model.Staff;

import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;

public class StaffDAO {
    private final Connection connection;

    public StaffDAO(Connection connection) {
        this.connection = connection;
    }
    public Staff login(String username, String password) {
        String sql = """
            SELECT 
                m.memberid, m.username, m.password, m.address, m.dateofbirth, 
                m.email, m.phonenumber, m.role, m.note, m.fullname,
                s.staffid, s.salary, s.staffrole, s.hiredate
            FROM tblMember m
            JOIN tblStaff s ON m.memberid = s.memberid
            WHERE m.username = ? AND m.password = ? AND m.role = 'staff'
        """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Staff staff = new Staff();

                    // --- Member fields ---
                    staff.setMemberId(rs.getString("memberid"));
                    staff.setUsername(rs.getString("username"));
                    staff.setPassword(rs.getString("password"));
                    staff.setAddress(rs.getString("address"));

                    // Sửa tên cột từ "date" thành "dateofbirth"
                    Date dateOfBirth = rs.getDate("dateofbirth");
                    if (dateOfBirth != null) {
                        // Giả định Setter của Member nhận LocalDate
                        staff.setDateOfBirth(dateOfBirth.toLocalDate());
                    }

                    staff.setEmail(rs.getString("email"));
                    staff.setPhoneNumber(rs.getString("phonenumber"));
                    staff.setRole(rs.getString("role"));
                    staff.setNote(rs.getString("note"));
                    staff.setFullName(rs.getString("fullname"));

                    // --- Staff fields ---
                    staff.setStaffId(rs.getString("staffid"));
                    staff.setSalary(rs.getInt("salary"));
                    staff.setStaffRole(rs.getString("staffrole"));

                    // Cập nhật: Sử dụng rs.getDate() và toLocalDate() để khớp với mô hình Staff
                    Date hireDateSql = rs.getDate("hiredate");
                    if (hireDateSql != null) {
                        // Setter của Staff nhận LocalDate
                        staff.setHireDate(hireDateSql.toLocalDate());
                    } else {
                        // Nếu giá trị là NULL trong DB, set HireDate là null
                        staff.setHireDate(null);
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
