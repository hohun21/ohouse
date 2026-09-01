<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 - 오늘의집</title>
<style>
    /* 기본 리셋 및 폰트 */
    body { margin: 0; padding: 0; font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif; background-color: #fff; color: #292929; }
    a { text-decoration: none; color: inherit; }
    ul { list-style: none; padding: 0; margin: 0; }
    
    /* 상단 네비게이션 탭 (프로필, 나의 쇼핑 등) */
    .top-nav { display: flex; justify-content: center; border-bottom: 1px solid #ededed; padding: 15px 0; }
    .top-nav a { margin: 0 15px; font-size: 16px; font-weight: bold; color: #424242; }
    .top-nav a.active { color: #35c5f0; }

    /* 서브 네비게이션 탭 (모두보기, 사진 등) */
    .sub-nav { display: flex; justify-content: center; border-bottom: 1px solid #ededed; padding: 15px 0; margin-bottom: 40px; }
    .sub-nav a { margin: 0 15px; font-size: 15px; font-weight: bold; color: #757575; position: relative; padding-bottom: 15px; transition: color 0.2s ease; }
    .sub-nav a:hover { color: #35c5f0; }
    .sub-nav a.active { color: #35c5f0; }
    .sub-nav a.active::after { content: ""; position: absolute; bottom: 0; left: 0; width: 100%; height: 3px; background-color: #35c5f0; }

    /* 메인 레이아웃 (좌측 프로필, 우측 컨텐츠) */
    .mypage-layout { max-width: 1136px; margin: 0 auto; display: flex; gap: 30px; padding: 0 20px 100px 20px; }
    
    /* 좌측 프로필 카드 */
    .profile-sidebar { width: 280px; flex-shrink: 0; }
    .profile-card { border: 1px solid #dbdbdb; border-radius: 4px; padding: 30px 20px; text-align: center; position: relative; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
    .share-icon { position: absolute; top: 15px; right: 15px; width: 24px; height: 24px; cursor: pointer; color: #757575; }
    
    /* 프로필 이미지 */
    .profile-img { width: 120px; height: 120px; background-color: #dbdbdb; border-radius: 50%; margin: 0 auto 20px; display: flex; align-items: center; justify-content: center; font-size: 40px; color: white; }
    .profile-name { font-size: 22px; font-weight: bold; margin-bottom: 5px; }
    .profile-stats { font-size: 13px; color: #757575; margin-bottom: 15px; }
    .profile-setting-btn { display: inline-block; padding: 6px 12px; border: 1px solid #dbdbdb; border-radius: 4px; font-size: 13px; color: #424242; font-weight: bold; }
    
    /* 프로필 하단 요약 (스크랩북, 좋아요, 내쿠폰) */
    .profile-summary { display: flex; justify-content: space-around; border-top: 1px solid #ededed; border-bottom: 1px solid #ededed; padding: 20px 0; margin: 25px 0; }
    .summary-item { text-align: center; font-size: 13px; color: #424242; display: flex; flex-direction: column; gap: 8px; font-weight: bold; }
    .summary-item span { font-size: 16px; }
    
    /* 활동 대시보드 버튼 스타일 (링크용) */
    .dashboard-btn { display: block; width: 100%; padding: 12px 0; border: 1px solid #dbdbdb; border-radius: 4px; font-size: 14px; font-weight: bold; color: #424242; background: white; cursor: pointer; text-align: center; box-sizing: border-box; text-decoration: none; }
    .dashboard-btn:hover { background-color: #f7f9fa; }

    /* 우측 컨텐츠 영역 */
    .content-area { flex: 1; }
    .content-section { margin-bottom: 40px; }
    .content-title { font-size: 18px; font-weight: bold; color: #292929; margin-bottom: 15px; display: flex; align-items: center; }
    .content-title span { color: #35c5f0; margin-left: 5px; }
    
    /* 점선 빈 화면 박스 */
    .empty-box { border: 1px dashed #dbdbdb; background-color: #fafafa; height: 160px; display: flex; align-items: center; justify-content: center; color: #757575; font-size: 15px; border-radius: 4px; cursor: pointer; transition: background 0.2s; }
    .empty-box:hover { background-color: #f5f5f5; }
    
    /* 배지 */
    .role-badge { display: inline-block; padding: 4px 8px; border-radius: 4px; color: white; font-size: 12px; margin-bottom: 10px; }
    .badge-admin { background-color: #ff4d4f; }
    .badge-seller { background-color: #35c5f0; }
</style>
</head>
<body>

<!-- 헤더 Include -->
<jsp:include page="/WEB-INF/views/layout/header.jsp">
  <jsp:param name="showSubHeaderAtTop" value="false"/>
</jsp:include>

<div class="top-nav">
    <a href="#" class="active">프로필</a>
    <a href="#">나의 쇼핑</a>
    <a href="#">나의 리뷰</a>
    <!-- 💡 수정 1: 상단 설정 버튼 경로 연결 -->
    <a href="${pageContext.request.contextPath}/changePwd.htm">설정</a>
</div>
<div class="sub-nav">
    <a href="#" class="active">모두보기</a>
    <a href="#">사진</a>
    <a href="#">집들이</a>
    <a href="#">노하우</a>
    <a href="#">스크랩북</a>
    <a href="#">좋아요</a>
</div>

<div class="mypage-layout">
    
    <!-- [좌측] 프로필 카드 -->
    <div class="profile-sidebar">
        <div class="profile-card">
            <div class="share-icon">🔗</div>
            
            <div class="profile-img">
                :-)
            </div>
            
            <c:if test="${not empty sessionScope.authUser and sessionScope.authUser.role == 'ADMIN'}">
                <span class="role-badge badge-admin">관리자</span>
            </c:if>
            <c:if test="${not empty sessionScope.sellerAuth}">
                <span class="role-badge badge-seller">판매자</span>
            </c:if>
            
            <div class="profile-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.authUser}">${sessionScope.authUser.name}</c:when>
                    <c:when test="${not empty sessionScope.sellerAuth}">${sessionScope.sellerAuth.brandName}</c:when>
                    <c:otherwise>default</c:otherwise>
                </c:choose>
            </div>
            
            <div class="profile-stats">팔로워 0 | 오감지수 0</div>
            <a href="${pageContext.request.contextPath}/changePwd.htm" class="profile-setting-btn">설정</a>
            
            <div class="profile-summary">
                <div class="summary-item">스크랩북<span>2</span></div>
                <div class="summary-item">좋아요<span>0</span></div>
                <div class="summary-item">내 쿠폰<span>0</span></div>
            </div>

            <c:choose>
                <c:when test="${not empty sessionScope.authUser and sessionScope.authUser.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard.htm" class="dashboard-btn">
                        활동 대시보드
                    </a>
                </c:when>
                
                <c:when test="${not empty sessionScope.sellerAuth}">
                    <a href="${pageContext.request.contextPath}/seller/dashboard.htm" class="dashboard-btn">
                        활동 대시보드
                    </a>
                </c:when>
                
                <c:otherwise>
                    <button type="button" class="dashboard-btn" onclick="alert('일반 회원용 대시보드는 준비 중입니다.');" style="color: #888;">
                        활동 대시보드
                    </button>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
    
    <div class="content-area">
        
        <div class="content-section">
            <div class="content-title">사진 <span>0</span></div>
            <div class="empty-box">
                + 첫 번째 사진을 올려보세요
            </div>
        </div>
        
        <div class="content-section">
            <div class="content-title">집들이 <span>0</span></div>
            <div class="empty-box">
                + 첫 번째 집들이를 올려보세요
            </div>
        </div>
        
    </div>
</div>

<jsp:include page="../layout/footer.jsp" />

</body>
</html>