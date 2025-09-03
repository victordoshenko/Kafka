package com.example.orderservice.service;

import com.example.events.Order;
import com.example.events.OrderEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class OrderService {
    
    private static final Logger log = LoggerFactory.getLogger(OrderService.class);
    
    private final KafkaTemplate<String, OrderEvent> kafkaTemplate;
    
    @Value("${kafka.topic.order-topic:order-topic}")
    private String orderTopic;
    
    @Autowired
    public OrderService(KafkaTemplate<String, OrderEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }
    
    public void processOrder(Order order) {
        log.info("Processing order: {}", order);
        
        // Создаем событие OrderEvent
        OrderEvent orderEvent = new OrderEvent(order.getProduct(), order.getQuantity());
        
        // Отправляем событие в Kafka
        String key = order.getProduct() + "-" + System.currentTimeMillis();
        
        CompletableFuture<SendResult<String, OrderEvent>> future = kafkaTemplate.send(orderTopic, key, orderEvent);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("Order event sent successfully to topic: {}, partition: {}, offset: {}", 
                    result.getRecordMetadata().topic(),
                    result.getRecordMetadata().partition(),
                    result.getRecordMetadata().offset());
            } else {
                log.error("Failed to send order event: {}", ex.getMessage(), ex);
            }
        });
    }
}
