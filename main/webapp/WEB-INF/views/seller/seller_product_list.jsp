<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 상품 목록 관리</title>
<style>
    /* 대시보드와 동일한 기본 레이아웃 스타일 */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f7f9fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
    .sidebar { width: 240px; background-color: #2b333b; color: white; display: flex; flex-direction: column; }
    .sidebar-brand { padding: 20px; font-size: 18px; font-weight: bold; background-color: #1e242b; text-align: center; }
    .sidebar-menu { list-style: none; padding: 20px 0; }
    .sidebar-menu li a { display: block; padding: 12px 20px; color: #b0c4de; text-decoration: none; font-size: 14px; transition: 0.2s; }
    .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #35c5f0; color: white; }
    .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
    .top-header { height: 60px; background-color: white; border-bottom: 1px solid #e1e4e6; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; }
    
    /* 리스트 전용 스타일 */
    .content-body { padding: 30px; }
    .list-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .list-title { font-size: 20px; font-weight: bold; }
    .btn-add { background-color: #35c5f0; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; font-weight: bold; font-size: 14px; }
    
    /* 테이블 스타일 */
    .product-table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #e1e4e6; }
    .product-table th, .product-table td { padding: 15px; text-align: center; border-bottom: 1px solid #e1e4e6; font-size: 14px; }
    .product-table th { background-color: #f8f9fa; font-weight: bold; color: #555; }
    .product-name-cell { text-align: left !important; }
    
    /* 관리 버튼 스타일 */
    .btn-manage { padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; cursor: pointer; font-weight: bold; margin: 0 2px; }
    .btn-edit { background-color: #f0f2f5; color: #333; border: 1px solid #d1d5db; }
    .btn-delete { background-color: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
</style>
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🏠 O-House Seller</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/seller/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/addForm.htm">➕ 상품 등록</a></li>
            <li><a href="#" class="active">📦 상품 목록 관리</a></li>
            <li><a href="#">💰 정산 관리</a></li>
            <li><a href="#">⭐ 리뷰 관리</a></li>
        </ul>
    </div>

    <!-- 우측 메인 영역 -->
    <div class="main-content">
        <div class="top-header">
            <span style="font-weight: bold;">👋 환영합니다, <strong style="color: #35c5f0;">${sessionScope.sellerAuth.brandName}</strong> 파트너님!</span>
        </div>

        <div class="content-body">
            <div class="list-header">
                <div class="list-title">📦 등록한 상품 목록</div>
                <a href="${pageContext.request.contextPath}/seller/addForm.htm" class="btn-add">새 상품 등록</a>
            </div>

            <table class="product-table">
                <thead>
                    <tr>
                        <th width="10%">상품번호</th>
                        <th width="40%">상품명</th>
                        <th width="15%">판매가</th>
                        <th width="15%">상태</th>
                        <th width="20%">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty productList}">
                            <tr>
                                <td colspan="5" style="padding: 50px 0; color: #888;">등록된 상품이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="product" items="${productList}">
                                <tr>
                                    <td>${product.productId}</td>
                                    <td class="product-name-cell">${product.productName}</td>
                                    <td><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</td>
                                    <td>
                                        <span style="color: #35c5f0; font-weight: bold;">판매중</span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn-manage btn-edit" onclick="location.href='${pageContext.request.contextPath}/seller/editForm.htm?productId=${product.productId}'">수정</button>
                                        <button type="button" class="btn-manage btn-delete" onclick="if(confirm('정말 이 상품을 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/seller/deletePro.htm?productId=${product.productId}'">삭제</button>
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