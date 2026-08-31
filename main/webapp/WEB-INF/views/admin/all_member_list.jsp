<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 전체 일반회원 목록</title>
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
        <h2>전체 일반회원 목록</h2>
        <a href="${pageContext.request.contextPath}/admin/dashboard.htm" style="padding: 10px 15px; background-color: #f7f9fa; border: 1px solid #dbdbdb; color: #424242; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 14px;">대시보드로</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>회원번호</th>
                <th>아이디</th>
                <th>이름</th>
                <th>권한(Role)</th>
                <th>가입일(RegDate)</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty memberList}">
                    <tr>
                        <td colspan="6" class="empty-msg">가입된 회원이 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="member" items="${memberList}">
                        <tr>
                            <td>${member.memberId}</td>
                            <td>${member.id}</td>
                            <td>${member.name}</td>
                            <td>${member.role}</td>
                            <td><fmt:formatDate value="${member.regDate}" pattern="yyyy-MM-dd"/></td>
                        	<td>
                        		<button type="button" onclick="confirmDelete(${member.memberId})" 
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
            <a href="${pageContext.request.contextPath}/admin/memberList.htm?page=${startPage - 1}">◀ 이전</a>
        </c:if>
        
        <c:forEach var="i" begin="${startPage}" end="${endPage}">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <strong>${i}</strong>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin/memberList.htm?page=${i}">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${endPage < totalPage}">
            <a href="${pageContext.request.contextPath}/admin/memberList.htm?page=${endPage + 1}">다음 ▶</a>
        </c:if>
    </div>
</div>
<script>
function confirmDelete(memberId) {
    if (confirm("회원번호 " + memberId + "번 회원을 삭제하시겠습니까?")) {
        location.href = "${pageContext.request.contextPath}/admin/deleteMember.htm?memberId=" + memberId;
    }
}
</script>
</body>
</html>