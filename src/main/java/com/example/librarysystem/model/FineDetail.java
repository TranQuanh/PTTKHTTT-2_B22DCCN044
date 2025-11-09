package com.example.librarysystem.model;

public class FineDetail {

    private String id;
    private String note;
    private int quantity;
    private Fine fine;

    public FineDetail() {
    }

    public FineDetail(String id, String note, Fine fine) {
        this.id = id;
        this.note = note;
        this.fine = fine;
    }

    public String getId() {
        return id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Fine getFine() {
        return fine;
    }

    public void setFine(Fine fine) {
        this.fine = fine;
    }
}
