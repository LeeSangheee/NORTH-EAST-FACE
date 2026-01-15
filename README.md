# 🎒 NORTH EAST FACE - 등산용품 쇼핑몰

**초보자를 위한 설명**: 이것은 인터넷에서 등산용품과 의류를 사고파는 쇼핑몰 웹사이트입니다. 
회원가입을 하고 물품을 장바구니에 담아서 구매할 수 있는 온라인 스토어예요!

## 🌟 주요 기능

* 👤 **회원 관리** - 회원가입, 로그인하기
* 🔐 **안전한 로그인** - 해킹 방지 기술 사용
* 🎒 **상품 보기** - 등산용품 상세 정보 확인
* 🛒 **장바구니** - 물품을 담아놨다가 나중에 구매
* 💳 **결제하기** - 상품 구매하기
* ❤️ **찜하기** - 좋아하는 상품 저장
* 📍 **주소 검색** - 배송 주소 쉽게 입력
* 📱 **모바일 지원** - 핸드폰에서도 잘 보임

## 🛠️ 사용한 기술 (개발자용)

* **백엔드**: Java 11+, Servlet, JSP
* **데이터베이스**: MySQL
* **보안**: JWT 토큰 인증
* **프론트엔드**: HTML, CSS, JavaScript
* **빌드 도구**: Maven
* **서버**: Apache Tomcat


## 💻 설치 방법

### 준비물 (미리 설치해야 할 것들)

* **Java** - 프로그래밍 언어 (버전 11 이상, 21 권장)
* **Maven** - 프로젝트를 빌드하는 도구
* **MySQL** - 고객 정보, 상품 정보를 저장하는 데이터베이스
* **Git** - 코드를 받아오는 도구

### 1️⃣ 데이터베이스 준비하기

먼저 MySQL을 켜고 아래 명령어를 입력해서 데이터베이스를 만들어요:

```sql
CREATE DATABASE nefdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

그 다음 데이터베이스 테이블을 만들어요. 명령어 창에서 이렇게 입력하세요:

```bash
mysql -u root -p nefdb < db/schema.sql
```

### 2️⃣ 코드 받아오기

명령어 창을 열고 이 명령어를 입력하세요:

```bash
git clone https://github.com/NorthEastFace/NORTH-EAST-FACE.git
cd NORTH-EAST-FACE
```

### 3️⃣ 데이터베이스 연결 설정

이 파일을 열어요: `src/main/java/util/DBConnection.java`

아래 부분에 자신의 데이터베이스 정보를 입력하세요:
```java
private static final String URL = "jdbc:mysql://localhost:3306/nefdb?useSSL=false&serverTimezone=UTC";
private static final String USER = "root";  // 여기에 MySQL 사용자명 입력
private static final String PASSWORD = "비밀번호";  // 여기에 MySQL 비밀번호 입력
```

---

## ⚡ 빠르게 시작하기 (자동 배포)

### 🪟 Windows 사용자

명령어 창을 열고 프로젝트 폴더에서 이 명령어를 실행하세요:

```bash
deploy.bat
```

이 명령어가 하는 일:
- ✅ 프로젝트를 빌드
- ✅ 데이터베이스를 준비
- ✅ 웹사이트를 자동으로 실행
- ✅ 웹브라우저를 열어줌

**완료 후 자동으로 이 주소가 열려요:**
```
http://localhost:8080/
```

### 🐧 Linux / Mac 사용자

터미널을 열고 프로젝트 폴더에서 이 명령어를 실행하세요:

```bash
chmod +x deploy.sh
./deploy.sh
```

이 명령어도 Windows와 같은 방식으로 모든 과정을 자동으로 처리해요!

**완료 후 이 주소로 접속하세요:**
```
http://localhost:8080/
```

---

## 📚 수동으로 단계별 실행하기

편집기나 개발 도구를 사용하는 개발자들은 이 방법을 사용하세요:

### Step 1: 프로젝트 빌드

```bash
mvn clean package -DskipTests
```

### Step 2: 서버 실행

```bash
mvn tomcat7:run
```

그러면 웹사이트가 `http://localhost:8080/` 에서 실행되어요!

### 테스트 계정

로그인해서 테스트하고 싶다면 이 정보를 사용하세요:
- 이메일: `t@gmail.com`
- 비밀번호: `testtest`

아니면 회원가입을 해서 새로운 계정을 만들어도 돼요!

---

## 🚀 클라우드(AWS)에 배포하기

> 💡 **초보자 팁**: 이 부분은 개발자가 인터넷에 있는 서버에 웹사이트를 올릴 때만 필요해요!

### 준비 단계

EC2 인스턴스(우분투 20.04 LTS 권장)가 필요합니다.

### EC2에 필수 프로그램 설치

**Step 1: 업데이트**
```bash
sudo apt update && sudo apt upgrade -y
```

**Step 2: Java 설치**
```bash
sudo apt install -y openjdk-11-jdk
java -version
```

**Step 3: MySQL 설치**
```bash
sudo apt install -y mysql-server
```

**Step 4: Tomcat 설치**
```bash
cd /tmp
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.82/bin/apache-tomcat-9.0.82.tar.gz
sudo tar -xzf apache-tomcat-9.0.82.tar.gz
sudo mv apache-tomcat-9.0.82 /opt/tomcat
sudo chown -R tomcat:tomcat /opt/tomcat
```

### EC2에 MySQL 데이터베이스 만들기

```bash
mysql -u root -p
```

그 다음 이 명령어들을 입력하세요:

```sql
CREATE DATABASE nefdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nef_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON nefdb.* TO 'nef_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;

mysql -u nef_user -p nefdb < /path/to/db/schema.sql
```

