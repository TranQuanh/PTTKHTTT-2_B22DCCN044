package com.example.librarysystem.model;

public class Supplier {

    private String id;
    private String name;
    private String taxCode;
    private String email;
    private String phoneNumber;
    private String address;

    public Supplier() {
    }

    public Supplier(String id, String name, String taxCode, String email, String phoneNumber, String address) {
        this.id = id;
        this.name = name;
        this.taxCode = taxCode;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.address = address;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phoneNumber;
    }

    public void setPhone(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
