package com.example.librarysystem.model;

public class Fine {

    private String id;
    private int amount;
    private String type;
    private String reason;

    public Fine() {
    }

    public Fine(String id, int amount, String type, String reason) {
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

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
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
