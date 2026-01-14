#!/bin/bash
# ============================================
# north-east-face System Build and Deploy Script for Linux
# ============================================

# 색상 설정
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 톰캣 경로 설정 (환경에 맞게 수정)
TOMCAT_HOME=${TOMCAT_HOME:-"/opt/tomcat"}
CATALINA_HOME=${CATALINA_HOME:-$TOMCAT_HOME}

# WAR 파일 이름
WAR_NAME="north-east-face"
APP_NAME="north-east-face"

echo "============================================"
echo "  North East Face Deployment Script"
echo "============================================"

# Maven 설치 확인
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}[ERROR] Maven not found!${NC}"
    echo "Please install Maven:"
    echo "  Ubuntu/Debian: sudo apt-get install maven"
    echo "  CentOS/RHEL: sudo yum install maven"
    exit 1
fi

echo -e "${GREEN}[1/5] Found Maven:${NC} $(mvn -version | head -n 1)"

# 톰캣 경로 확인
if [ ! -d "$CATALINA_HOME" ]; then
    echo -e "${YELLOW}[WARNING] Tomcat not found at: $CATALINA_HOME${NC}"
    echo "Please set TOMCAT_HOME environment variable or update the script."
    echo "Example: export TOMCAT_HOME=/usr/local/tomcat"
    read -p "Enter Tomcat installation path: " TOMCAT_PATH
    if [ -d "$TOMCAT_PATH" ]; then
        CATALINA_HOME=$TOMCAT_PATH
    else
        echo -e "${RED}[ERROR] Invalid Tomcat path!${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}[2/5] Using Tomcat:${NC} $CATALINA_HOME"

# Maven 빌드
echo -e "${GREEN}[3/5] Building WAR file with Maven...${NC}"
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] Build failed!${NC}"
    exit 1
fi

# WAR 파일 확인
if [ ! -f "target/${WAR_NAME}.war" ]; then
    echo -e "${RED}[ERROR] WAR file not found: target/${WAR_NAME}.war${NC}"
    exit 1
fi

echo -e "${GREEN}[4/5] Build successful! WAR file created.${NC}"

# 톰캣 중지
echo -e "${GREEN}[5/5] Deploying to Tomcat...${NC}"

# 기존 애플리케이션 제거
if [ -d "$CATALINA_HOME/webapps/$APP_NAME" ]; then
    echo "Removing existing application directory..."
    rm -rf "$CATALINA_HOME/webapps/$APP_NAME"
fi

if [ -f "$CATALINA_HOME/webapps/${WAR_NAME}.war" ]; then
    echo "Removing existing WAR file..."
    rm -f "$CATALINA_HOME/webapps/${WAR_NAME}.war"
fi

# WAR 파일 복사
echo "Copying WAR file to Tomcat..."
cp "target/${WAR_NAME}.war" "$CATALINA_HOME/webapps/"

if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] Failed to copy WAR file!${NC}"
    echo "Please check Tomcat permissions."
    exit 1
fi

echo -e "${GREEN}Deployment successful!${NC}"
echo ""
echo "============================================"
echo "  Deployment Complete"
echo "============================================"
echo "WAR file: $CATALINA_HOME/webapps/${WAR_NAME}.war"
echo ""
echo "To start/restart Tomcat:"
echo "  Start:   $CATALINA_HOME/bin/startup.sh"
echo "  Restart: $CATALINA_HOME/bin/shutdown.sh && $CATALINA_HOME/bin/startup.sh"
echo "  Stop:    $CATALINA_HOME/bin/shutdown.sh"
echo ""
echo "Application URL (after Tomcat starts):"
echo "  http://localhost:8080/${APP_NAME}/"
echo ""

# 톰캣 재시작 물어보기
read -p "Do you want to restart Tomcat now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Restarting Tomcat..."
    
    # 톰캣 중지
    if [ -f "$CATALINA_HOME/bin/shutdown.sh" ]; then
        $CATALINA_HOME/bin/shutdown.sh
        echo "Waiting for Tomcat to stop..."
        sleep 5
    fi
    
    # 톰캣 시작
    if [ -f "$CATALINA_HOME/bin/startup.sh" ]; then
        $CATALINA_HOME/bin/startup.sh
        echo -e "${GREEN}Tomcat restarted!${NC}"
        echo "Check logs: tail -f $CATALINA_HOME/logs/catalina.out"
    else
        echo -e "${RED}[ERROR] Tomcat startup script not found!${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}Done!${NC}"
