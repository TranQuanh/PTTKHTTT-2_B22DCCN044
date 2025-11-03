package com.example.librarysystem.model;

import java.time.LocalDateTime;

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

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LocalDateTime getLoanDate() {
        return loanDate;
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

}
