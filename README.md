# 🏠 Ohouse — 라이프스타일 커머스 플랫폼

> 상품 탐색부터 주문·결제, 리뷰까지 제공하는 온라인 쇼핑몰 프로젝트입니다.  
> 일반 회원, 판매자, 관리자 역할을 구분하여 각 사용자에게 필요한 기능을 제공하도록 설계했습니다.

<p align="center">
  <b>Java · JSP · Servlet · JDBC · Oracle</b>
</p>

---

## 📌 프로젝트 소개

**Ohouse**는 상품을 탐색하고 구매하는 일반 쇼핑 기능과, 상품을 등록하고 주문을 관리하는 판매자 기능, 서비스 전반을 운영하는 관리자 기능을 통합한 커머스 웹 애플리케이션입니다.

Servlet 기반의 Front Controller 구조와 요청별 Command Handler를 적용해 URL 요청을 처리하며, DAO와 Service 계층을 통해 비즈니스 로직과 데이터 접근 로직을 분리했습니다.

## ✨ 주요 기능

### 🛍️ 사용자 쇼핑
- 메인 페이지 및 상품 카테고리 탐색
- 상품 검색 및 인기 검색어 조회
- 상품 상세 정보와 옵션 확인
- 장바구니 상품 추가, 수량·옵션 변경 및 삭제
- 주문서 작성 및 결제 처리 흐름
- 배송지 등록, 기본 배송지 설정 및 삭제
- 주문 내역 및 마이페이지
- 상품 리뷰 작성·수정·삭제와 리뷰 도움돼요 기능
- 회원가입, 로그인, 로그아웃 및 비밀번호 변경
- 쿠폰 조회 및 사용 관련 기능

### 🏪 판매자
- 판매자 회원가입 및 가입 상태 확인
- 판매자 대시보드
- 상품 등록·수정·삭제 및 상품 목록 관리
- 주문 목록 조회와 배송 상태 변경
- 클레임 목록 확인
- 정산 내역 조회

### 🛠️ 관리자
- 관리자 대시보드
- 전체 회원 조회 및 회원 상태 변경
- 판매자 목록 관리 및 입점 승인
- 상품 조회, 상태 변경 및 삭제
- 쿠폰 생성·상태 변경·회원 발급
- 정산 목록 조회 및 정산 처리

## 🧰 기술 스택

| 구분 | 기술 |
|---|---|
| Language | Java |
| Web | Java Servlet, JSP, HTML, CSS, JavaScript |
| Architecture | Front Controller, Command Handler, DAO / Service 계층 |
| Database Access | JDBC |
| Database | Oracle Database |
| Web Container | Servlet/JSP 호환 컨테이너 (예: Apache Tomcat) |
| AJAX | 별도 AJAX Controller 및 비동기 요청 처리 |
| Data Modeling | ERD 파일 제공 (`ohouse.exerd`) |

> 실제 실행 환경의 서버 및 JDK 버전은 개발 환경 설정을 기준으로 확인해야 합니다.

## 🏗️ 애플리케이션 구조

요청 유형에 따라 공통 디스패처 또는 AJAX 컨트롤러가 요청을 처리합니다.

```text
Browser
  │
  ├── *.htm
  │     └── DispatcherServlet
  │           └── commandHandler.properties
  │                 └── CommandHandler
  │                       └── Service
  │                             └── DAO / DAOImpl
  │                                   └── JDBC
  │                                         └── Oracle DB
  │
  ├── *.ajax
  │     └── AjaxControllerUsingURI
  │           └── ajaxCommandHandlerURI.properties
  │                 └── AJAX Handler
  │
  └── JSP View
        └── HTML / CSS / JavaScript
```

### 디렉터리 구성

```text
ohouse/
├── main/
│   ├── java/com/ohouse/
│   │   ├── address/       # 배송지 관리
│   │   ├── admin/         # 관리자 기능
│   │   ├── common/        # 공통 컨트롤러와 핸들러
│   │   ├── main/          # 메인 화면
│   │   ├── member/        # 회원 및 마이페이지
│   │   ├── product/       # 상품, 장바구니, 주문, 결제, 리뷰
│   │   ├── search/        # 검색 및 인기 검색어
│   │   ├── seller/        # 판매자 및 상품 관리
│   │   ├── shopping/      # 카테고리 및 쇼핑 화면
│   │   └── util/          # 공통 유틸리티
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── commandHandler.properties
│       │   ├── ajaxCommandHandlerURI.properties
│       │   └── views/     # JSP 화면
│       ├── css/
│       ├── js/
│       └── images/
├── ohouse.exerd           # ERD 모델
└── README.md
```

