package com.example.librarysystem.model;

import java.util.ArrayList;
import java.util.List;

public class Loan {

    private String id;
    private Reader reader;

    private List<LoanItem> loanItems = new ArrayList<>();

    public Loan() {
    }

    public Loan(String id, Reader reader) {
        this.id = id;
        this.reader = reader;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Reader getReader() {
        return reader;
    }

    public void setReader(Reader reader) {
        this.reader = reader;
    }

    public List<LoanItem> getLoanItems() {
        return loanItems;
    }

    public void setLoanItems(List<LoanItem> loanItems) {
        this.loanItems = loanItems;
    }

    // helper
    public void addLoanItem(LoanItem item) {
        if (!loanItems.contains(item)) {
            loanItems.add(item);
        }
    }
}
