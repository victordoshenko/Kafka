@echo off
echo Testing Order Service API...

echo.
echo Sending test order...
curl -X POST http://localhost:8080/api/orders ^
  -H "Content-Type: application/json" ^
  -d "{\"product\": \"Laptop\", \"quantity\": 2}"

echo.
echo.
echo Sending another test order...
curl -X POST http://localhost:8080/api/orders ^
  -H "Content-Type: application/json" ^
  -d "{\"product\": \"Mouse\", \"quantity\": 5}"

echo.
echo.
echo Test completed. Check the console logs of both services.
pause
