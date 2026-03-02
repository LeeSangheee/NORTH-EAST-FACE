# NORTH EAST FACE - 등산용품 쇼핑몰 AWS 배포 인프라

4인 팀 프로젝트로 개발한 등산용품 쇼핑몰을 AWS 위에 직접 설계하고 배포한 인프라 프로젝트입니다.  
서비스 기획부터 배포 인프라 전체를 담당했습니다.

---

## 담당 역할

- **서비스 기획**: 쇼핑몰 기능 정의 및 사용자 흐름 설계
- **배포 인프라 설계 및 구축 전담**: AWS 아키텍처 설계, 네트워크 구성, CI/CD 파이프라인 구축

---

## 인프라 아키텍처

```
[ 사용자 ]
    │
    ▼
[ Route53 ] ──── 도메인 기반 트래픽 라우팅
    │
    ▼
[ CloudFront + S3 ] ──── 정적 리소스 CDN 캐싱
    │
    ▼
[ ALB (Application Load Balancer) ]
    │
    ▼
[ EC2 (Tomcat + WAR) ] ──── Private Subnet
    │
    ▼
[ RDS MySQL / MySQL on EC2 ] ──── DB Tier
```

**네트워크 구성**

```
VPC
├── Public Subnet  ── ALB, NAT Gateway
└── Private Subnet ── EC2 (WAS), RDS
```

---

## 기술 스택

| 분류 | 기술 |
|------|------|
| Compute | AWS EC2 |
| Load Balancer | AWS ALB |
| Database | RDS / MySQL |
| CDN | AWS CloudFront, S3 |
| DNS | AWS Route53 |
| Security | Security Group, IAM |
| CI/CD | GitHub Actions |
| Application | Java 11, Servlet/JSP, Tomcat, Maven |

---

## 구현 상세

### 1. AWS 네트워크 설계

- VPC 내 Public/Private Subnet 분리로 WAS와 DB를 외부에서 직접 접근 불가한 구조로 설계
- Security Group 최소 권한 원칙 적용: ALB → EC2 → RDS 포트만 허용
- NAT Gateway를 통해 Private Subnet의 EC2가 외부 패키지 설치 가능하도록 구성

### 2. ALB 기반 무중단 배포

- ALB + Target Group 구성으로 인스턴스 교체 시 다운타임 없이 배포
- Health Check 설정으로 비정상 인스턴스 자동 제외

### 3. GitHub Actions CI/CD 파이프라인

- main 브랜치 push 시 자동으로 빌드 → WAR 패키징 → EC2 배포까지 파이프라인 구성
- IAM Role 기반 인증으로 Access Key 없이 배포 자동화

```yaml
# 파이프라인 흐름
push to main
  → Maven build (mvn clean package)
  → WAR 파일 생성
  → EC2 SSH 배포
  → Tomcat 재시작
```

### 4. CloudFront + S3 정적 리소스 분리

- 이미지, CSS, JS 등 정적 파일을 S3에 업로드하고 CloudFront로 CDN 캐싱
- 동적 요청(Tomcat)과 정적 리소스 경로를 ALB 레벨에서 분기 처리

### 5. Route53 도메인 연결

- Route53 A 레코드로 ALB에 도메인 연결
- ACM 인증서 발급 후 HTTPS 엔드포인트 구성

---

## 주요 기능 (애플리케이션)

- 회원 가입 / 로그인 (JWT 토큰 인증)
- 상품 목록 조회 및 상세 페이지
- 장바구니 담기 / 결제
- 찜하기 / 주소 검색 (카카오 주소 API)
- 모바일 반응형 UI

---

## 디렉토리 구조

```
NORTH-EAST-FACE/
├── src/main/
│   ├── java/
│   │   ├── controller/     # 요청 처리
│   │   ├── dao/            # DB 접근 레이어
│   │   ├── model/          # 도메인 모델
│   │   ├── filter/         # 인증 필터
│   │   └── util/           # DB 연결 유틸
│   └── webapp/
│       ├── *.jsp           # 화면
│       └── static/         # 정적 리소스
├── db/
│   └── schema.sql          # DB 스키마
├── .github/workflows/      # GitHub Actions CI/CD
├── pom.xml
└── deploy.sh / deploy.bat  # 수동 배포 스크립트
```

---

## 배운 점 및 트레이드오프

**단일 EC2 vs Auto Scaling**

이 프로젝트는 단일 EC2 인스턴스로 구성했습니다. 실제 프로덕션이라면  
ASG(Auto Scaling Group)를 추가하여 트래픽 급증 대응 및 인스턴스 장애 시  
자동 교체 구조를 갖추는 것이 필요합니다.

**GitHub Actions 배포 방식**

SSH 직접 접속 방식으로 배포했는데, 실무에서는 CodeDeploy나  
Systems Manager Session Manager를 활용하면 SSH 포트를 열지 않아도  
안전하게 배포할 수 있습니다.

---

## 팀 구성

| 역할 | 담당 |
|------|------|
| 서비스 기획 / 배포 인프라 | 이상희 |
| 백엔드 개발 | 팀원 |
| 백엔드 개발 | 팀원 |
| 프론트엔드 / UI | 팀원 |

---

## 기술 스택 요약

`AWS EC2` `ALB` `RDS` `CloudFront` `S3` `Route53` `ACM` `GitHub Actions` `Java` `Servlet/JSP` `Tomcat` `MySQL` `Maven`
