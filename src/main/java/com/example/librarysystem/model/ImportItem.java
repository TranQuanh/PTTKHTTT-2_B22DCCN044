package com.example.librarysystem.model;

public class ImportItem {

    private String id;
    private Copy copy;

    public ImportItem() {
    }

    public ImportItem(String id, Copy copy) {
        this.id = id;
        this.copy = copy;

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




}
