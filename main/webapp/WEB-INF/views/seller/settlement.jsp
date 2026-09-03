<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 정산 관리</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f7f9fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
    
    /* 좌측 사이드바 영역 */
    .sidebar { width: 240px; background-color: #2b333b; color: white; display: flex; flex-direction: column; flex-shrink: 0; }
    .sidebar-brand { padding: 20px; font-size: 18px; font-weight: bold; background-color: #1e242b; text-align: center; }
    .sidebar-menu { list-style: none; padding: 20px 0; }
    .sidebar-menu li a { display: block; padding: 12px 20px; color: #b0c4de; text-decoration: none; font-size: 14px; transition: 0.2s; }
    .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #35c5f0; color: white; }
    
    /* 우측 메인 콘텐츠 영역 */
    .main-content { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; }
    .top-header { height: 60px; background-color: white; border-bottom: 1px solid #e1e4e6; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; flex-shrink: 0; }
    .top-header .welcome-text { font-size: 15px; font-weight: bold; }
    
    /* 본문 영역 */
    .content-body {
        flex: 1;
        width: calc(100% - 80px);
        max-width: 1400px;
        margin: 0 auto;
        padding: 30px;
        overflow-y: auto;
    }

    .list-title { font-size: 20px; font-weight: bold; margin-bottom: 20px; color: #2b333b; }

    /* 정산 요약 카드 구조 */
    .summary-card-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
    
    .summary-card { 
        background: white; 
        padding: 30px 35px; 
        border-radius: 14px; 
        border: 1px solid #e1e4e6; 
        box-shadow: 0 3px 8px rgba(0,0,0,0.04); 
        display: flex; 
        align-items: center; 
        justify-content: space-between; 
        min-height: 140px;
    }
    
    .summary-info { display: flex; flex-direction: column; gap: 8px; }
    .summary-title { font-size: 15px; color: #757575; font-weight: bold; }
    .summary-value { font-size: 28px; font-weight: bold; color: #2f3438; }
    .summary-icon-box { width: 55px; height: 55px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 15px; }

    /* 테이블 스타일 */
    .product-table { width: 100%; background: white; border-collapse: collapse; border-radius: 12px; overflow: hidden; box-shadow: 0 3px 8px rgba(0,0,0,0.04); border: 1px solid #e1e4e6; }
    .product-table th, .product-table td { padding: 18px 15px; text-align: center; border-bottom: 1px solid #e1e4e6; font-size: 14px; }
    .product-table th { background-color: #f8f9fa; font-weight: bold; color: #555; }
    .product-name-cell { text-align: left !important; }
    
    /* 상태 뱃지 (12번 정산완료 전용) */
    .badge { display: inline-block; padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: bold; }
    .badge-complete { background-color: #e8f5e9; color: #388e3c; border: 1px solid #a5d6a7; }
</style>
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🏠 O-House Seller</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/seller/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/addForm.htm">➕ 상품 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/productList.htm">📦 상품 목록 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/orderList.htm">🚚 주문 및 배송 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/claimList.htm">🔄 취소/교환/반품 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/settlementList.htm" class="active">💰 정산 관리</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="top-header">
            <span class="welcome-text">👋 환영합니다, <strong style="color: #35c5f0;">${sessionScope.sellerAuth.brandName}</strong> 파트너님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <div class="content-body">
            <div class="list-title">💰 매출 및 정산 상세 관리</div>

            <div class="summary-card-container">
                <div class="summary-card">
                    <div class="summary-info">
                        <span class="summary-title">총 판매 금액 (정산완료 기준)</span>
                        <span class="summary-value">
                            <fmt:formatNumber value="${empty totalSales ? 0 : totalSales}" pattern="#,###"/>원
                        </span>
                    </div>
                    <div class="summary-icon-box" style="background-color: #f4f6f8; color: #333;">총액</div>
                </div>

                <div class="summary-card">
                    <div class="summary-info">
                        <span class="summary-title">플랫폼 수수료 (2%)</span>
                        <span class="summary-value" style="color: #e53935;">
                            -<fmt:formatNumber value="${empty totalCommission ? 0 : totalCommission}" pattern="#,###"/>원
                        </span>
                    </div>
                    <div class="summary-icon-box" style="background-color: #ffebee; color: #e53935;">수수료</div>
                </div>

                <div class="summary-card">
                    <div class="summary-info">
                        <span class="summary-title">최종 정산 완료 금액</span>
                        <span class="summary-value" style="color: #00acc1;">
                            <fmt:formatNumber value="${empty finalSettlement ? 0 : finalSettlement}" pattern="#,###"/>원
                        </span>
                    </div>
                    <div class="summary-icon-box" style="background-color: #e0f7fa; color: #00acc1;">정산</div>
                </div>
            </div>
            
            <table class="product-table">
                <thead>
                    <tr>
                        <th width="12%">주문상세번호</th>
                        <th width="15%">주문일시</th>
                        <th width="30%">상품 정보 (옵션)</th>
                        <th width="12%">주문 금액</th>
                        <th width="10%">수수료 (2%)</th>
                        <th width="12%">정산 금액</th>
                        <th width="9%">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty settlementList}">
                            <tr>
                                <td colspan="7" style="padding: 60px 0; color: #888; font-size: 15px;">정산 완료된 내역이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${settlementList}">
                                <tr>
                                    <td>${item.orderDetailId}</td>
                                    <td><fmt:formatDate value="${item.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td class="product-name-cell">
                                        <strong>${item.productName}</strong><br>
                                        <span style="font-size: 12px; color: #757575;">[옵션] ${item.optionName}</span>
                                    </td>
                                    <td style="font-weight: bold;">
                                        <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>원
                                    </td>
                                    <td style="color: #e53935;">
                                        -<fmt:formatNumber value="${(item.price * item.quantity) * 0.02}" pattern="#,###"/>원
                                    </td>
                                    <td style="font-weight: bold; color: #00acc1;">
                                        <fmt:formatNumber value="${(item.price * item.quantity) * 0.98}" pattern="#,###"/>원
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.deliveryStatus == 12}">
                                                <span class="badge badge-complete">정산완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge" style="background:#f1f3f5; color:#495057;">상태확인</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>