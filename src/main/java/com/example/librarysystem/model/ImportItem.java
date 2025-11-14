package com.example.librarysystem.model;

public class ImportItem {

    private String id;
    private Copy copy;
    private float amount;

    public ImportItem() {
    }

    public ImportItem(String id, Copy copy, float amount) {
        this.id = id;
        this.copy = copy;
        this.amount = amount;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Copy getCopy() {
        return copy;
    }

    public void setCopy(Copy copy) {
        this.copy = copy;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }
}