## 🔄 요청 처리 방식

1. 사용자가 `*.htm` URL로 요청합니다.
2. `DispatcherServlet`이 `commandHandler.properties`에서 URL에 연결된 Handler를 찾습니다.
3. Handler가 Service 및 DAO 계층을 사용해 기능을 처리합니다.
4. 처리 결과에 따라 JSP로 포워딩하거나 다른 URL로 리다이렉트합니다.
5. 비동기 요청은 `*.ajax` 매핑과 별도 AJAX Controller를 통해 처리합니다.

## 🗄️ 데이터베이스

저장소에는 데이터 모델링 파일 `ohouse.exerd`가 포함되어 있습니다. 데이터베이스 연결은 프로젝트의 JDBC 연결 유틸리티 설정을 기준으로 구성해야 합니다.

### 실행 전 확인 사항
- Oracle Database 실행 및 스키마 준비
- 프로젝트에서 사용하는 테이블·시퀀스·제약 조건 생성
- JDBC 연결 정보 설정
- 외부 결제 및 메일 등 연동 기능이 있다면 해당 API 키와 환경 설정 구성

⚠️ 연결 문자열, 계정, 비밀번호, API 키 등 민감한 정보는 저장소에 직접 커밋하지 말고 별도의 로컬 설정으로 관리하세요.

## 🚀 실행 방법

이 저장소는 일반적인 Maven/Gradle Spring Boot 프로젝트 형태가 아닌 Servlet/JSP 웹 애플리케이션 구조입니다. 아래는 실행을 위한 기본 절차입니다.

1. Java 및 Servlet/JSP를 지원하는 웹 컨테이너를 설치합니다.
2. 프로젝트를 Eclipse 등 Java 웹 개발 IDE로 가져옵니다.
3. Oracle 데이터베이스와 필요한 스키마를 준비합니다.
4. 프로젝트의 JDBC 연결 설정을 로컬 환경에 맞게 수정합니다.
5. 웹 컨테이너에 프로젝트를 배포하고 애플리케이션 URL에 접속합니다.

> 빌드 도구 설정, JDK 버전, DB 스키마 초기화 스크립트 및 서버 설정은 개발 환경에 따라 별도 확인이 필요합니다. 저장소에 포함되지 않은 설정값은 실행 전에 직접 구성해야 합니다.

## 📂 주요 설정 파일

| 파일 | 역할 |
|---|---|
| `main/webapp/WEB-INF/web.xml` | Servlet 등록, URL 패턴 및 인코딩 필터 설정 |
| `main/webapp/WEB-INF/commandHandler.properties` | `*.htm` 요청과 Command Handler 매핑 |
| `main/webapp/WEB-INF/ajaxCommandHandlerURI.properties` | AJAX 요청과 Handler 매핑 |
| `ohouse.exerd` | ERD 모델 파일 |

## 💡 설계 및 구현 포인트

- **Front Controller 패턴**으로 요청 진입점을 통합하고 URL별 핸들러를 분리했습니다.
- **DAO / Service 계층 분리**로 데이터 접근과 업무 처리의 책임을 구분했습니다.
- **Properties 기반 핸들러 매핑**을 이용해 URL과 기능 구현체를 연결했습니다.
- **JDBC 트랜잭션 처리**가 필요한 변경 작업에서 커밋 및 롤백 흐름을 적용했습니다.
- 일반 회원·판매자·관리자별 기능을 분리하여 역할에 맞는 운영 흐름을 구성했습니다.

## 🗺️ 개선 및 확장 방향

- DB 연결 정보와 외부 서비스 설정의 환경 변수화
- 공통 예외 처리 및 로깅 체계 개선
- 권한별 접근 제어와 입력값 검증 강화
- 페이징·검색 조건 및 데이터 조회 성능 개선
- 테스트 코드와 배포 자동화 구성
- 결제 요청·승인·취소 과정의 예외 상황 테스트 보강

## 📎 Repository

- **GitHub:** https://github.com/hohun21/ohouse

---

<p align="center">
  Built with Java, JSP, Servlet and JDBC.
</p>
