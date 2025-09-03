package com.example.events;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Order {
    @JsonProperty("product")
    private String product;
    
    @JsonProperty("quantity")
    private Integer quantity;

    // Конструкторы
    public Order() {}

    public Order(String product, Integer quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    // Геттеры и сеттеры
    public String getProduct() {
        return product;
    }

    public void setProduct(String product) {
        this.product = product;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "Order{" +
                "product='" + product + '\'' +
                ", quantity=" + quantity +
                '}';
    }
}
