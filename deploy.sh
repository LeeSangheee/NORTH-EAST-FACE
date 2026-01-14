#!/bin/bash
# ============================================
# north-east-face EC2 Deployment Script
# ============================================

# 색상 설정
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 톰캣 경로 설정
TOMCAT_HOME=${TOMCAT_HOME:-"/opt/tomcat"}
CATALINA_HOME=${CATALINA_HOME:-$TOMCAT_HOME}

# WAR 파일 이름
WAR_NAME="north-east-face"
APP_NAME="north-east-face"

echo "============================================"
echo "  North East Face EC2 Setup & Deploy"
echo "============================================"

# ============= 1단계: 필수 소프트웨어 설치 =============
echo ""
echo -e "${YELLOW}[STEP 1/6] Installing required software...${NC}"

# Java 설치 확인
if ! command -v java &> /dev/null; then
    echo "Installing Java..."
    sudo apt update
    sudo apt install -y openjdk-11-jdk
fi
echo -e "${GREEN}✓ Java installed${NC}"
java -version

# MySQL 설치 확인
if ! command -v mysql &> /dev/null; then
    echo "Installing MySQL..."
    sudo apt install -y mysql-server
fi
echo -e "${GREEN}✓ MySQL installed${NC}"

# ============= 2단계: Tomcat 설치 =============
echo ""
echo -e "${YELLOW}[STEP 2/6] Installing Tomcat 10...${NC}"

if [ ! -d "$CATALINA_HOME" ]; then
    echo "Tomcat not found. Installing..."
    cd /tmp
    wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.5/bin/apache-tomcat-10.1.5.tar.gz
    sudo tar -xzf apache-tomcat-10.1.5.tar.gz
    sudo mv apache-tomcat-10.1.5 /opt/tomcat
    sudo chown -R tomcat:tomcat /opt/tomcat
    echo -e "${GREEN}✓ Tomcat installed${NC}"
else
    echo -e "${GREEN}✓ Tomcat already installed at: $CATALINA_HOME${NC}"
fi

# ============= 3단계: MySQL 데이터베이스 설정 =============
echo ""
echo -e "${YELLOW}[STEP 3/6] Setting up MySQL database...${NC}"

read -p "Enter MySQL root password: " -s MYSQL_ROOT_PASS
echo

# 데이터베이스 생성
echo "Creating database..."
mysql -u root -p"$MYSQL_ROOT_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS north_east_face CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'nef_user'@'localhost' IDENTIFIED BY 'nef_password_123';
GRANT ALL PRIVILEGES ON north_east_face.* TO 'nef_user'@'localhost';
FLUSH PRIVILEGES;
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database created${NC}"
else
    echo -e "${RED}[ERROR] Failed to create database${NC}"
    exit 1
fi

# 테이블 생성
echo "Creating tables..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f "$SCRIPT_DIR/db/schema.sql" ]; then
    mysql -u nef_user -p'nef_password_123' north_east_face < "$SCRIPT_DIR/db/schema.sql"
    echo -e "${GREEN}✓ Tables created${NC}"
else
    echo -e "${YELLOW}[WARNING] schema.sql not found at $SCRIPT_DIR/db/${NC}"
    echo "Please manually run: mysql -u nef_user -p north_east_face < db/schema.sql"
fi

# ============= 4단계: DBConnection 설정 파일 수정 =============
echo ""
echo -e "${YELLOW}[STEP 4/6] Updating database connection config...${NC}"

DB_CONNECTION_FILE="$SCRIPT_DIR/src/main/java/util/DBConnection.java"

if [ -f "$DB_CONNECTION_FILE" ]; then
    # DBConnection.java에서 DB URL, USER, PASSWORD 자동 설정 (선택사항)
    echo -e "${GREEN}✓ DBConnection file located${NC}"
    echo "  File: $DB_CONNECTION_FILE"
    echo "  Please verify the following settings match your EC2 environment:"
    echo "    - URL: jdbc:mysql://localhost:3306/north_east_face"
    echo "    - USER: nef_user"
    echo "    - PASSWORD: nef_password_123"
