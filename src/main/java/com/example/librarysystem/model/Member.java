package com.example.librarysystem.model;

import java.time.LocalDate;

public class Member {

    private String memberId;
    private String username;
    private String password;
    private String address;
    private LocalDate dateOfBirth;
    private String email;
    private String phoneNumber;
    private String role;
    private String note;
    private String fullName;

    public Member() {
    }

    public Member(String memberId, String username, String password, String address, LocalDate dateOfBirth,
                  String email, String phoneNumber, String role, String note, String fullName) {
        this.memberId = memberId;
        this.username = username;
        this.password = password;
        this.address = address;
        this.dateOfBirth = dateOfBirth;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.role = role;
        this.note = note;
        this.fullName = fullName;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String id) {
        this.memberId = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
}
