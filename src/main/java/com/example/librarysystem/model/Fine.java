package com.example.librarysystem.model;

public class Fine {

    private String id;
    private double amount;
    private String type;
    private String reason;

    public Fine() {
    }

    public Fine(String id, double amount, String type, String reason) {
        this.id = id;
        this.amount = amount;
        this.type = type;
        this.reason = reason;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
