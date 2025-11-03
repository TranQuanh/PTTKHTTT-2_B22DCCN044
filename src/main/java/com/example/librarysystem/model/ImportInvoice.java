package com.example.librarysystem.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ImportInvoice {

    private String id;
    private LocalDateTime importDate;
    private String status;

    private Staff staff;
    private Supplier supplier;

    // OneToMany
    private List<ImportItem> importItems = new ArrayList<>();

    public ImportInvoice() {
    }

    public ImportInvoice(String id, LocalDateTime importDate, String status, Staff staff, Supplier supplier) {
        this.id = id;
        this.importDate = importDate;
        this.status = status;
        this.staff = staff;
        this.supplier = supplier;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public LocalDateTime getImportDate() {
        return importDate;
    }

    public void setImportDate(LocalDateTime importDate) {
        this.importDate = importDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Staff getStaff() {
        return staff;
    }

    public void setStaff(Staff staff) {
        this.staff = staff;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }

    public List<ImportItem> getImportItems() {
        return importItems;
    }

    public void setImportItems(List<ImportItem> importItems) {
        this.importItems = importItems;
    }

    // helper method
    public void addImportItem(ImportItem item) {
        if(!importItems.contains(item)) {
            importItems.add(item);
        }
    }
}
