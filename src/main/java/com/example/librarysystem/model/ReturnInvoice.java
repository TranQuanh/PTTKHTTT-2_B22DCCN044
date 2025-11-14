package com.example.librarysystem.model;

import java.util.ArrayList;
import java.util.List;

public class ReturnInvoice {

    private String id;
    private Staff staff;
    private List<ReturnItem> returnItems = new ArrayList<>();
    private Reader reader;
    private String status;
    private float totalAmount;

    public ReturnInvoice() {
    }

    public ReturnInvoice(String id, Reader reader, Staff staff) {
        this.id = id;
        this.reader = reader;
        this.staff = staff;
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

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

    public List<ReturnItem> getReturnItems() {
        return returnItems;
    }

    public void setReturnItems(List<ReturnItem> returnItems) {
        this.returnItems = returnItems;
    }

    // helper
    public void addReturnItem(ReturnItem item) {
        if (!returnItems.contains(item)) {
            returnItems.add(item);
        }
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public float getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(float totalAmount) {
        this.totalAmount = totalAmount;
    }
}
