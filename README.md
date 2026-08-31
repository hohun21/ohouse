http://localhost:8080/ohPro/shopping/category/category.htm 로 연결
http://localhost:8080/ohPro/product/productDetail.htm?product_id=3898584

--------------------------
## 현시점까지 진행한것.

[카테고리 페이지]
      ↓
[상품 목록]
      ↓
[상품 상세]
      ↓
[상품 옵션]
      ↓
[옵션 조합 조회]
      ↓
[가격/재고 확인]
--------------------------
사용자 요청
   ↓
DispatcherServlet
   ↓
Handler
   ↓
Service
   ↓
DAO(interface)
   ↓
DAOImple
   ↓
Oracle
   ↓
DTO
   ↓
Service
   ↓
Handler
   ↓
JSP / JSON
-----------------------
Oracle 계층형 쿼리를 활용하여 선택 카테고리와 하위 카테고리에 속한 상품을 통합 조회

상품 카테고리 및 상품 조회
Oracle 계층형 쿼리 START WITH / CONNECT BY를 활용한 카테고리 하위 상품 조회
상품/브랜드 테이블 JOIN을 통한 상품 기본정보 및 브랜드명 조회
상품 이미지 정보를 별도 DAO로 분리하여 대표/상세 이미지 구성
상품 상세
ProductDetailDTO를 활용하여 상품 기본정보, 이미지, 카테고리, 옵션 데이터를 통합 전달
DAO / DAOImple 분리를 통한 DB 접근 로직 캡슐화
Service 계층에서 복수 DAO 조회를 조합하여 상세페이지 데이터 구성
상품 옵션
옵션 그룹 / 옵션값을 분리 조회
ProductOption을 통해 실제 판매 가능한 옵션 조합과 가격/재고 조회
옵션 선택에 따른 AJAX 기반 실시간 상품 옵션 조회 구현

이런 식으로 "무엇을 만들었는가"보다 "어떤 기술적 문제를 어떻게 해결했는가"가 보이게 만들 수 있어.

## 디스패쳐 분석
- urlMappingPath=this.getInitParameter("urlMappingPath") -> web.xml의 init-param/param-name(urlMappingPath),param-value(/WEB-INF/commandHandler.properties)
 ㄴ commandHandler.properties 파일을 읽어서 요청url과 handler의 관계를 정의한다.

- realPath = this.getServletContext().getRealPath(urlMappingPath);
 ㄴ properties파일의 컴퓨터에서의 실제 물리 경로 ( C:/.../.../ohPro/src/main/webapp/WEB-INF/views/commandHandler.properties)

- Properties p = new Properties();
try(FileReader reader = new FileReader(realPath) ){
    p.load(reader)      // java.properties의 load함수 
}                       
// realPath(실제 properties파일의 위치)를 담은 FileReader의 reader변수를 Properties 변수 p에 properties함수 load실행할때 매개변수로 담는다 (고로, Reader를 통해 properties 형식의 텍스트를 읽어서 Properties 객체 안에 key-value 형태로 저장한다.)

