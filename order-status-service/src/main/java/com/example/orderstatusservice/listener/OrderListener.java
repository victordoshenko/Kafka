package com.example.orderstatusservice.listener;

import com.example.events.OrderEvent;
import com.example.events.OrderStatusEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.util.concurrent.CompletableFuture;

@Component
public class OrderListener {
    
    private static final Logger log = LoggerFactory.getLogger(OrderListener.class);
    
    private final KafkaTemplate<String, OrderStatusEvent> kafkaTemplate;
    
    @Value("${kafka.topic.order-status-topic:order-status-topic}")
    private String orderStatusTopic;
    
    @Autowired
    public OrderListener(KafkaTemplate<String, OrderStatusEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }
    
    @KafkaListener(topics = "${kafka.topic.order-topic:order-topic}")
    public void handleOrder(OrderEvent orderEvent) {
        log.info("Received order event: {}", orderEvent);
        
        // Создаем событие статуса
        String status = generateStatus();
        Instant currentDate = Instant.now();
        
        OrderStatusEvent statusEvent = new OrderStatusEvent(status, currentDate);
        
        // Отправляем событие статуса в Kafka
        String key = orderEvent.getProduct() + "-status-" + System.currentTimeMillis();
        
        CompletableFuture<SendResult<String, OrderStatusEvent>> future = kafkaTemplate.send(orderStatusTopic, key, statusEvent);
        
        future.whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("Status event sent successfully to topic: {}, partition: {}, offset: {}", 
                    result.getRecordMetadata().topic(),
                    result.getRecordMetadata().partition(),
                    result.getRecordMetadata().offset());
            } else {
                log.error("Failed to send status event: {}", ex.getMessage(), ex);
            }
        });
    }
    
    private String generateStatus() {
        // Генерируем произвольный статус
        String[] statuses = {"CREATED", "PROCESSING", "CONFIRMED", "SHIPPED", "DELIVERED"};
        int randomIndex = (int) (Math.random() * statuses.length);
        return statuses[randomIndex];
    }
}
