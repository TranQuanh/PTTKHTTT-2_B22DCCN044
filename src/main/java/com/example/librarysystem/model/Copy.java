package com.example.librarysystem.model;

public class Copy {

    private String id;
    private String barCode;
    private String condition;
    private String location;
    private Document document;
    private String status;

    public Copy() {
    }

    public Copy(String id, String barCode, String condition, String location, Document document, String status) {
        this.id = id;
        this.barCode = barCode;
        this.condition = condition;
        this.location = location;
        this.document = document;
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getBarCode() {
        return barCode;
    }

    public void setBarCode(String barCode) {
        this.barCode = barCode;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Document getDocument() {
        return document;
    }

    public void setDocument(Document document) {
        this.document = document;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
