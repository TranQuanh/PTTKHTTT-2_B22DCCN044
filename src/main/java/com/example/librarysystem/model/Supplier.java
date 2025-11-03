package com.example.librarysystem.model;

public class Supplier {

    private String id;
    private String name;
    private String taxCode;
    private String email;
    private String phone;
    private String address;

    public Supplier() {
    }

    public Supplier(String id, String name, String taxCode, String email, String phone, String address) {
        this.id = id;
        this.name = name;
        this.taxCode = taxCode;
        this.email = email;
        this.phone = phone;
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
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
