package com.example.librarysystem.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Document {

    private String id;
    private String title;
    private String author;
    private String publisher;
    private LocalDate publishDate;
    private String type;

    public Document() {
    }

    public Document(String id, String title, String author, String publisher,
                    LocalDate publishDate, String type) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.publisher = publisher;
        this.publishDate = publishDate;
        this.type = type;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public LocalDate getPublishDate() {
        return publishDate;
    }

    public void setPublishDate(LocalDate publishDate) {
        this.publishDate = publishDate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
