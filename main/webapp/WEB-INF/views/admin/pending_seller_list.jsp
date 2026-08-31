<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 판매자 승인 대기 목록</title>
<style>
    body {
        font-family: 'Malgun Gothic', sans-serif;
        background-color: #f4f6f8;
        color: #333;
        margin: 0;
        padding: 20px;
    }
    .admin-container {
        max-width: 1000px;
        margin: 0 auto;
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .header-area {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid #35c5f0;
        padding-bottom: 10px;
        margin-bottom: 20px;
    }
    .header-area h2 {
        margin: 0;
        color: #2b333b;
    }
    
    .btn-back {
        padding: 10px 15px;
        background-color: #6c757d;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-weight: bold;
        font-size: 14px;
        transition: 0.2s;
    }
    .btn-back:hover {
        background-color: #5a6268;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }
    th, td {
        padding: 12px;
        text-align: center;
        border-bottom: 1px solid #e1e4e6;
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
    }
    .pagination a:hover {
        background-color: #f1f3f5;
    }
    .pagination strong {
        background-color: #35c5f0;
        color: white;
        border-color: #35c5f0;
    }
    .empty-msg {
        text-align: center;
        padding: 50px;
        color: #888;
    }
</style>
</head>
<body>

<div class="admin-container">
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
</div>

</body>
</html>