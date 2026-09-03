<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 대시보드 홈</title>
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

    /* 좌측 사이드바 영역 */
    .sidebar {
        width: 240px;
        background-color: #2b333b;
        color: white;
        display: flex;
        flex-direction: column;
        flex-shrink: 0;
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
        height: 100vh;
        overflow: hidden;
    }
    .top-header {
        height: 60px;
        background-color: white;
        border-bottom: 1px solid #e1e4e6;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        flex-shrink: 0;
    }
    .top-header .welcome-text {
        font-size: 15px;
        font-weight: bold;
    }

    /* 대시보드 본문 레이아웃 */
    .dashboard-body {
        flex: 1;
        width: calc(100% - 80px);
        max-width: 1400px;
        margin: 0 auto;
        padding: 30px;
        overflow-y: auto;
    }

    /* 상단 정산 카드 그리드 */
    .top-settlement-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 30px;
        margin-bottom: 30px;
    }

    /* 상단 정산 카드 디자인 */
    .settlement-card {
        background: #fff;
        border: 1px solid #e6e6e6;
        border-radius: 16px;
        min-height: 280px;
        padding: 35px 40px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        box-shadow: 0 3px 10px rgba(0,0,0,.04);
        transition: .2s;
        position: relative;
        overflow: hidden;
        text-decoration: none;
        color: inherit;
    }

    .settlement-card.sales { border-left: 6px solid #35c5f0; }
    .settlement-card.settle { border-left: 6px solid #00acc1; }

    .settlement-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 22px rgba(0,0,0,.08);
    }

    .card-top {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }

    .settlement-label {
        font-size: 18px;
        font-weight: bold;
        color: #555;
    }

    .card-icon { font-size: 28px; }

    .settlement-value {
        font-size: 42px;
        font-weight: 700;
        color: #111;
        margin: 10px 0;
    }

    .card-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 13px;
        color: #888;
        border-top: 1px solid #f0f0f0;
        padding-top: 15px;
    }

    .card-link {
        font-weight: bold;
    }

    /* 아래 섹션 카드 스타일 통일 */
    .section-card {
        margin-bottom: 30px;
        background: #fff;
        border-radius: 16px;
        padding: 30px;
        border: 1px solid #e5e5e5;
        box-shadow: 0 3px 8px rgba(0,0,0,.05);
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .section-title {
        font-size: 18px;
        font-weight: bold;
        color: #2b333b;
        border-bottom: 1px solid #f0f0f0;
        padding-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* 하단 통계 그리드 (4열 인터랙티브 카드형) */
    .stat-grid-4 {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 15px;
    }

    .stat-card {
        background-color: #fff;
        border: 1px solid #e6e6e6;
        border-radius: 12px;
        padding: 20px;
        display: flex;
        align-items: center;
        gap: 16px;
        box-shadow: 0 2px 6px rgba(0,0,0,.03);
        transition: .2s;
        text-decoration: none;
        color: inherit;
    }

    .stat-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(0,0,0,.07);
        border-color: #35c5f0;
    }

    .stat-icon-box {
        width: 48px;
        height: 48px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        font-weight: bold;
        flex-shrink: 0;
    }

    .stat-content {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }

    .stat-label {
        font-size: 13px;
        color: #666;
        font-weight: 600;
    }

    .stat-num {
        font-size: 20px;
        font-weight: 700;
        color: #111;
    }
    .stat-num small {
        font-size: 13px;
        font-weight: normal;
        color: #888;
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
            <li><a href="${pageContext.request.contextPath}/seller/orderList.htm">🚚 주문 및 배송 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/claimList.htm">🔄 취소/교환/반품 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/settlementList.htm">💰 정산 관리</a></li>
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

            <!-- [1단] 상단 세련된 포인트 정산 카드 2개 -->
            <div class="top-settlement-grid">
                <a href="${pageContext.request.contextPath}/seller/settlementList.htm" class="settlement-card sales">
                    <div class="card-top">
                        <span class="settlement-label">총 판매 금액 (구매확정 기준)</span>
                        <span class="card-icon">💳</span>
                    </div>
                    <div class="settlement-value">
                        <fmt:formatNumber value="${empty stats.totalSales ? 0 : stats.totalSales}" pattern="#,###"/>원
                    </div>
                    <div class="card-footer">
                        <span>상세 정산 내역 확인하기</span>
                        <span class="card-link" style="color: #35c5f0;">바로가기 &rarr;</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/seller/settlementList.htm" class="settlement-card settle">
                    <div class="card-top">
                        <span class="settlement-label">최종 정산 예정 금액</span>
                        <span class="card-icon">💰</span>
                    </div>
                    <div class="settlement-value" style="color: #00acc1;">
                        <fmt:formatNumber value="${empty stats.finalSettlement ? 0 : stats.finalSettlement}" pattern="#,###"/>원
                    </div>
                    <div class="card-footer">
                        <span>지급 예정일 안내</span>
                        <span class="card-link" style="color: #00acc1;">바로가기 &rarr;</span>
                    </div>
                </a>
            </div>

            <!-- [2단] 상품 관리 현황 (입체감 있는 카드 형태로 변경) -->
            <div class="section-card">
                <div class="section-title">📦 상품 관리 현황</div>
                <div class="stat-grid-4">
                    <a href="${pageContext.request.contextPath}/seller/productList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #f1f3f5; color: #495057;">전체</div>
                        <div class="stat-content">
                            <span class="stat-label">등록 상품</span>
                            <span class="stat-num">${not empty stats.totalCount ? stats.totalCount : 0} <small>건</small></span>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/productList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #e1f5fe; color: #0288d1;">판매</div>
                        <div class="stat-content">
                            <span class="stat-label">판매중</span>
                            <span class="stat-num" style="color: #0288d1;">${not empty stats.onSaleCount ? stats.onSaleCount : 0} <small>건</small></span>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/productList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #ffebee; color: #c62828;">품절</div>
                        <div class="stat-content">
                            <span class="stat-label">품절 (재고0)</span>
                            <span class="stat-num" style="color: #c62828;">${not empty stats.soldOutCount ? stats.soldOutCount : 0} <small>건</small></span>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/productList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #f8f9fa; color: #868e96;">중지</div>
                        <div class="stat-content">
                            <span class="stat-label">판매중지</span>
                            <span class="stat-num" style="color: #868e96;">${not empty stats.stopCount ? stats.stopCount : 0} <small>건</small></span>
                        </div>
                    </a>
                </div>
            </div>

            <!-- [3단] 주문 및 배송 현황 (입체감 있는 카드 형태로 변경) -->
            <div class="section-card">
                <div class="section-title">🚚 주문 및 배송 현황 요약</div>
                <div class="stat-grid-4">
                    <a href="${pageContext.request.contextPath}/seller/orderList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #fff3e0; color: #f57c00;">준비</div>
                        <div class="stat-content">
                            <span class="stat-label">상품준비중</span>
                            <span class="stat-num" style="color: #f57c00;">${not empty stats.readyCount ? stats.readyCount : 0} <small>건</small></span>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/orderList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #e3f2fd; color: #0288d1;">배송</div>
                        <div class="stat-content">
                            <span class="stat-label">배송중</span>
                            <span class="stat-num" style="color: #0288d1;">${not empty stats.shippingCount ? stats.shippingCount : 0} <small>건</small></span>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/orderList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #e8f5e9; color: #388e3c;">완료</div>
                        <div class="stat-content">
                            <span class="stat-label">배송완료</span>
                            <span class="stat-num" style="color: #388e3c;">${not empty stats.deliveredCount ? stats.deliveredCount : 0} <small>건</small></span>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/seller/orderList.htm" class="stat-card">
                        <div class="stat-icon-box" style="background-color: #f3e5f5; color: #7b1fa2;">확정</div>
                        <div class="stat-content">
                            <span class="stat-label">구매확정</span>
                            <span class="stat-num" style="color: #7b1fa2;">${not empty stats.confirmedCount ? stats.confirmedCount : 0} <small>건</small></span>
                        </div>
                    </a>
                </div>
            </div>

        </div>
    </div>

</body>
</html>