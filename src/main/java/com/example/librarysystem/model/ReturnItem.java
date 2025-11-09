package com.example.librarysystem.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class ReturnItem {

    private String id;
    private LocalDateTime returnDate;
    private LoanItem loanItem;

    private List<FineDetail> fineDetails = new ArrayList<>();

    public ReturnItem() {
    }

    public ReturnItem(String id, LocalDateTime returnDate,
                       LoanItem loanItem) {
        this.id = id;
        this.returnDate = returnDate;
        this.loanItem = loanItem;
    }
    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LocalDateTime getReturnDate() {
        return returnDate;
    }
    public String getFormattedReturnDate() {
        if (this.returnDate == null) return "";
        return this.returnDate.format(FORMATTER);
    }
    public void setReturnDate(LocalDateTime returnDate) {
        this.returnDate = returnDate;
    }



    public LoanItem getLoanItem() {
        return loanItem;
    }

    public void setLoanItem(LoanItem loanItem) {
        this.loanItem = loanItem;
    }

    public List<FineDetail> getFineDetails() {
        return fineDetails;
    }

    public void setFineDetails(List<FineDetail> fineDetails) {
        this.fineDetails = fineDetails;
    }

    // helper
    public void addFineDetail(FineDetail detail) {
        if (!fineDetails.contains(detail)) {
            fineDetails.add(detail);
        }
    }
}
