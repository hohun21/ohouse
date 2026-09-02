<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 취소 및 반품 관리</title>
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

    /* 💡 상태별 뱃지 디자인 */
    .badge { display: inline-block; padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: bold; }
    .badge-cancel-req { background-color: #ffe3e3; color: #c92a2a; border: 1px solid #ffc9c9; }
    .badge-cancel-complete { background-color: #f1f3f5; color: #495057; border: 1px solid #ced4da; }
    .badge-return-req { background-color: #fff3e0; color: #e65100; border: 1px solid #ffe0b2; }
    .badge-return-approve { background-color: #e3f2fd; color: #0288d1; border: 1px solid #bbdefb; }
    .badge-return-shipping { background-color: #f3e5f5; color: #7b1fa2; border: 1px solid #e1bee7; }
    .badge-return-complete { background-color: #e8f5e9; color: #388e3c; border: 1px solid #a5d6a7; }

    /* 💡 액션 버튼 디자인 */
    .action-btn { padding: 8px 14px; border-radius: 6px; font-size: 13px; font-weight: bold; cursor: pointer; border: none; transition: 0.2s; color: white; }
    .action-btn:hover { opacity: 0.8; transform: translateY(-1px); }
    .btn-red { background-color: #c92a2a; }   /* 취소 완료 처리 */
    .btn-orange { background-color: #f57c00; } /* 반품 승인 처리 */
    .btn-blue { background-color: #0288d1; }   /* 수거중 처리 */
    .btn-purple { background-color: #7b1fa2; }  /* 반품 완료 처리 */
</style>
<script>
    function processClaim(orderDetailId, actionName, nextStatusCode) {
        if(confirm("해당 주문 건에 대해 [" + actionName + "] 처리를 진행하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/seller/updateDelivery.htm?orderDetailId=" + orderDetailId + "&status=" + nextStatusCode + "&from=claim";
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
            <li><a href="${pageContext.request.contextPath}/seller/orderList.htm">🚚 주문 및 배송 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/claimList.htm" class="active">🔄 취소/반품 관리</a></li>
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
            <div class="list-title">🔄 취소 및 반품 요청 관리 내역</div>

            <table class="product-table">
                <thead>
                    <tr>
                        <th width="10%">상세번호</th>
                        <th width="15%">주문일시</th>
                        <th width="28%">상품 정보 (옵션)</th>
                        <th width="7%">수량</th>
                        <th width="12%">주문 금액</th>
                        <th width="13%">클레임 상태</th>
                        <th width="15%">처리 관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty claimList}">
                            <tr>
                                <td colspan="7" style="padding: 50px 0; color: #888;">접수된 취소 및 반품 요청 내역이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${claimList}">
                                <tr>
                                    <td>${item.orderDetailId}</td>
                                    <td><fmt:formatDate value="${item.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td class="product-name-cell">
                                        <strong>${item.productName}</strong><br>
                                        <span style="font-size: 12px; color: #757575;">[옵션] ${item.optionName}</span>
                                    </td>
                                    <td>${item.quantity}개</td>
                                    <td style="font-weight: bold;">
                                        <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>원
                                    </td>
                                    
                                    <!-- 1. 상태별 뱃지 표현 (6, 7, 8, 9, 10, 11 모두 포함) -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.deliveryStatus == 10}">
                                                <span class="badge badge-cancel-req">취소요청</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 11}">
                                                <span class="badge badge-cancel-complete">취소완료</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 6}">
                                                <span class="badge badge-return-req">반품요청</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 7}">
                                                <span class="badge badge-return-approve">반품승인</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 8}">
                                                <span class="badge badge-return-shipping">반품수거중</span>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 9}">
                                                <span class="badge badge-return-complete">반품완료</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- 2. 처리 관리 (진행 중인 단계별 버튼 및 완료 시 안내 문구 포함) -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.deliveryStatus == 10}">
                                                <button class="action-btn btn-red" onclick="processClaim(${item.orderDetailId}, '취소 완료', 11)">취소 완료</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 6}">
                                                <button class="action-btn btn-orange" onclick="processClaim(${item.orderDetailId}, '반품 승인', 7)">반품 승인</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 7}">
                                                <button class="action-btn btn-blue" onclick="processClaim(${item.orderDetailId}, '수거 중', 8)">수거중 처리</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 8}">
                                                <button class="action-btn btn-purple" onclick="processClaim(${item.orderDetailId}, '반품 완료', 9)">반품 완료</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 9 || item.deliveryStatus == 11}">
                                                <span style="font-size: 13px; color: #888; font-weight: bold;">처리가 완료됨</span>
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