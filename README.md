# NORTH EAST FACE - 이커머스 쇼핑몰

Java 기반 고급 의류/등산용품 이커머스 플랫폼입니다.

## 주요 기능

* 회원 관리 (회원가입, 로그인, 이메일 기반 인증)
* JWT 토큰 기반 인증 시스템
* 상품 조회 및 상세 정보
* 장바구니 (로컬스토리지 + DB 동기화)
* 결제 페이지 (테스트 모드)
* 위시리스트 (찜)
* 다음 우편번호 API 통합
* 반응형 웹 디자인

## 기술 스택

* **Backend**: Java 11+, Servlet 5.0, JSP
* **Database**: MySQL
* **Authentication**: JWT (JSON Web Token)
* **Frontend**: HTML5, CSS3, JavaScript
* **Build**: Maven
* **Server**: Apache Tomcat 9


## 설치 및 실행

### 필수 요구사항

* **JDK 11 이상** (권장: JDK 17, JDK 21)
* **Maven 3.6+**
* **MySQL 8.0+**
* **Git**

### 데이터베이스 설정

1. MySQL에 데이터베이스 생성:
```sql
CREATE DATABASE nefdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 테이블 생성 (`db/schema.sql` 실행):
```bash
mysql -u root -p nefdb < db/schema.sql
```

3. 데이터베이스 접속 정보 설정:
   - 파일: `src/main/java/util/DBConnection.java`
   - 필요시 DB URL, 사용자명, 비밀번호 수정

---

## 로컬 환경 실행

### 1. 프로젝트 클론
```bash
git clone https://github.com/NorthEastFace/NORTH-EAST-FACE.git
cd NORTH-EAST-FACE
```

### 2. Maven 빌드
```bash
mvn clean package -DskipTests
```

### 3. WAR 파일로 실행 (embedded Tomcat)

**Windows:**
```bash
build-and-deploy.bat
```

**Linux/Mac:**
```bash
mvn tomcat7:run
```

또는 생성된 WAR 파일을 직접 Tomcat에 배포:
```bash
# WAR 파일이 target/north-east-face.war 에 생성됨
# Tomcat webapps 폴더에 복사
cp target/north-east-face.war $CATALINA_HOME/webapps/
```

### 4. 애플리케이션 접속

```
http://localhost:8080/
```

### 5. 테스트 계정

회원가입 후 사용하거나 아래 테스트 계정으로 로그인:
- 이메일: `test@example.com`
- 비밀번호: `password123`

---

## EC2 환경 배포

### 전제 조건

* EC2 인스턴스 (Ubuntu 20.04 LTS 권장)
* Java 11 이상 설치
* MySQL 8.0 설치
* Tomcat 10 설치

> **Maven은 설치할 필요 없습니다!** WAR 파일은 로컬에서 생성해서 업로드합니다.

### 배포 단계

#### 1. EC2에 필수 소프트웨어 설치 (Maven 불필요)

```bash
# 패키지 업데이트
sudo apt update && sudo apt upgrade -y

# Java 설치
sudo apt install -y openjdk-11-jdk
java -version

# MySQL 설치
sudo apt install -y mysql-server

# Tomcat 9 설치 (javax 기반 앱과 호환)
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.82/bin/apache-tomcat-9.0.82.tar.gz
sudo tar -xzf apache-tomcat-9.0.82.tar.gz
sudo mv apache-tomcat-9.0.82 /opt/tomcat
sudo chown -R tomcat:tomcat /opt/tomcat
```

#### 2. MySQL 데이터베이스 설정

```bash
# MySQL 접속
mysql -u root -p

# 데이터베이스 및 사용자 생성
CREATE DATABASE nefdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nef_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON nefdb.* TO 'nef_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# 테이블 생성
mysql -u nef_user -p nefdb < /path/to/db/schema.sql
```

#### 3. 로컬에서 WAR 파일 빌드 (로컬 컴퓨터에서)

```bash
# 로컬에서만 Maven이 필요합니다!
mvn clean package -DskipTests

