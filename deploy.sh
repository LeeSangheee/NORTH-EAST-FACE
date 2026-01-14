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

# 스크립트 디렉토리 저장 (초기에 정의)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "============================================"
echo "  North East Face EC2 Deployment"
echo "============================================"

# ============= 1단계: Java 설치 =============
echo ""
echo -e "${YELLOW}[STEP 1/4] Installing Java...${NC}"

if ! command -v java &> /dev/null; then
    echo "Installing Java 11..."
    sudo apt update
    sudo apt install -y openjdk-11-jdk
fi
echo -e "${GREEN}✓ Java installed${NC}"
java -version

# ============= 2단계: Tomcat 설치 =============
echo ""
echo -e "${YELLOW}[STEP 2/4] Installing Tomcat 9...${NC}"

# Tomcat 버전 확인 및 필요시 교체
TOMCAT_VERSION=""
if [ -x "$CATALINA_HOME/bin/version.sh" ]; then
    TOMCAT_VERSION=$(sudo "$CATALINA_HOME/bin/version.sh" 2>/dev/null | grep "Server number" | awk '{print $3}')
fi

# Tomcat 10 이상이면 자동으로 Tomcat 9로 교체
if [[ "$TOMCAT_VERSION" =~ ^10\. ]] || [[ "$TOMCAT_VERSION" =~ ^11\. ]]; then
    echo -e "${YELLOW}⚠️  Tomcat $TOMCAT_VERSION detected (uses jakarta.*). Replacing with Tomcat 9 (uses javax.*)...${NC}"
    
    # Tomcat 중지
    if pgrep -f "tomcat" > /dev/null; then
        sudo "$CATALINA_HOME/bin/shutdown.sh" 2>/dev/null
        sleep 3
    fi
    
    # 백업 및 제거
    if [ -d "$CATALINA_HOME" ]; then
        sudo mv "$CATALINA_HOME" "/opt/tomcat.bak.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Tomcat 9 설치
    cd /tmp
    if [ ! -f "apache-tomcat-9.0.82.tar.gz" ]; then
        wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.82/bin/apache-tomcat-9.0.82.tar.gz
    fi
    sudo tar -xzf apache-tomcat-9.0.82.tar.gz
    sudo mv apache-tomcat-9.0.82 /opt/tomcat
    sudo chown -R $USER:$USER /opt/tomcat
    sudo chmod +x /opt/tomcat/bin/*.sh
    echo -e "${GREEN}✓ Tomcat 9 installed (replaced Tomcat $TOMCAT_VERSION)${NC}"
    cd "$SCRIPT_DIR"  # 프로젝트 디렉토리로 복귀
    
elif [ ! -d "$CATALINA_HOME" ]; then
    echo "Tomcat not found. Installing Tomcat 9..."
    cd /tmp
    wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.82/bin/apache-tomcat-9.0.82.tar.gz
    sudo tar -xzf apache-tomcat-9.0.82.tar.gz
    sudo mv apache-tomcat-9.0.82 /opt/tomcat
    sudo chown -R $USER:$USER /opt/tomcat
    sudo chmod +x /opt/tomcat/bin/*.sh
    echo -e "${GREEN}✓ Tomcat 9 installed${NC}"
    cd "$SCRIPT_DIR"  # 프로젝트 디렉토리로 복귀
else
    echo -e "${GREEN}✓ Tomcat $TOMCAT_VERSION already installed${NC}"
fi

# ============= 3단계: WAR 파일 배포 =============
echo ""
echo -e "${YELLOW}[STEP 3/4] Deploying WAR file...${NC}"

WAR_FILE="$SCRIPT_DIR/target/${WAR_NAME}.war"

# 빌드 전 Tomcat 중지로 리소스 확보
if pgrep -f "tomcat" > /dev/null; then
    echo "Stopping Tomcat before build to free resources..."
    sudo "$CATALINA_HOME/bin/shutdown.sh"
    sleep 3
fi

# Maven이 설치되어 있으면 빌드 (기존 파일 제거 후 다시 빌드)
if command -v mvn &> /dev/null; then
    echo "Building WAR file with Maven..."
    cd "$SCRIPT_DIR"
    # 메모리 제한 및 로그 최소화로 EC2 소형 인스턴스에서도 안정적으로 빌드
    export MAVEN_OPTS="-Xmx512m -XX:+UseG1GC"
    mvn -q clean package -DskipTests
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERROR] Maven build failed!${NC}"
        exit 1
    fi
else
    echo -e "${RED}[ERROR] Maven not found! Cannot build WAR file.${NC}"
    echo ""
    echo "🔧 해결 방법:"
    echo "  1. EC2에 Maven 설치: sudo apt install -y maven"
    echo "  또는"
    echo "  2. 로컬에서 빌드 후 업로드:"
    echo "     cd NORTH-EAST-FACE"
    echo "     mvn clean package -DskipTests"
    echo "     scp -i your-key.pem target/north-east-face.war ec2-user@YOUR-IP:/tmp/"
    echo ""
    exit 1
fi

if [ ! -f "$WAR_FILE" ]; then
    echo -e "${RED}[ERROR] WAR file not found after build: $WAR_FILE${NC}"
    exit 1
fi

echo "Using WAR file: $WAR_FILE"

# 기존 애플리케이션 제거 (컨텍스트를 루트로 배포)
if [ -d "$CATALINA_HOME/webapps/ROOT" ]; then
    echo "Removing existing ROOT application directory..."
    sudo rm -rf "$CATALINA_HOME/webapps/ROOT"
fi

if [ -f "$CATALINA_HOME/webapps/ROOT.war" ]; then
    echo "Removing existing ROOT.war..."
    sudo rm -f "$CATALINA_HOME/webapps/ROOT.war"
fi

# WAR 파일 복사
echo "Copying WAR file to Tomcat as ROOT.war (context path = /)..."
sudo cp "$WAR_FILE" "$CATALINA_HOME/webapps/ROOT.war"
sudo chown tomcat:tomcat "$CATALINA_HOME/webapps/ROOT.war"

if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] Failed to copy WAR file!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ WAR file deployed${NC}"

# ============= 4단계: Tomcat 시작 =============
echo ""
echo -e "${YELLOW}[STEP 4/4] Starting Tomcat...${NC}"

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
echo -e "${GREEN}  ✓ Deployment Completed!${NC}"
echo "============================================"
echo ""
echo "📌 Application URL:"
echo "  http://$(hostname -I | awk '{print $1}'):8080/"
echo ""
echo "📌 Useful commands:"
echo "  View logs:    tail -f $CATALINA_HOME/logs/catalina.out"
echo "  Stop Tomcat:  sudo $CATALINA_HOME/bin/shutdown.sh"
echo "  Start Tomcat: sudo $CATALINA_HOME/bin/startup.sh"
echo ""
echo "⚠️  Database Setup:"
echo "  MySQL 데이터베이스 설정은 별도로 진행하세요."
echo "  자세한 내용은 README.md를 참조하세요."
echo ""
