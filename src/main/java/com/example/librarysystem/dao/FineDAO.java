package com.example.librarysystem.dao;

import com.example.librarysystem.model.Fine;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FineDAO {
    private final Connection connection;

    public FineDAO(Connection connection) {
        this.connection = connection;
    }

    // Lấy duy nhất bản ghi Fine có type = 'late'
    public Fine getLateFine() {
        String sql = "SELECT id, amount, type, reason FROM tblFine WHERE type = 'late' LIMIT 1";

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                Fine fine = new Fine();
                fine.setId(rs.getString("id"));
                fine.setAmount(rs.getFloat("amount"));
                fine.setReason(rs.getString("reason"));
                fine.setType(rs.getString("type"));
                return fine;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Fine> getListDamageFine() {
        List<Fine> damageFines = new ArrayList<>();
        String sql = "SELECT id, amount, type, reason FROM tblFine WHERE type = 'damage'";

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Fine fine = new Fine();
                fine.setId(rs.getString("id"));
                fine.setAmount(rs.getFloat("amount"));
                fine.setReason(rs.getString("reason"));
                fine.setType(rs.getString("type"));
                damageFines.add(fine);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return damageFines;
    }
}
