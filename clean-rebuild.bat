@echo off
echo Cleaning and rebuilding Kafka Order System...

echo.
echo 1. Stopping any running services...
taskkill /f /im java.exe > nul 2>&1
docker-compose down > nul 2>&1

echo.
echo 2. Cleaning previous builds...

REM Очищаем Maven
if exist "mvnw-improved.cmd" (
    echo Cleaning with Maven...
    call mvnw-improved.cmd clean
) else if exist "mvnw.cmd" (
    echo Cleaning with Maven...
    call mvnw.cmd clean
)

REM Очищаем Gradle
if exist "gradlew-improved.bat" (
    echo Cleaning with Gradle...
    call gradlew-improved.bat clean
) else if exist "gradlew.bat" (
    echo Cleaning with Gradle...
    call gradlew.bat clean
)

echo.
echo 3. Rebuilding project...

REM Собираем с Gradle (приоритет)
if exist "gradlew-improved.bat" (
    echo Building with improved Gradle...
    call gradlew-improved.bat clean build
    if %ERRORLEVEL% EQU 0 (
        echo Gradle build successful!
        set BUILD_TOOL=GRADLE
    ) else (
        echo Gradle build failed, trying Maven...
        if exist "mvnw-improved.cmd" (
            call mvnw-improved.cmd clean install
            if %ERRORLEVEL% EQU 0 (
                echo Maven build successful!
                set BUILD_TOOL=MAVEN
            ) else (
                echo Both build tools failed!
                pause
                exit /b 1
            )
        ) else (
            echo Maven not available!
            pause
            exit /b 1
        )
    )
) else if exist "gradlew.bat" (
    echo Building with Gradle...
    call gradlew.bat clean build
    if %ERRORLEVEL% EQU 0 (
        echo Gradle build successful!
        set BUILD_TOOL=GRADLE
    ) else (
        echo Gradle build failed, trying Maven...
        if exist "mvnw-improved.cmd" (
            call mvnw-improved.cmd clean install
            if %ERRORLEVEL% EQU 0 (
                echo Maven build successful!
                set BUILD_TOOL=MAVEN
            ) else (
                echo Both build tools failed!
                pause
                exit /b 1
            )
        ) else (
            echo Maven not available!
            pause
            exit /b 1
        )
    )
) else if exist "mvnw-improved.cmd" (
    echo Building with improved Maven...
    call mvnw-improved.cmd clean install
    if %ERRORLEVEL% EQU 0 (
        echo Maven build successful!
        set BUILD_TOOL=MAVEN
    ) else (
        echo Maven build failed!
        pause
        exit /b 1
    )
) else if exist "mvnw.cmd" (
    echo Building with Maven...
    call mvnw.cmd clean install
    if %ERRORLEVEL% EQU 0 (
        echo Maven build successful!
        set BUILD_TOOL=MAVEN
    ) else (
        echo Maven build failed!
        pause
        exit /b 1
    )
) else (
    echo No build tools found!
    pause
    exit /b 1
)

echo.
echo 4. Build completed successfully!
echo Build tool used: %BUILD_TOOL%
echo.
echo Now you can run the system with:
echo   start-auto.bat
echo   start-gradle.bat
echo   start.bat
echo.
echo Or test individual services:
echo   gradlew-improved.bat :order-status-service:bootRun
echo   gradlew-improved.bat :order-service:bootRun
echo.
pause