else
    echo -e "${YELLOW}[WARNING] DBConnection.java not found${NC}"
fi

# ============= 5단계: WAR 파일 배포 =============
echo ""
echo -e "${YELLOW}[STEP 5/6] Deploying WAR file...${NC}"

WAR_FILE="$SCRIPT_DIR/target/${WAR_NAME}.war"

if [ ! -f "$WAR_FILE" ]; then
    echo -e "${RED}[ERROR] WAR file not found: $WAR_FILE${NC}"
    echo ""
    echo "WAR 파일을 생성해야 합니다. 다음 방법 중 하나를 선택하세요:"
    echo ""
    echo "[방법 1] 로컬 컴퓨터에서 빌드 후 업로드:"
    echo "  1. 로컬에서 실행: mvn clean package -DskipTests"
    echo "  2. WAR 파일 생성 확인: target/north-east-face.war"
    echo "  3. EC2로 업로드: scp -i your-key.pem target/north-east-face.war ec2-user@your-ip:/tmp/"
    echo "  4. EC2에서 이동: sudo cp /tmp/north-east-face.war $CATALINA_HOME/webapps/"
    echo ""
    echo "[방법 2] Git에서 클론 후 재시도:"
    echo "  1. git clone <repository>"
    echo "  2. ./deploy.sh 다시 실행"
    echo ""
    exit 1
fi

# 기존 애플리케이션 제거
if [ -d "$CATALINA_HOME/webapps/$APP_NAME" ]; then
    echo "Removing existing application directory..."
    sudo rm -rf "$CATALINA_HOME/webapps/$APP_NAME"
fi

if [ -f "$CATALINA_HOME/webapps/${WAR_NAME}.war" ]; then
    echo "Removing existing WAR file..."
    sudo rm -f "$CATALINA_HOME/webapps/${WAR_NAME}.war"
fi

# WAR 파일 복사
echo "Copying WAR file to Tomcat..."
sudo cp "$WAR_FILE" "$CATALINA_HOME/webapps/"
sudo chown tomcat:tomcat "$CATALINA_HOME/webapps/${WAR_NAME}.war"

if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] Failed to copy WAR file!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ WAR file deployed${NC}"

# ============= 6단계: Tomcat 시작 =============
echo ""
echo -e "${YELLOW}[STEP 6/6] Starting Tomcat...${NC}"

# Tomcat 프로세스 확인 및 종료
if pgrep -f "tomcat" > /dev/null; then
    echo "Stopping existing Tomcat process..."
    sudo "$CATALINA_HOME/bin/shutdown.sh"
    sleep 3
fi

# Tomcat 시작
echo "Starting Tomcat..."
sudo "$CATALINA_HOME/bin/startup.sh"
sleep 3

# 시작 확인
if pgrep -f "tomcat" > /dev/null; then
    echo -e "${GREEN}✓ Tomcat started successfully${NC}"
else
    echo -e "${RED}[ERROR] Failed to start Tomcat${NC}"
    exit 1
fi

# ============= 완료 =============
echo ""
echo "============================================"
echo -e "${GREEN}  ✓ Deployment Completed Successfully!${NC}"
echo "============================================"
echo ""
echo "📌 Access your application:"
echo "  URL: http://$(hostname -I | awk '{print $1}'):8080/${APP_NAME}/"
echo ""
echo "📌 Useful commands:"
echo "  View logs:    tail -f $CATALINA_HOME/logs/catalina.out"
echo "  Stop Tomcat:  sudo $CATALINA_HOME/bin/shutdown.sh"
echo "  Start Tomcat: sudo $CATALINA_HOME/bin/startup.sh"
echo ""
echo "✅ Setup complete! Check if the application is accessible in your browser."
echo ""
