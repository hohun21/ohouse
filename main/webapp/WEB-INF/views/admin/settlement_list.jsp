<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 판매자 정산 관리</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f7f9fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
    
    /* 관리자 사이드바 스타일 통일 */
    .sidebar { width: 240px; background-color: #2b333b; color: white; display: flex; flex-direction: column; flex-shrink: 0; }
    .sidebar-brand { padding: 20px; font-size: 18px; font-weight: bold; background-color: #1e242b; text-align: center; }
    .sidebar-menu { list-style: none; padding: 20px 0; }
    .sidebar-menu li a { display: block; padding: 12px 20px; color: #b0c4de; text-decoration: none; font-size: 14px; transition: 0.2s; }
    .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #ff4d4f; color: white; }
    
    /* 우측 메인 영역 통일 */
    .main-content { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; }
    .top-header { height: 60px; background-color: white; border-bottom: 1px solid #e1e4e6; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; flex-shrink: 0; }
    
    .content-body { flex: 1; width: calc(100% - 80px); max-width: 1400px; margin: 0 auto; padding: 30px; overflow-y: auto; }
    
    .header-area {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid #ff4d4f;
        padding-bottom: 10px;
        margin-bottom: 20px;
    }
    .header-area h2 {
        margin: 0;
        color: #2b333b;
        font-size: 20px;
    }
    
    table {
        width: 100%;
        background: white;
        border-collapse: collapse;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 5px rgba(0,0,0,0.04);
        border: 1px solid #e1e4e6;
        margin-bottom: 20px;
    }
    th, td {
        padding: 14px 12px;
        text-align: center;
        border-bottom: 1px solid #e1e4e6;
        font-size: 14px;
        vertical-align: middle;
    }
    th {
        background-color: #f8f9fa;
        font-weight: bold;
        color: #555;
    }
    .product-name-cell { text-align: left !important; }

    /* 정산 버튼 스타일 */
    .btn-settle {
        padding: 6px 12px;
        background-color: #ff4d4f;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 13px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.2s;
    }
    .btn-settle:hover { background-color: #d9363e; }
    
    /* 정산 완료 뱃지 스타일 */
    .badge-completed {
        display: inline-block;
        padding: 6px 12px;
        background-color: #f6ffed;
        color: #52c41a;
        border: 1px solid #b7eb8f;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
    }

    /* 페이징 스타일 */
    .pagination {
        display: flex;
        justify-content: center;
        gap: 5px;
        margin-top: 20px;
    }
    .pagination a, .pagination strong {
        display: inline-block;
        padding: 8px 12px;
        border: 1px solid #ddd;
        text-decoration: none;
        color: #333;
        border-radius: 4px;
        background: white;
    }
    .pagination a:hover {
        background-color: #f1f3f5;
    }
    .pagination strong, .pagination a.active {
        background-color: #ff4d4f;
        color: white;
        border-color: #ff4d4f;
    }
    .empty-msg {
        text-align: center;
        padding: 50px;
        color: #888;
    }
</style>
<script>
    // 관리자가 정산 실행 버튼을 눌렀을 때
    function executeSettlement(orderDetailId) {
        if(confirm("해당 주문 건에 대해 판매자 정산을 실행하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/admin/executeSettlement.htm?orderDetailId=" + orderDetailId;
        }
    }
</script>
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🛡️ O-House Admin</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/memberList.htm">👥 전체 일반회원 조회</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/sellerList.htm">🤝 전체 판매자 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/productList.htm">📦 전체 상품 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/settlementList.htm" class="active">💰 판매자 정산 관리</a></li>
        </ul>
    </div>

    <!-- 우측 메인 영역 -->
    <div class="main-content">
        <div class="top-header">
            <span style="font-weight: bold;">👋 환영합니다, <strong style="color: #ff4d4f;">관리자</strong>님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <div class="content-body">
            <div class="header-area">
                <h2>💰 판매자 정산 관리 및 이력 조회</h2>
            </div>

            <table>
                <thead>
                    <tr>
                        <th width="8%">상세번호</th>
                        <th width="12%">주문일시</th>
                        <th width="12%">브랜드명</th>
                        <th width="25%">상품 정보 (옵션)</th>
                        <th width="8%">수량</th>
                        <th width="12%">주문 금액</th>
                        <th width="12%">정산 예정금액(98%)</th>
                        <th width="11%">정산 관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty settlementList}">
                            <tr>
                                <td colspan="8" class="empty-msg">정산 내역이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${settlementList}">
                                <tr>
                                    <td>${item.orderDetailId}</td>
                                    <td><fmt:formatDate value="${item.orderDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td><strong>${item.brandName}</strong></td>
                                    <td class="product-name-cell">
                                        <strong>${item.productName}</strong><br>
                                        <span style="font-size: 12px; color: #757575;">[옵션] ${item.optionName}</span>
                                    </td>
                                    <td>${item.quantity}개</td>
                                    <td>
                                        <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###"/>원
                                    </td>
                                    <td style="color: #ff4d4f; font-weight: bold;">
                                        <fmt:formatNumber value="${item.price * item.quantity * 0.98}" pattern="#,###"/>원
                                    </td>
                                    
                                    <!-- 상태에 따른 버튼 또는 정산완료 뱃지 출력 -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.deliveryStatus == 5}">
                                                <button type="button" class="btn-settle" onclick="executeSettlement(${item.orderDetailId})">정산하기</button>
                                            </c:when>
                                            <c:when test="${item.deliveryStatus == 12}">
                                                <span class="badge-completed">정산완료</span>
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