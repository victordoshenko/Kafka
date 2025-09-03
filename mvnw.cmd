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

REM Устанавливаем переменные Maven
set MAVEN_OPTS=-Xmx512m
set MAVEN_LOCAL_REPO=%USERPROFILE%\.m2\repository

REM Путь к Maven Wrapper JAR
set WRAPPER_JAR="%~dp0\.mvn\wrapper\maven-wrapper.jar"
set WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain

REM URL для скачивания Maven Wrapper
set WRAPPER_URL="https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar"

REM Если Maven Wrapper JAR не существует, скачиваем его
if not exist %WRAPPER_JAR% (
    echo Maven Wrapper not found, downloading...
    
    REM Создаем папку если её нет
    if not exist "%~dp0\.mvn\wrapper" mkdir "%~dp0\.mvn\wrapper"
    
    REM Скачиваем JAR файл
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $webclient = new-object System.Net.WebClient; $webclient.DownloadFile('%WRAPPER_URL%', '%WRAPPER_JAR%')}"
    
    if not exist %WRAPPER_JAR% (
        echo Failed to download Maven Wrapper.
        pause
        exit /b 1
    )
    
    echo Maven Wrapper downloaded successfully.
)

REM Запускаем Maven через Wrapper
"%JAVA_HOME%\bin\java.exe" ^
  %MAVEN_OPTS% ^
  --enable-native-access=ALL-UNNAMED ^
  -Dmaven.multiModuleProjectDirectory="%~dp0" ^
  -classpath %WRAPPER_JAR% ^
  %WRAPPER_LAUNCHER% %*

endlocal
