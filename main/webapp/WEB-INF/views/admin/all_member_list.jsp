<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 - 전체 일반회원 목록</title>
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
            <li><a href="${pageContext.request.contextPath}/admin/memberList.htm" class="active">👥 전체 일반회원 조회</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/sellerList.htm">🤝 전체 판매자 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/productList.htm">📦 전체 상품 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/settlementList.htm">💰 판매자 정산 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/couponList.htm">🎟️ 쿠폰 관리</a></li> <!-- 💡 사이드바 추가 -->
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
                <h2>전체 일반회원 목록</h2>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>회원번호</th>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>권한(Role)</th>
                        <th>가입일(RegDate)</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty memberList}">
                            <tr>
                                <td colspan="7" class="empty-msg">가입된 회원이 없습니다.</td>
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
                                        <c:choose>
                                            <c:when test="${member.status == 1}">
                                                <span style="color: #52c41a; font-weight: bold;">정상</span>
                                            </c:when>
                                            <c:when test="${member.status == -1}">
                                                <span style="color: #ff4d4f; font-weight: bold;">정지</span>
                                            </c:when>
                                            <c:when test="${member.status == 0}">
                                                <span style="color: #bfbfbf;">탈퇴</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${member.status == 1}">
                                                <button type="button" onclick="changeMemberStatus(${member.memberId}, -1)" 
                                                    style="background-color: #ff4d4f; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 12px;">
                                                    정지
                                                </button>
                                            </c:when>
                                            <c:when test="${member.status == -1}">
                                                <button type="button" onclick="changeMemberStatus(${member.memberId}, 1)" 
                                                    style="background-color: #1890ff; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 12px;">
                                                    정지해제
                                                </button>
                                            </c:when>
                                            <c:when test="${member.status == 0}">
                                                <span style="font-size: 12px; color: #999;">관리불가</span>
                                            </c:when>
                                        </c:choose>
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
    </div>

<script>
function changeMemberStatus(memberId, status) {
    const actionText = (status === -1) ? "정지" : "정지 해제";
    
    if (confirm("회원번호 " + memberId + "번 회원을 " + actionText + " 처리하시겠습니까?")) {
        location.href = "${pageContext.request.contextPath}/admin/memberStatusUpdate.htm?member_id=" + memberId + "&status=" + status;
    }
}
</script>
</body>
</html>