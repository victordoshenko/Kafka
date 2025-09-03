@echo off
setlocal

REM Проверяем наличие Java
if "%JAVA_HOME%" == "" (
    echo Error: JAVA_HOME not found in your environment.
    echo Please set the JAVA_HOME variable to match your Java installation.
    pause
    exit /b 1
)

if not exist "%JAVA_HOME%\bin\java.exe" (
    echo Error: JAVA_HOME is set to an invalid directory.
    echo JAVA_HOME = "%JAVA_HOME%"
    echo Please set the JAVA_HOME variable to match your Java installation.
    pause
    exit /b 1
)

REM Устанавливаем переменные Gradle
set GRADLE_OPTS=-Xmx512m

REM Путь к Gradle Wrapper JAR
set WRAPPER_JAR="%~dp0\gradle\wrapper\gradle-wrapper.jar"
set WRAPPER_LAUNCHER=org.gradle.wrapper.GradleWrapperMain

REM URL для скачивания Gradle Wrapper
set WRAPPER_URL="https://github.com/gradle/gradle/raw/v8.5.0/gradle/wrapper/gradle-wrapper.jar"

REM Если Gradle Wrapper JAR не существует, скачиваем его
if not exist %WRAPPER_JAR% (
    echo Gradle Wrapper not found, downloading...
    
    REM Создаем папку если её нет
    if not exist "%~dp0\gradle\wrapper" mkdir "%~dp0\gradle\wrapper"
    
    REM Скачиваем JAR файл
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webclient = new-object System.Net.WebClient; $webclient.DownloadFile('%WRAPPER_URL%', '%WRAPPER_JAR%')}"
    
    if not exist %WRAPPER_JAR% (
        echo Failed to download Gradle Wrapper.
        echo Trying alternative URL...
        
        REM Альтернативный URL
        set WRAPPER_URL="https://repo.maven.apache.org/maven2/org/gradle/gradle-wrapper/8.5/gradle-wrapper-8.5.jar"
        powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webclient = new-object System.Net.WebClient; $webclient.DownloadFile('%WRAPPER_URL%', '%WRAPPER_JAR%')}"
        
        if not exist %WRAPPER_JAR% (
            echo Failed to download Gradle Wrapper from alternative URL.
            pause
            exit /b 1
        )
    )
    
    echo Gradle Wrapper downloaded successfully.
)

REM Запускаем Gradle через Wrapper
"%JAVA_HOME%\bin\java.exe" ^
  %GRADLE_OPTS% ^
  -classpath %WRAPPER_JAR% ^
  %WRAPPER_LAUNCHER% %*

endlocal
