package com.example.events;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.time.Instant;

public class OrderStatusEvent {
    @JsonProperty("status")
    private String status;
    
    @JsonProperty("date")
    @JsonFormat(shape = JsonFormat.Shape.STRING)
    private Instant date;

    // Конструкторы
    public OrderStatusEvent() {}

    public OrderStatusEvent(String status, Instant date) {
        this.status = status;
        this.date = date;
    }

    // Геттеры и сеттеры
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Instant getDate() {
        return date;
    }

    public void setDate(Instant date) {
        this.date = date;
    }

    @Override
    public String toString() {
        return "OrderStatusEvent{" +
                "status='" + status + '\'' +
                ", date=" + date +
                '}';
    }
}
