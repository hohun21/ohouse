<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 대시보드</title>
<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    body {
        font-family: 'Malgun Gothic', sans-serif;
        background-color: #f7f9fa;
        color: #333;
        display: flex;
        height: 100vh;
        overflow: hidden;
    }

    /* 좌측 사이드바 영역 (기본 레이아웃용) */
    .sidebar {
        width: 240px;
        background-color: #2b333b;
        color: white;
        display: flex;
        flex-direction: column;
    }
    .sidebar-brand {
        padding: 20px;
        font-size: 18px;
        font-weight: bold;
        background-color: #1e242b;
        text-align: center;
    }
    .sidebar-menu {
        list-style: none;
        padding: 20px 0;
    }
    .sidebar-menu li a {
        display: block;
        padding: 12px 20px;
        color: #b0c4de;
        text-decoration: none;
        font-size: 14px;
        transition: 0.2s;
    }
    .sidebar-menu li a:hover, .sidebar-menu li a.active {
        background-color: #35c5f0;
        color: white;
    }

    /* 우측 메인 콘텐츠 영역 */
    .main-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
    }
    .top-header {
        height: 60px;
        background-color: white;
        border-bottom: 1px solid #e1e4e6;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
    }
    .top-header .welcome-text {
        font-size: 15px;
        font-weight: bold;
    }

    /* 대시보드 바디 컨테이너 */
    .dashboard-body {
        padding: 30px;
        display: flex;
        flex-direction: column;
        gap: 25px;
    }

    /* 섹션 공통 스타일 */
    .section-card {
        background: white;
        border-radius: 8px;
        padding: 20px 25px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.04);
        border: 1px solid #e1e4e6;
    }
    .section-title {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 15px;
        color: #2b333b;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* 1. 상단 상품 상태 요약 카드 (네이버 스토어 스타일) */
    .summary-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 15px;
    }
    .summary-item {
        background-color: #f8f9fa;
        border: 1px solid #e9ecef;
        border-radius: 6px;
        padding: 20px;
        display: flex;
        align-items: center;
        gap: 15px;
    }
    .summary-icon {
        width: 45px;
        height: 45px;
        background-color: #e3f2fd;
        color: #009fce;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 18px;
    }
    .summary-info {
        display: flex;
        flex-direction: column;
    }
    .summary-label {
        font-size: 13px;
        color: #666;
        margin-bottom: 4px;
    }
    .summary-count {
        font-size: 20px;
        font-weight: bold;
        color: #111;
    }
    .summary-count small {
        font-size: 13px;
        font-weight: normal;
        color: #888;
    }

    /* 빠른 메뉴 버튼 영역 */
    .quick-actions {
        display: flex;
        gap: 15px;
    }
    .btn-action {
        flex: 1;
        padding: 15px;
        background-color: #35c5f0;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        font-weight: bold;
        cursor: pointer;
        text-align: center;
        text-decoration: none;
        transition: 0.2s;
    }
    .btn-action:hover {
        background-color: #009fce;
    }
    .btn-action.sub {
        background-color: #f0f2f5;
        color: #333;
        border: 1px solid #d1d5db;
    }
    .btn-action.sub:hover {
        background-color: #e4e7eb;
    }
</style>
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🏠 O-House Seller</div>
        <ul class="sidebar-menu">
            <li><a href="#" class="active">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/addForm.htm">➕ 상품 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/productList.htm">📦 상품 목록 관리</a></li>
            <li><a href="#">💰 정산 관리</a></li>
            <li><a href="#">⭐ 리뷰 관리</a></li>
        </ul>
    </div>

    <!-- 우측 메인 영역 -->
    <div class="main-content">
        <!-- 상단 헤더 -->
        <div class="top-header">
            <span class="welcome-text">👋 환영합니다, <strong style="color: #35c5f0;">${sessionScope.sellerAuth.brandName}</strong> 파트너님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <!-- 본문 내용 -->
        <div class="dashboard-body">

            <!-- 빠른 실행 버튼 -->
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/seller/addForm.htm" class="btn-action">➕ 새 상품 등록하기</a>
                <a href="${pageContext.request.contextPath}/seller/productList.htm" class="btn-action sub">📦 상품 목록 및 재고 관리</a>
            </div>

            <!-- 상품 현황 요약 카드 섹션 -->
            <div class="section-card">
                <div class="section-title">📦 상품 관리 현황</div>
                
                <div class="summary-grid">
                    <!-- 전체 상품 -->
                    <div class="summary-item">
                        <div class="summary-icon">전</div>
                        <div class="summary-info">
                            <span class="summary-label">전체 상품</span>
                            <span class="summary-count">${not empty stats.totalCount ? stats.totalCount : 0} <small>건</small></span>
                        </div>
                    </div>

                    <!-- 판매중 -->
                    <div class="summary-item">
                        <div class="summary-icon" style="background-color: #e1f5fe; color: #0288d1;">판</div>
                        <div class="summary-info">
                            <span class="summary-label">판매중</span>
                            <span class="summary-count" style="color: #0288d1;">${not empty stats.onSaleCount ? stats.onSaleCount : 0} <small>건</small></span>
                        </div>
                    </div>

                    <!-- 품절 -->
                    <div class="summary-item">
                        <div class="summary-icon" style="background-color: #ffebee; color: #c62828;">품</div>
                        <div class="summary-info">
                            <span class="summary-label">품절 (재고 0)</span>
                            <span class="summary-count" style="color: #c62828;">${not empty stats.soldOutCount ? stats.soldOutCount : 0} <small>건</small></span>
                        </div>
                    </div>

                    <!-- 판매중지 -->
                    <div class="summary-item">
                        <div class="summary-icon" style="background-color: #f1f3f5; color: #495057;">중</div>
                        <div class="summary-info">
                            <span class="summary-label">판매중지</span>
                            <span class="summary-count" style="color: #495057;">${not empty stats.stopCount ? stats.stopCount : 0} <small>건</small></span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 추가 주문/정산 영역 (추후 연동용 뼈대) -->
            <div class="section-card">
                <div class="section-title">🛒 주문 및 배송 현황</div>
                <p style="font-size: 13px; color: #888;">주문 및 결제 파트 팀원과 데이터를 연동할 영역입니다.</p>
            </div>

        </div>
    </div>

</body>
</html>