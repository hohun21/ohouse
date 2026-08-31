<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 전체 판매자 목록</title>
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
    .btn-pending {
        padding: 10px 15px;
        background-color: #ff5a5f;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        font-weight: bold;
        font-size: 14px;
        transition: 0.2s;
    }
    .btn-pending:hover {
        background-color: #e0484d;
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
    
    /* 페이징 스타일 */
    .pagination {
        display: flex;
        justify-content: center;
        gap: 5px;
        margin-top: 20px;
    }
    .pagination a {
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
    .pagination a.active {
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
        <h2>전체 판매자 회원 목록</h2>
        <div style="display: flex; gap: 10px; align-items: center;">
        	<a href="${pageContext.request.contextPath}/admin/pendingSellers.htm" class="btn-pending">판매자 가입 승인 대기 관리</a>
        	<a href="${pageContext.request.contextPath}/admin/dashboard.htm" style="padding: 10px 15px; background-color: #f7f9fa; border: 1px solid #dbdbdb; color: #424242; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 14px;">대시보드로</a>
    	</div>  
    </div>
    
    <table>
        <thead>
            <tr>
                <th>No.</th>
                <th>아이디</th>
                <th>이름</th>
                <th>가입일</th>
                <th>상태</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty sellerList}">
                    <tr>
                        <td colspan="6" class="empty-msg">등록된 판매자가 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="seller" items="${sellerList}">
                        <tr>
                            <td>${seller.sellerId}</td>
                            <td>${seller.email}</td>
                            <td>${seller.representativeName}</td>
                            <td><fmt:formatDate value="${seller.regDate}" pattern="yyyy-MM-dd HH:mm"/></td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${seller.status == 'PENDING'}">
                                        <span style="color: #ff9800; font-weight: bold;">승인대기</span>
                                    </c:when>
                                    <c:when test="${seller.status == 'ACTIVE'}">
                                        <span style="color: #4caf50; font-weight: bold;">승인완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #f44336; font-weight: bold;">거절됨</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                        		<button type="button" onclick="confirmDeleteSeller(${seller.sellerId})" 
                                	style="background-color: #ff5a5f; color: white; border: none; padding: 4px 8px; border-radius: 4px; cursor: pointer; font-weight: bold;">
                            		X
                        		</button>
                    	</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="pagination">
        <c:if test="${startPage > 1}">
            <a href="${pageContext.request.contextPath}/admin/sellerList.htm?page=${startPage - 1}">이전</a>
        </c:if>
        
        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <a href="${pageContext.request.contextPath}/admin/sellerList.htm?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
        </c:forEach>
        
        <c:if test="${endPage < totalPage}">
            <a href="${pageContext.request.contextPath}/admin/sellerList.htm?page=${endPage + 1}">다음</a>
        </c:if>
    </div>
</div>

<script>
function confirmDeleteSeller(sellerId) {
    if (confirm("판매자 번호 " + sellerId + "번 회원을 삭제하시겠습니까?")) {
        location.href = "${pageContext.request.contextPath}/admin/deleteSeller.htm?sellerId=" + sellerId;
    }
}
</script>

</body>
</html>