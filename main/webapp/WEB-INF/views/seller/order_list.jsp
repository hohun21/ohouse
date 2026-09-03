<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 주문 및 배송 관리</title>
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
    
    /* 본문 영역 */
    .content-body { flex: 1; width: calc(100% - 80px); max-width: 1400px; margin: 0 auto; padding: 30px; overflow-y: auto; }
    .list-title { font-size: 20px; font-weight: bold; margin-bottom: 20px; color: #2b333b; display: flex; align-items: center; gap: 8px; }

    /* 테이블 스타일 */
    .product-table { width: 100%; background: white; border-collapse: collapse; border-radius: 12px; overflow: hidden; box-shadow: 0 3px 8px rgba(0,0,0,0.04); border: 1px solid #e1e4e6; }
    .product-table th, .product-table td { padding: 16px 15px; text-align: center; border-bottom: 1px solid #e1e4e6; font-size: 14px; vertical-align: middle; }
    .product-table th { background-color: #f8f9fa; font-weight: bold; color: #555; }
    .product-name-cell { text-align: left !important; }

    /* 💡 상태 뱃지 디자인 (1~5번 전용) */
    .badge { display: inline-block; padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: bold; }
    .badge-paid { background-color: #f1f3f5; color: #495057; border: 1px solid #ced4da; }
    .badge-ready { background-color: #fff3e0; color: #f57c00; border: 1px solid #ffcc80; }
    .badge-shipping { background-color: #e3f2fd; color: #0288d1; border: 1px solid #81d4fa; }
    .badge-delivered { background-color: #e8f5e9; color: #388e3c; border: 1px solid #a5d6a7; }
    .badge-confirm { background-color: #f3e5f5; color: #7b1fa2; border: 1px solid #ce93d8; }

    /* 💡 액션 버튼 디자인 */
    .action-btn { padding: 8px 16px; border-radius: 6px; font-size: 13px; font-weight: bold; cursor: pointer; border: none; transition: 0.2s; color: white; }
    .action-btn:hover { opacity: 0.8; transform: translateY(-1px); }
    .btn-ready { background-color: #f57c00; }
    .btn-shipping { background-color: #0288d1; }
    .btn-delivered { background-color: #388e3c; }
    .btn-confirm { background-color: #7b1fa2; }
    .text-settle { color: #00acc1; font-weight: bold; font-size: 13px; }
</style>
<script>
    function changeStatus(orderDetailId, statusName, statusCode) {
        if(confirm(statusName + " 처리하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/seller/updateDelivery.htm?orderDetailId=" + orderDetailId + "&status=" + statusCode + "&from=order";
        }
    }
</script>
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🏠 O-House Seller</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/seller/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/addForm.htm">➕ 상품 등록</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/productList.htm">📦 상품 목록 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/orderList.htm" class="active">🚚 주문 및 배송 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/claimList.htm">🔄 취소/교환/반품 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/settlementList.htm">💰 정산 관리</a></li>
            <li><a href="#">⭐ 리뷰 관리</a></li>
        </ul>
    </div>

    <!-- 우측 메인 영역 -->
    <div class="main-content">
        <div class="top-header">
            <span class="welcome-text">👋 환영합니다, <strong style="color: #35c5f0;">${sessionScope.sellerAuth.brandName}</strong> 파트너님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <div class="content-body">
            <div class="list-title">🚚 주문 및 배송 관리 내역</div>

            <table class="product-table">
                <thead>
                    <tr>
                        <th width="10%">상세번호</th>
                        <th width="15%">주문일시</th>
                        <th width="28%">상품 정보 (옵션)</th>
                        <th width="7%">수량</th>
                        <th width="12%">주문 금액</th>
                        <th width="13%">배송 상태</th>
                        <th width="15%">배송 관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty orderList}">
                            <tr>
                                <td colspan="7" style="padding: 50px 0; color: #888;">주문 내역이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${orderList}">
                                <tr>
                                    <td>${item.orderDetailId}</td>
                                    <td><fmt:formatDate value="${item.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td class="product-name-cell">
                                        <strong>${item.productName}</strong><br>
                                        <span style="font-size: 12px; color: #757575;">[옵션] ${item.optionName}</span>
                                    </td>
                                    <td>${item.quantity}개</td>
                                    <td style="font-weight: bold;">
                                        <fmt:formatNumber value="${item.price}" pattern="#,###"/>원
                                    </td>
                                    
                                    <!-- 1. 현재 배송 상태를 보여주는 뱃지 구역 (1~5 숫자 기준) -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.deliveryStatus == 1 || empty item.deliveryStatus}">
                                                <span class="badge badge-paid">결제완료</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 2}">
                                                <span class="badge badge-ready">배송준비중</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 3}">
                                                <span class="badge badge-shipping">배송중</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 4}">
                                                <span class="badge badge-delivered">배송완료</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 5}">
                                                <span class="badge badge-confirm">구매확정</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- 2. 판매자 액션 버튼 구역 (4번 배송완료까지만 제어) -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.deliveryStatus == 1 || empty item.deliveryStatus}">
                                                <button class="action-btn btn-ready" onclick="changeStatus(${item.orderDetailId}, '배송준비', 2)">배송준비 처리</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 2}">
                                                <button class="action-btn btn-shipping" onclick="changeStatus(${item.orderDetailId}, '발송', 3)">발송 처리</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 3}">
                                                <button class="action-btn btn-delivered" onclick="changeStatus(${item.orderDetailId}, '배송완료', 4)">배송완료 처리</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 4}">
                                                <span style="font-size: 12px; color: #388e3c; font-weight: bold;">구매자 확정 대기중</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 5}">
                                                <span class="text-settle">관리자 정산 대기중</span>
                                            </c:when>
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