### 로컬 컴퓨터에서 배포 파일 만들기

**Windows:**
```bash
deploy.bat
```

**Linux/Mac:**
```bash
chmod +x deploy.sh
./deploy.sh
```

이 명령어가 자동으로 `target/north-east-face.war` 파일을 만들어줄 거예요.

### EC2에 배포 파일 옮기기

```bash
# 로컬에서 EC2로 WAR 파일 전송
scp -i your-key.pem target/north-east-face.war ec2-user@your-ec2-ip:/tmp/

# EC2에 들어가서
ssh -i your-key.pem ec2-user@your-ec2-ip
cp /tmp/north-east-face.war /opt/tomcat/webapps/
```

### Tomcat 재시작

```bash
sudo systemctl restart tomcat
```

그러면 웹사이트가 실행될 거예요!
```
http://<EC2-주소>:8080/
```

### AWS 보안 설정

방화벽(보안 그룹)에서 이 포트들을 열어야 해요:
- **포트 22** (SSH): 관리자 IP만
- **포트 80** (HTTP): 모두 가능
- **포트 443** (HTTPS): 모두 가능

---

## 🆘 문제 해결

### 로컬에서 문제가 발생했을 때

**❓ 문제: 포트 8080이 이미 사용 중입니다**
```bash
# 다른 포트를 사용하세요
set CATALINA_OPTS=-Dserver.port=9090
mvn tomcat7:run
```

**❓ 문제: 데이터베이스에 연결할 수 없습니다**
- [src/main/java/util/DBConnection.java](src/main/java/util/DBConnection.java) 파일을 열어서 사용자명과 비밀번호 확인
- MySQL이 실행 중인지 확인

**❓ 문제: 빌드가 실패했습니다**
```bash
# 캐시를 지우고 다시 빌드
mvn clean
mvn package -DskipTests
```

### EC2에서 문제가 발생했을 때

**❓ 문제: Tomcat이 실행되지 않습니다**
```bash
# 로그를 확인하세요
sudo tail -f /opt/tomcat/logs/catalina.out
```

**❓ 문제: MySQL 권한 오류**
```bash
mysql -u root -p
GRANT ALL PRIVILEGES ON nefdb.* TO 'nef_user'@'localhost';
FLUSH PRIVILEGES;
```

**❓ 문제: WAR 파일 배포가 실패했습니다**
```bash
# Tomcat의 권한을 확인하세요
sudo chown -R tomcat:tomcat /opt/tomcat/webapps/
sudo chmod -R 755 /opt/tomcat/webapps/
```

---

## 📁 파일 구조

이 프로젝트의 주요 폴더들을 설명해요:

```
NORTH-EAST-FACE/
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/          ← 웹 요청을 받는 부분
│       │   ├── dao/                 ← 데이터베이스에서 데이터를 가져오는 부분
│       │   ├── model/               ← 상품, 회원 정보 등 데이터를 저장하는 부분
│       │   ├── filter/              ← 로그인 확인하는 부분
│       │   ├── servlet/             ← 웹 요청을 처리하는 추가 부분
│       │   └── util/                ← 데이터베이스 연결 등 도구
│       └── webapp/
│           ├── *.jsp                ← 웹사이트 화면 (HTML)
│           ├── WEB-INF/
│           │   ├── web.xml          ← 웹사이트 설정
│           │   └── views/           ← JSP 페이지들
│           └── static/              ← 이미지, CSS, JavaScript
├── db/
│   └── schema.sql                   ← 데이터베이스 구조
├── pom.xml                          ← 필요한 라이브러리 정의
├── deploy.bat                       ← Windows 자동 배포 (이것만 실행!)
├── deploy.sh                        ← Linux 자동 배포 (이것만 실행!)
└── README.md                        ← 이 파일
```

---

## 🔑 API 엔드포인트 (개발자용)

**로그인/회원가입:**
- `POST /login` - 로그인
- `POST /register` - 회원가입
- `GET /logout` - 로그아웃

**상품 조회:**
- `GET /products` - 상품 목록 보기
- `GET /product-detail?id=1` - 상품 상세 정보

**장바구니:**
- `GET /cart` - 장바구니 페이지
- `POST /api/cart` - 장바구니에 물품 추가

**결제:**
- `GET /checkout` - 결제 페이지

---

## 📜 라이선스

MIT License - 자유롭게 사용, 수정, 배포 가능합니다!

---

## ❓ 자주 묻는 질문

**Q: deploy.bat와 deploy.sh의 차이점이 뭔가요?**
- A: Windows와 Linux에서 실행하는 방식이 달라서 따로 만들었어요. 같은 역할을 합니다!
  - 🪟 Windows → `deploy.bat` 실행
  - 🐧 Linux/Mac → `./deploy.sh` 실행

**Q: 처음부터 다시 시작하려면?**
- A: 이 명령어로 모든 빌드 파일을 삭제한 후 다시 시작하세요
  ```bash
  mvn clean
  ```

**Q: 회원가입은 어디서?**
- A: 웹사이트를 열면 로그인 페이지가 나와요. 거기서 회원가입 버튼을 눌러서 새로운 계정을 만들 수 있습니다!

---

## 💬 도움말

문제가 생기거나 질문이 있으시면:
1. 위의 "🆘 문제 해결" 섹션을 확인해보세요
2. 로그 파일을 읽어보세요 (명령어 창에 빨간 글씨로 오류가 나옵니다)
3. 개발자에게 문의하세요!

---

**행운을 빕니다! 이제 시작해보세요! 🚀**  

