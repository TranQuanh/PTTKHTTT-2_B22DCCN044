package com.example.librarysystem.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LoanItem {

    private String id;
    private LocalDateTime loanDate;
    private LocalDateTime dueDate;

    private Copy copy;

    public LoanItem() {
    }

    public LoanItem(String id, LocalDateTime loanDate, LocalDateTime dueDate,
                     Copy copy) {
        this.id = id;
        this.loanDate = loanDate;
        this.dueDate = dueDate;
        this.copy = copy;
    }
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LocalDateTime getLoanDate() {
        return loanDate;
    }
    public String getFormattedLoanDate() {
        if (this.loanDate == null) return "";
        return this.loanDate.format(FORMATTER);
    }
    public void setLoanDate(LocalDateTime loanDate) {
        this.loanDate = loanDate;
    }

    public LocalDateTime getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDateTime dueDate) {
        this.dueDate = dueDate;
    }


    public Copy getCopy() {
        return copy;
    }

    public void setCopy(Copy copy) {
        this.copy = copy;
    }

    public String getFormattedDueDate() {
        if (this.dueDate == null) return "";
        return this.dueDate.format(FORMATTER);
    }

}
