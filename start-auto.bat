@echo off
echo Starting Kafka Order System (Auto Mode)...

echo.
echo 1. Starting Kafka and Zookeeper...
docker-compose up -d

echo.
echo Waiting for Kafka to start...
timeout /t 30 /nobreak > nul

echo.
echo 2. Detecting build tools...

REM Проверяем наличие Gradle
if exist "gradlew-improved.bat" (
    echo Found improved Gradle Wrapper - using Gradle for build...
    call gradlew-improved.bat clean build
    
    echo.
    echo 3. Starting order-status-service with Gradle...
    start "Order Status Service" cmd /k "cd order-status-service && ..\gradlew-improved.bat bootRun"
    
    echo.
    echo 4. Waiting for order-status-service to start...
    timeout /t 15 /nobreak > nul
    
    echo.
    echo 5. Starting order-service with Gradle...
    start "Order Service" cmd /k "cd order-service && ..\gradlew-improved.bat bootRun"
    
    set BUILD_TOOL=GRADLE
) else if exist "gradlew.bat" (
    echo Found Gradle Wrapper - using Gradle for build...
    call gradlew.bat clean build
    
    echo.
    echo 3. Starting order-status-service with Gradle...
    start "Order Status Service" cmd /k "cd order-status-service && ..\gradlew.bat bootRun"
    
    echo.
    echo 4. Waiting for order-status-service to start...
    timeout /t 15 /nobreak > nul
    
    echo.
    echo 5. Starting order-service with Gradle...
    start "Order Service" cmd /k "cd order-service && ..\gradlew.bat bootRun"
    
    set BUILD_TOOL=GRADLE
) else if exist "mvnw-improved.cmd" (
    echo Found improved Maven Wrapper - using Maven for build...
    call mvnw-improved.cmd clean install
    
    echo.
    echo 3. Starting order-status-service with Maven...
    start "Order Status Service" cmd /k "cd order-status-service && ..\mvnw-improved.cmd spring-boot:run"
    
    echo.
    echo 4. Waiting for order-status-service to start...
    timeout /t 15 /nobreak > nul
    
    echo.
    echo 5. Starting order-service with Maven...
    start "Order Service" cmd /k "cd order-service && ..\mvnw-improved.cmd spring-boot:run"
    
    set BUILD_TOOL=MAVEN
) else if exist "mvnw.cmd" (
    echo Found Maven Wrapper - using Maven for build...
    call mvnw.cmd clean install
    
    echo.
    echo 3. Starting order-status-service with Maven...
    start "Order Status Service" cmd /k "cd order-status-service && ..\mvnw.cmd spring-boot:run"
    
    echo.
    echo 4. Waiting for order-status-service to start...
    timeout /t 15 /nobreak > nul
    
    echo.
    echo 5. Starting order-service with Maven...
    start "Order Service" cmd /k "cd order-service && ..\mvnw.cmd spring-boot:run"
    
    set BUILD_TOOL=MAVEN
) else (
    echo No build tools found. Trying to run existing JAR files...
    
    echo.
    echo 3. Starting order-status-service...
    start "Order Status Service" cmd /k "cd order-status-service && java -jar target\order-status-service-1.0.0.jar"
    
    echo.
    echo 4. Waiting for order-status-service to start...
    timeout /t 15 /nobreak > nul
    
    echo.
    echo 5. Starting order-service...
    start "Order Service" cmd /k "cd order-service && java -jar target\order-service-1.0.0.jar"
    
    set BUILD_TOOL=JAR
)

echo.
echo System is starting up!
echo.
echo Build tool used: %BUILD_TOOL%
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
