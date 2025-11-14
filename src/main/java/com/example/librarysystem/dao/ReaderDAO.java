package com.example.librarysystem.dao;

import com.example.librarysystem.model.Reader;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class ReaderDAO {

    private final Connection connection;
    String sql_check_username = "SELECT 1 FROM tblMember WHERE username = ? LIMIT 1";
    String sql_check_email ="SELECT 1 FROM tblMember WHERE email = ? LIMIT 1";
    public ReaderDAO(Connection connection) {
        this.connection = connection;
    }


    public Map<String, String> checkValidate(Reader reader) {
        Map<String, String> errors = new HashMap<>();

        // Check username
        try (PreparedStatement stmt = connection.prepareStatement(sql_check_username)) {

            stmt.setString(1, reader.getUsername());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    errors.put("username", "Username này đã tồn tại");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errors.put("database", "Lỗi truy vấn username");
        }

        // Check email
        try (PreparedStatement stmt = connection.prepareStatement(sql_check_email)) {

            stmt.setString(1, reader.getEmail());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    errors.put("email", "Email này đã được dùng để đăng ký");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errors.put("database", "Lỗi truy vấn email");
        }

        return errors;
    }


    public boolean createReader(Reader reader) {
        String insertMemberSQL = "INSERT INTO tblMember(memberid, username, password, address, dateofbirth, email, phonenumber, role, note, fullname) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String insertReaderSQL = "INSERT INTO tblReader(readerid, memberid, validfrom, validto, status, qrCode) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psMember = null;
        PreparedStatement psReader = null;

        try {
            conn = this.connection;
            conn.setAutoCommit(false); // Start transaction

            // Tạo ID random
            String memberId = "MB-" + UUID.randomUUID().toString().substring(0, 8);
            String readerId = "RD-" + UUID.randomUUID().toString().substring(0, 8);

            String fullName = reader.getFullName().trim();

            // Insert Member
            psMember = conn.prepareStatement(insertMemberSQL);
            psMember.setString(1, memberId);
            psMember.setString(2, reader.getUsername());
            psMember.setString(3, reader.getPassword());
            psMember.setString(4, reader.getAddress());
            psMember.setDate(5, java.sql.Date.valueOf(reader.getDateOfBirth()));
            psMember.setString(6, reader.getEmail());
            psMember.setString(7, reader.getPhoneNumber());
            psMember.setString(8, "reader");
            psMember.setString(9, null);
            psMember.setString(10, fullName);
            psMember.executeUpdate();

            // Insert Reader
            LocalDate validFrom = LocalDate.now();
            LocalDate validTo   = validFrom.plusYears(1);
            String qrCode = UUID.randomUUID().toString();

            psReader = conn.prepareStatement(insertReaderSQL);
            psReader.setString(1, readerId);
            psReader.setString(2, memberId);
            psReader.setDate(3, java.sql.Date.valueOf(validFrom));
            psReader.setDate(4, java.sql.Date.valueOf(validTo));
            psReader.setString(5, "active");
            psReader.setString(6, qrCode);
            psReader.executeUpdate();

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ignored) {}
            }
            return false;
        } finally {
            try {
                if (psMember != null) psMember.close();
                if (psReader != null) psReader.close();
                conn.setAutoCommit(true);
            } catch (Exception ignored) {}
        }
    }
    public Reader findReaderById(String readerId) {
        String sql = "SELECT r.readerid, m.fullname, r.status " +
                "FROM tblReader r JOIN tblMember m ON r.memberid = m.memberid " +
                "WHERE r.readerid = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, readerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Reader reader = new Reader();
                    reader.setReaderId(rs.getString("readerid"));
                    reader.setFullName(rs.getString("fullname"));
                    reader.setStatus(rs.getString("status"));
                    return reader;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

