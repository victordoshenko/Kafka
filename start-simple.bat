@echo off
echo Starting Kafka Order System (Simple Mode)...

echo.
echo 1. Starting Kafka and Zookeeper...
docker-compose up -d

echo.
echo Waiting for Kafka to start...
timeout /t 30 /nobreak > nul

echo.
echo 2. Starting order-status-service...
start "Order Status Service" cmd /k "cd order-status-service && java -jar target\order-status-service-1.0.0.jar"

echo.
echo 3. Waiting for order-status-service to start...
timeout /t 15 /nobreak > nul

echo.
echo 4. Starting order-service...
start "Order Service" cmd /k "cd order-service && java -jar target\order-service-1.0.0.jar"

echo.
echo System is starting up!
echo.
echo Services:
echo - order-service: http://localhost:8080
echo - order-status-service: running (no HTTP endpoints)
echo - Kafka UI: http://localhost:8081
echo.
echo To test the system, send a POST request to:
echo curl -X POST http://localhost:8080/api/orders -H "Content-Type: application/json" -d "{\"product\": \"Laptop\", \"quantity\": 2}"
echo.
echo Press any key to stop all services...
pause > nul

echo.
echo Stopping services...
docker-compose down
taskkill /f /im java.exe > nul 2>&1
echo All services stopped.
