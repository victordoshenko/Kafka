@echo off
echo Downloading Gradle Wrapper...

REM Создаем папку если её нет
if not exist "gradle\wrapper" mkdir "gradle\wrapper"

REM URL для скачивания Gradle Wrapper
set WRAPPER_URL="https://github.com/gradle/gradle/raw/v8.5.0/gradle/wrapper/gradle-wrapper.jar"
set WRAPPER_JAR="gradle\wrapper\gradle-wrapper.jar"

echo Downloading from: %WRAPPER_URL%
echo Saving to: %WRAPPER_JAR%

REM Скачиваем JAR файл
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webclient = new-object System.Net.WebClient; $webclient.DownloadFile('%WRAPPER_URL%', '%WRAPPER_JAR%')}"

if exist %WRAPPER_JAR% (
    echo.
    echo Gradle Wrapper downloaded successfully!
    echo.
    echo Now you can use:
    echo   gradlew.bat clean build
    echo   gradlew.bat bootRun
    echo.
    echo Or run the system with:
    echo   start-gradle.bat
    echo   start-auto.bat
) else (
    echo.
    echo Failed to download Gradle Wrapper.
    echo Trying alternative URL...
    
    REM Альтернативный URL
    set WRAPPER_URL="https://repo.maven.apache.org/maven2/org/gradle/gradle-wrapper/8.5/gradle-wrapper-8.5.jar"
    echo Downloading from: %WRAPPER_URL%
    
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webclient = new-object System.Net.WebClient; $webclient.DownloadFile('%WRAPPER_URL%', '%WRAPPER_JAR%')}"
    
    if exist %WRAPPER_JAR% (
        echo.
        echo Gradle Wrapper downloaded successfully from alternative URL!
        echo.
        echo Now you can use:
        echo   gradlew.bat clean build
        echo   gradlew.bat bootRun
    ) else (
        echo.
        echo Failed to download Gradle Wrapper from both URLs.
        echo Please check your internet connection and try again.
    )
)

pause
