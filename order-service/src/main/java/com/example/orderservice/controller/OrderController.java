package com.example.orderservice.controller;

import com.example.events.Order;
import com.example.events.OrderEvent;
import com.example.orderservice.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/orders")
public class OrderController {
    
    private static final Logger log = LoggerFactory.getLogger(OrderController.class);
    
    private final OrderService orderService;
    
    @Autowired
    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }
    
    @PostMapping
    public ResponseEntity<String> createOrder(@RequestBody Order order) {
        log.info("Received order: {}", order);
        
        try {
            orderService.processOrder(order);
            return ResponseEntity.ok("Order created successfully");
        } catch (Exception e) {
            log.error("Error processing order: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body("Error processing order: " + e.getMessage());
        }
    }
}
