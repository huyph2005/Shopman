@echo off
rem Compile and package ShopMan.war. Requires JDK 21 and CATALINA_HOME pointing to Apache Tomcat 10.1
rem whose lib folder already holds the JSTL, MySQL Connector/J and jBCrypt jars (see README.md).
setlocal
cd /d "%~dp0"
if "%CATALINA_HOME%"=="" (
    echo Please set CATALINA_HOME to the Apache Tomcat 10.1 folder.
    exit /b 1
)
if exist build rmdir /s /q build
mkdir build\WEB-INF\classes
xcopy /e /q /y web build >nul
javac -encoding UTF-8 --release 21 -cp "%CATALINA_HOME%\lib\*" -d build\WEB-INF\classes src\model\*.java src\dao\*.java
if errorlevel 1 exit /b 1
if exist ShopMan.war del ShopMan.war
jar -cf ShopMan.war -C build .
echo Created ShopMan.war
