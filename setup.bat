@echo off
cd /d "%~dp0"

echo STEP 1: Loading Docker images...
cd images

echo - Loading web image...
docker load -i pls-web.tar
if %errorlevel% neq 0 (
    echo Failed to load pls-web.tar image!
    pause
    exit /b %errorlevel%
)

echo - Loading was image...
docker load -i pls-was.tar
if %errorlevel% neq 0 (
    echo Failed to load pls-was.tar image!
    pause
    exit /b %errorlevel%
)

echo - Loading mysql image...
docker load -i pls-mysql.tar
if %errorlevel% neq 0 (
    echo Failed to load pls-mysql.tar image!
    pause
    exit /b %errorlevel%
)

echo - Loading redis image...
docker load -i pls-redis.tar
if %errorlevel% neq 0 (
    echo Failed to load pls-redis.tar image!
    pause
    exit /b %errorlevel%
)

echo STEP 1: Docker images loaded successfully!
cd ..

echo STEP 2: Starting containers (Compose)...
docker-compose -f docker-compose.yml up -d
if %errorlevel% neq 0 (
    echo Failed to start containers with docker-compose!
    pause
    exit /b %errorlevel%
)

echo STEP 2: Containers started successfully!

echo STEP 3: Setting Mysql Schema...
TIMEOUT 3
mysql -u root -p1q2w3e4r! -P 13306 pls -e "source pls-mysql.sql"
if %errorlevel% neq 0 (
    echo Failed to setting mysql schema!
    pause
    exit /b %errorlevel%
)

echo STEP 3: Mysql schema setting successfully!

echo All tasks completed successfully.
pause