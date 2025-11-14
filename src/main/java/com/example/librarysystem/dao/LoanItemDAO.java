package com.example.librarysystem.dao;

import com.example.librarysystem.model.Copy;
import com.example.librarysystem.model.Document;
import com.example.librarysystem.model.LoanItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoanItemDAO {

    private Connection connection;

    public LoanItemDAO(Connection connection) {
        this.connection = connection;
    }

    /**
     * Lấy danh sách LoanItem của Reader mà chưa có trong ReturnItem
     */
    public List<LoanItem> getLoanItemsNotReturnedByReader(String readerId) {
        List<LoanItem> list = new ArrayList<>();

        String sql = """
            SELECT li.id AS loanItemId, li.loanDate, li.dueDate,
                   c.id AS copyId, c.barCode, c.condition, c.location,
                   d.id AS docId, d.title, d.author, d.publisher, d.publishDate, d.type
            FROM LoanItem li
                     JOIN Loan l ON li.Loanid = l.id
                     JOIN Reader r ON l.Readerid = r.readerId
                     JOIN Copy c ON li.Copyid = c.id
                     JOIN Document d ON c.Documentid = d.id
            WHERE r.readerId = ?
              AND li.id NOT IN (SELECT LoanItemid FROM ReturnItem)
            """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, readerId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                // Document
                Document doc = new Document(
                        rs.getString("docId"),
                        rs.getString("title"),
                        rs.getString("author"),
                        rs.getString("publisher"),
                        rs.getTimestamp("publishDate") != null
                                ? rs.getDate("publishDate").toLocalDate()
                                : null,
                        rs.getString("type")
                );

                // Copy
                Copy copy = new Copy(
                        rs.getString("copyId"),
                        rs.getString("barCode"),
                        rs.getString("condition"),
                        rs.getString("location"),
                        doc,
                        "Borrowed"
                );

                // LoanItem
                LoanItem loanItem = new LoanItem(
                        rs.getString("loanItemId"),
                        "Borrowed",
                        rs.getTimestamp("loanDate") != null
                                ? rs.getTimestamp("loanDate").toLocalDateTime()
                                : null,
                        rs.getTimestamp("dueDate") != null
                                ? rs.getTimestamp("dueDate").toLocalDateTime()
                                : null,
                        copy
                );

                list.add(loanItem);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
