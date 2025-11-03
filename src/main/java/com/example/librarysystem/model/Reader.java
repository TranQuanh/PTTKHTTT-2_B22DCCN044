package com.example.librarysystem.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Reader extends Member {
    private String readerId;
    private LocalDate validFrom;
    private LocalDate validTo;
    private String status;
    private String qrCode;

    public Reader() {
        super();
    }

    public Reader(String id, String username, String password, String address, LocalDate date,
                  String email, String phoneNumber, String role, String note, String fullName,
                  String readerId,
                  LocalDate validFrom, LocalDate validTo, String status, String qrCode) {
        super(id, username, password, address, date, email, phoneNumber,  role,  note, fullName);
        this.readerId = readerId;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.status = status;
        this.qrCode = qrCode;
    }

    public String getReaderId() {
        return readerId;
    }

    public void setReaderId(String readerId) {
        this.readerId = readerId;
    }

    public LocalDate getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(LocalDate validFrom) {
        this.validFrom = validFrom;
    }

    public LocalDate getValidTo() {
        return validTo;
    }

    public void setValidTo(LocalDate validTo) {
        this.validTo = validTo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getQrCode() {
        return qrCode;
    }

    public void setQrCode(String qrCode) {
        this.qrCode = qrCode;
    }
}
