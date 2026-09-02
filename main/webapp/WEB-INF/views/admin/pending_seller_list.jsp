<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 판매자 승인 대기 목록</title>
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
    
    .btn-back {
        padding: 8px 14px;
        background-color: #6c757d;
        color: white;
        text-decoration: none;
        border-radius: 4px;
        font-weight: bold;
        font-size: 13px;
        transition: 0.2s;
    }
    .btn-back:hover {
        background-color: #5a6268;
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
    }
    th {
        background-color: #f8f9fa;
        font-weight: bold;
        color: #555;
    }
    
    /* 관리 버튼 스타일 */
    .btn {
        padding: 6px 12px;
        border: none;
        border-radius: 4px;
        font-size: 13px;
        cursor: pointer;
        font-weight: bold;
        color: white;
        transition: 0.2s;
        margin: 0 2px;
    }
    .btn-approve { background-color: #35c5f0; }
    .btn-approve:hover { background-color: #009fce; }
    
    .btn-reject { background-color: #ff4d4f; }
    .btn-reject:hover { background-color: #d9363e; }

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
    .pagination strong {
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
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🛡️ O-House Admin</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/memberList.htm">👥 전체 일반회원 조회</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/sellerList.htm" class="active">🤝 전체 판매자 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/productList.htm">📦 전체 상품 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/settlementList.htm">💰 판매자 정산 관리</a></li>
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
                <h2>판매자 승인 대기 목록</h2>
                <a href="${pageContext.request.contextPath}/admin/sellerList.htm" class="btn-back">전체 판매자 목록으로 돌아가기</a>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>판매자번호</th>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>현재 상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty pendingList}">
                            <tr>
                                <td colspan="5" class="empty-msg">현재 승인 대기 중인 판매자가 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="seller" items="${pendingList}">
                                <tr>
                                    <td>${seller.sellerId}</td>
                                    <td>${seller.email}</td>
                                    <td>${seller.representativeName}</td>
                                    <td style="color: #ff9800; font-weight: bold;">대기중</td>
                                    <td>
                                        <button type="button" class="btn btn-approve"
                                            onclick="processApproval(${seller.sellerId}, 'approve', ${currentPage})">승인</button>
                                        <button type="button" class="btn btn-reject"
                                            onclick="processApproval(${seller.sellerId}, 'reject', ${currentPage})">거절</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <div class="pagination">
                <c:if test="${startPage > 1}">
                    <a href="${pageContext.request.contextPath}/admin/pendingSellers.htm?page=${startPage - 1}">◀ 이전</a>
                </c:if>

                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <strong>${i}</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/pendingSellers.htm?page=${i}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${endPage < totalPage}">
                    <a href="${pageContext.request.contextPath}/admin/pendingSellers.htm?page=${endPage + 1}">다음 ▶</a>
                </c:if>
            </div>

            <form id="approvalForm" action="${pageContext.request.contextPath}/admin/approveSeller.htm" method="post" style="display: none;">
                <input type="hidden" id="formSellerId" name="sellerId" value="">
                <input type="hidden" id="formAction" name="action" value=""> 
                <input type="hidden" id="formPage" name="page" value="">
            </form>
        </div>
    </div>

    <script>
        function processApproval(sellerId, action, page) {
            let msg = action === 'approve' ? '해당 판매자를 승인하시겠습니까?' : '해당 판매자를 거절하시겠습니까?';
            
            if(confirm(msg)) {
                document.getElementById('formSellerId').value = sellerId;
                document.getElementById('formAction').value = action;
                document.getElementById('formPage').value = page; 
                document.getElementById('approvalForm').submit();
            }
        }
    </script>
</body>
</html>