// Properties p -> commandHandlerMap 저장
		Set<Entry<Object, Object>> set =  p.entrySet();
		Iterator<Entry<Object, Object>> ir = set.iterator();
		
		while (ir.hasNext()) {
         Entry<Object, Object> entry = ir.next();
         String url = (String) entry.getKey();
         String fullName = (String) entry.getValue();

- Class<?> commandHandlerClass = class.forName(fullName);

### 260820 
category.jsp 활용중

com.ohouse.common.jdbc 추가
    ㄴ JdbcUtil.java

com.ohouse.shopping 패키지 쪽추가
com.ohouse.shopping.command -> CategoryHandler
com.ohouse.shopping.dao -> CategoryDAO,CategoryDAOImple
com.ohouse.shopping.dto -> CategoryDTO
com.ohouse.shopping.service -> CategoryService

우리 dispathcerServlet 확인

CategoryHandler
       ↓
CategoryService
       ↓
CategoryDAO ← interface
       ↓
CategoryDAOImpl

boardPro 그림으로 요청(한눈에 구조파악)

프로젝트때 맡은 파트를 다른 css등 코딩없는 빈 jsp에서 하고 옮겨보기
    ㄴ 프로젝트의 큰구조와 내가맡은 구조 정확히 먼저 파악하기
    ㄴ 확장성 좋은 코딩,유지보수 용이, 약한 결합 코딩, 하드코딩x  

### 260821

대분류 [가구] 중분류 [침대] https://ohou.se/store/category?category_id=10120000
소분류 [침대프레임] = https://ohou.se/store/category?category_id=10120001
소분류 [침대+매트리스] = https://ohou.se/store/category?category_id=10120002
소분류 [침대부속가구] = https://ohou.se/store/category?category_id=10120003

대분류 [가구] 중분류 [매트리스/토퍼] https://ohou.se/store/category?category_id=10130000
소분류 [매트리스] = https://ohou.se/store/category?category_id=10130001
소분류 [토퍼] = https://ohou.se/store/category?category_id=10130002

대분류 [가구] 중분류 [테이블/식탁/책상] https://ohou.se/store/category?category_id=10150000
소분류 [거실/소파테이블] = https://ohou.se/store/category?category_id=10150001
소분류 [사이드테이블] = https://ohou.se/store/category?category_id=10150002
소분류 [식탁] = https://ohou.se/store/category?category_id=10150003
-------------------------------------------------------------------------------------------
대분류 [주방용품] 중분류 [그릇/식기] https://ohou.se/store/category?category_id=16220000
소분류 [홈세트] = https://ohou.se/store/category?category_id=16220001
소분류 [공기/대접] = https://ohou.se/store/category?category_id=16220002
소분류 [접시/플레이트] = https://ohou.se/store/category?category_id=16220003

대분류 [주방용품] 중분류 [냄비/프라이팬/솥] https://ohou.se/store/category?category_id=16230000
소분류 [냄비/프라이팬세트] = https://ohou.se/store/category?category_id=16230001
소분류 [냄비/뚝배기] = https://ohou.se/store/category?category_id=16230002
소분류 [압력솥/찜솥] = https://ohou.se/store/category?category_id=16230003

대분류 [주방용품] 중분류 [컵/잔/텀블러] https://ohou.se/store/category?category_id=16240000
소분류 [머그컵] = https://ohou.se/store/category?category_id=16240001
소분류 [유리컵/물컵] = https://ohou.se/store/category?category_id=16240002
소분류 [텀블러/빨대/컵소품] = https://ohou.se/store/category?category_id=16240003
-------------------------------------------------------------------------------------------
대분류 [수납/정리] 중분류 [서랍장/트롤리] https://ohou.se/store/category?category_id=13050000
소분류 [플라스틱서랍장] = https://ohou.se/store/category?category_id=13050002
소분류 [트롤리/이동식선반] = https://ohou.se/store/category?category_id=13050003
소분류 [공간박스] = https://ohou.se/store/category?category_id=13050004

대분류 [수납/정리] 중분류 [리빙박스/수납함] https://ohou.se/store/category?category_id=13140000
소분류 [수납박스/리빙박스] = https://ohou.se/store/category?category_id=13140006
소분류 [팬트정리함] = https://ohou.se/store/category?category_id=13140007
소분류 [약/구급정리함] = https://ohou.se/store/category?category_id=13140008

대분류 [수납/정리] 중분류 [행거] https://ohou.se/store/category?category_id=13020000
소분류 [스탠드행거] = https://ohou.se/store/category?category_id=13020002
소분류 [이동식행거] = https://ohou.se/store/category?category_id=13020003
소분류 [고정식행거] = https://ohou.se/store/category?category_id=13020004

- jquery스크립트 header에 추가

### 260824

소분류 클릭 → GET으로 category_id 전달 → category.htm 재요청 → 좌측 사이드바에서 클릭한 소분류만 포커스 표시

오른쪽 상품 영역은 아직 구현하지 않음.

현재 중분류 ex 가구 -> 침대 누르면 소분류 옵션이 열릴뿐 침대중분류 세팅으로 get 파라미터 넘어오며 url변하지않는다.
고로, 중분류를 눌를때 소분류옵션이 닫혀있었으면 중분류 옵션이 뿌려질 페이지가 뜨며 열리고 다시눌렀을땐 소분류옵션이 닫히지않고 해당중분류 페이지만 새로고침된다. 열리고나면 화살표 눌렀을때만 다시 소분류옵션을 닫을 수 있다.
    + 중분류, 소분류 포커스
- 처리 완료.

### 260825

DB 오기전 가능한 작업

Body HTML/CSS 골격 잡기,
우측 Body의 상품 카드 모양과 배치부터 잡아놓기

DAO/Service 상품 조회까지 연결

------------------------------------------
header.jsp CSS수정
category.jsp CSS수정

FK관계에 맞게 insert순서 준비된 DBdump.txt

화면에 뿌려질 정보중 상품상세이미지아래에 별점,리뷰 가있는데 아직 테이블없음.

기존 ohouse(멤버,카트,카트아이템).exerd -> 멤버,쿠폰,카트 추가


### 260825
패키지 폴더, 파일명 통일.



해야되는것 : product_detail.jsp의 프론트 db연결

상세 보기 페이지에서 가구 > 침대 > 침대프레임 이 각개 분류 이름이라 클릭하면 각 분류로 이동하는 링크설정
 <div class="breadcrumb">
        <c:forEach var="category" items="${pdto.categoryDTOList}" varStatus="s">
            <button class="link-category" data-category_id="${category.category_id}">
                <span>${category.category_name}</span>
            </button>
            <c:if test="${!s.last}">
                <span>›</span>
            </c:if>
        </c:forEach>
    </div>

    <!-- 브레드크럼 (경로) -->
    <div class="breadcrumb">
        가구 <span class="arrow">❯</span> 침대 <span class="arrow">❯</span> 침대프레임
    </div>

### 260826
추가옵션 중복 메세지 오류 등 처리중.

### 260827
현재 상세페이지 옵션선택 이슈
{추가옵션상품을 여러 종류로 넣을때 이미 필수상품 선택했는데 필수옵션을 선택하세요. 뜨고있다. 홈페이지는 아무메세지뜨지않고 추가됨. 그리고 같은 추가옵션상품을 또 눌렀을때도 같은 메세지가 뜬다. 수량이 늘어나진않고. 홈페이지에선 이미 선택된 옵션입니다. 라고 뜨는데}

할인율 0.0% 문제

-가구
오늘의집 Only
DB 침대
DB 매트리스/토퍼
DB 테이블/식탁/책상
소파
서랍/수납장
거실장/TV장
선반
진열장/책장
의자
행거/옷장
거울
화장대/콘솔
유아동가구
야외가구
가벽/파티션
공간별가구

-주방용품
오늘의집 Only
O!PLATING
DB 그릇/식기
DB 냄비/프라이팬/솥
DB 컵/잔/텀블러
수저/커트러리
주방수납/정리
식기건조대
보관/용기/도시락
주방잡화
조리도구
칼/도마/커팅기구
주방패브릭
주방일회용품
커피/티용품
와인/칵테일용품

-수납/정리
오늘의집 Only
DB 서랍장/트롤리
DB 리빙박스/수납함
DB 빨래바구니/햄퍼
행거
선반
옷걸이
옷정리/이불정리
화장대/테이블정리
현관/신발정리
후크/수납걸이
공간별수납정리

### 260828

DB 최종본으로 교체
다인서트후 최종 commit필수

상세에서 ex 가구>침대>침대프레임 쪽중 하나누르면 해당카테고리 이동후 최초 category페이지처럼 파란불 들어오게