# WAR 파일이 target/north-east-face.war 에 생성됨
```

#### 4. WAR 파일을 EC2에 업로드

**SCP를 사용한 업로드:**
```bash
# 로컬에서 EC2로 WAR 파일 전송
scp -i your-key.pem target/north-east-face.war ec2-user@your-ec2-ip:/tmp/
```

또는 **git으로 클론 후 직접 배포:**

```bash
# EC2에서
cd /home/ec2-user
git clone https://github.com/NorthEastFace/NORTH-EAST-FACE.git
cd NORTH-EAST-FACE

# 스크립트 실행 (자동으로 모든 과정 처리)
chmod +x deploy.sh
./deploy.sh
```

#### 5. 데이터베이스 연결 설정

`src/main/java/util/DBConnection.java` 수정 (로컬에서):
```java
private static final String URL = "jdbc:mysql://localhost:3306/nefdb?useSSL=false&serverTimezone=UTC";
private static final String USER = "nef_user";
private static final String PASSWORD = "your_secure_password";
```

**그 후 WAR 파일을 다시 빌드해서 EC2에 업로드합니다.**

#### 6. Tomcat 재시작 및 접속

```bash
# Tomcat 재시작
sudo systemctl restart tomcat

# 또는 수동 시작/중지
sudo /opt/tomcat/bin/shutdown.sh
sudo /opt/tomcat/bin/startup.sh

# 로그 확인
tail -f /opt/tomcat/logs/catalina.out
```

접속 확인:
```
http://<EC2-IP-주소>:8080/
```

### AWS 보안 그룹 설정

- **포트 22** (SSH): 관리자 IP만
- **포트 80** (HTTP): 0.0.0.0/0
- **포트 443** (HTTPS): 0.0.0.0/0 (필요시)

---

## 문제 해결

### 로컬 환경

**포트 충돌**: Tomcat 포트 변경
```bash
# catalina.properties에서 포트 설정
export CATALINA_OPTS="-Dserver.port=9090"
mvn tomcat7:run
```

**데이터베이스 연결 오류**: `DBConnection.java`의 접속 정보 확인

### EC2 환경

**Tomcat 로그 확인**:
```bash
sudo tail -f /opt/tomcat/logs/catalina.out
```

**MySQL 권한 오류**:
```bash
mysql -u root -p
GRANT ALL PRIVILEGES ON nefdb.* TO 'nef_user'@'localhost';
FLUSH PRIVILEGES;
```

**WAR 배포 실패**: Tomcat 권한 확인
```bash
sudo chown -R tomcat:tomcat /opt/tomcat/webapps/
sudo chmod -R 755 /opt/tomcat/webapps/
```


## 파일 구조

```
NORTH-EAST-FACE/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── controller/       # Servlet 컨트롤러
│   │   │   ├── dao/              # 데이터 접근 계층
│   │   │   ├── model/            # 데이터 모델
│   │   │   ├── filter/           # JWT 필터
│   │   │   ├── servlet/          # 추가 서블릿
│   │   │   └── util/             # 유틸리티
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/        # JSP 페이지
│   │       │   ├── tags/         # 커스텀 태그
│   │       │   └── web.xml       # 배포 설명자
│   │       └── static/           # CSS, JS, 이미지
│   └── test/                     # 테스트 코드
├── db/
│   └── schema.sql               # 데이터베이스 스키마
├── pom.xml                      # Maven 설정
├── README.md                    # 이 파일
├── deploy.sh                    # Linux 자동 배포 스크립트
└── build-and-deploy.bat         # Windows 빌드 스크립트
```

## 주요 API 엔드포인트

### 인증
- `POST /login` - 로그인
- `POST /register` - 회원가입
- `GET /logout` - 로그아웃

### 상품
- `GET /products` - 상품 목록
- `GET /product-detail?id=1` - 상품 상세

### 장바구니
- `GET /cart` - 장바구니 페이지
- `GET /api/cart` - 장바구니 조회
- `POST /api/cart` - 장바구니 추가/수정

### 결제
- `GET /checkout` - 결제 페이지

## 라이센스

MIT License - 자유롭게 사용, 수정, 배포 가능

  

