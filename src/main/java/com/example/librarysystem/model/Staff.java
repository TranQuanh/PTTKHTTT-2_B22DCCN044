package com.example.librarysystem.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Staff extends Member {
    private String staffId;
    private Integer salary;
    private String staffRole;
    private LocalDate hireDate;

    public Staff() {
        super();
    }

    public Staff(String id, String username, String password, String address, LocalDate date,
                 String email, String phoneNumber, String role, String note, String fullName,
                 String staffId,
                 Integer salary, String staffRole, LocalDate hireDate) {
        super(id, username, password, address, date, email, phoneNumber, role, note, fullName);
        this.salary = salary;
        this.staffRole = staffRole;
        this.hireDate = hireDate;
    }

    public String getStaffId() {
        return staffId;
    }

    public void setStaffId(String staffId) {
        this.staffId = staffId;
    }

    public Integer getSalary() {
        return salary;
    }

    public void setSalary(Integer salary) {
        this.salary = salary;
    }

    public String getStaffRole() {
        return staffRole;
    }

    public void setStaffRole(String staffRole) {
        this.staffRole = staffRole;
    }

    public LocalDate getHireDate() {
        return hireDate;
    }

    public void setHireDate(LocalDate hireDate) {
        this.hireDate = hireDate;
    }
}
