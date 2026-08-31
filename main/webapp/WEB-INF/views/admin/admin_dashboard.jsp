<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 센터 - 대시보드</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f7f9fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
    
    /* 관리자 사이드바 스타일 */
    .sidebar { width: 240px; background-color: #2b333b; color: white; display: flex; flex-direction: column; }
    .sidebar-brand { padding: 20px; font-size: 18px; font-weight: bold; background-color: #1e242b; text-align: center; }
    .sidebar-menu { list-style: none; padding: 20px 0; }
    .sidebar-menu li a { display: block; padding: 12px 20px; color: #b0c4de; text-decoration: none; font-size: 14px; transition: 0.2s; }
    .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #ff4d4f; color: white; }
    
    .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
    .top-header { height: 60px; background-color: white; border-bottom: 1px solid #e1e4e6; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; }
    
    .dashboard-body { padding: 30px; display: flex; flex-direction: column; gap: 25px; }
    
    /* 관리 메뉴 카드 그리드 스타일 */
    .menu-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
    .menu-card { background: white; border-radius: 8px; padding: 30px; border: 1px solid #e1e4e6; text-decoration: none; color: #333; box-shadow: 0 2px 4px rgba(0,0,0,0.04); transition: 0.2s; display: flex; flex-direction: column; gap: 10px; }
    .menu-card:hover { transform: translateY(-3px); box-shadow: 0 4px 12px rgba(0,0,0,0.08); border-color: #ff4d4f; }
    .menu-card-icon { font-size: 28px; }
    .menu-card-title { font-size: 18px; font-weight: bold; color: #111; }
    .menu-card-desc { font-size: 13px; color: #666; line-height: 1.4; }
</style>
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🛡️ O-House Admin</div>
        <ul class="sidebar-menu">
            <li><a href="#" class="active">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/memberList.htm">👥 전체 일반회원 조회</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/sellerList.htm">🤝 전체 판매자 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/productList.htm">📦 전체 상품 관리</a></li>
        </ul>
    </div>

    <!-- 우측 메인 영역 -->
    <div class="main-content">
        <div class="top-header">
            <span style="font-weight: bold;">👋 환영합니다, <strong style="color: #ff4d4f;">관리자</strong>님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <div class="dashboard-body">
            <h2 style="font-size: 20px; font-weight: bold; color: #2b333b;">⚙️ 시스템 관리 바로가기</h2>
            
            <div class="menu-grid">
                <a href="${pageContext.request.contextPath}/admin/memberList.htm" class="menu-card">
                    <div class="menu-card-icon">👥</div>
                    <div class="menu-card-title">전체 일반회원 조회</div>
                    <div class="menu-card-desc">가입된 일반 회원 목록을 확인하고 관리할 수 있습니다.</div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/sellerList.htm" class="menu-card">
                    <div class="menu-card-icon">🤝</div>
                    <div class="menu-card-title">전체 판매자 관리</div>
                    <div class="menu-card-desc">입점 대기 중인 판매자 승인 및 전체 판매자를 관리합니다.</div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/productList.htm" class="menu-card">
                    <div class="menu-card-icon">📦</div>
                    <div class="menu-card-title">전체 상품 관리</div>
                    <div class="menu-card-desc">플랫폼에 등록된 모든 상품을 모니터링하고 제재할 수 있습니다.</div>
                </a>
            </div>
        </div>
    </div>

</body>
</html>