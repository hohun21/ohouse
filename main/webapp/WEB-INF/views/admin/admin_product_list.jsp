<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 센터 - 전체 상품 관리</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f7f9fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
    
    /* 관리자 테마 (붉은색 포인트) */
    .sidebar { width: 240px; background-color: #2b333b; color: white; display: flex; flex-direction: column; }
    .sidebar-brand { padding: 20px; font-size: 18px; font-weight: bold; background-color: #1e242b; text-align: center; }
    .sidebar-menu { list-style: none; padding: 20px 0; }
    .sidebar-menu li a { display: block; padding: 12px 20px; color: #b0c4de; text-decoration: none; font-size: 14px; transition: 0.2s; }
    .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #ff4d4f; color: white; }
    
    .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
    .top-header { height: 60px; background-color: white; border-bottom: 1px solid #e1e4e6; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; padding-top: 20px; padding-bottom: 20px; }
    
    .content-body { padding: 30px; }
    .list-title { font-size: 20px; font-weight: bold; margin-bottom: 20px; }
    
    /* 테이블 스타일 */
    .product-table { width: 100%; background: white; border-collapse: collapse; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #e1e4e6; }
    .product-table th, .product-table td { padding: 15px; text-align: center; border-bottom: 1px solid #e1e4e6; font-size: 14px; }
    .product-table th { background-color: #f8f9fa; font-weight: bold; color: #555; }
    .product-name-cell { text-align: left !important; }
    
    /* 관리 버튼 공통 및 삭제 버튼 스타일 */
    .btn-manage { padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; cursor: pointer; font-weight: bold; margin: 0 2px; }
    .btn-delete { background-color: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
    .btn-delete:hover { background-color: #ffcdd2; }
</style>
</head>
<body>

    <!-- 좌측 관리자 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🛡️ O-House Admin</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/memberList.htm">👥 전체 일반회원 조회</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/sellerList.htm">🤝 전체 판매자 관리</a></li>
            <li><a href="#" class="active">📦 전체 상품 관리</a></li>
        </ul>
    </div>

    <!-- 우측 메인 영역 -->
    <div class="main-content">
        <div class="top-header">
            <span style="font-weight: bold;">👋 환영합니다, <strong style="color: #ff4d4f;">관리자</strong>님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <div class="content-body">
            <div class="list-title">📦 플랫폼 전체 상품 목록 (관리자 제재용)</div>

            <table class="product-table">
                <thead>
                    <tr>
                        <th width="10%">상품번호</th>
                        <th width="20%">판매자(상호명)</th>
                        <th width="30%">상품명</th>
                        <th width="15%">판매가</th>
                        <th width="10%">상태</th>
                        <th width="15%">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty adminProductList}">
                            <tr>
                                <td colspan="6" style="padding: 50px 0; color: #888;">등록된 상품이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="product" items="${adminProductList}">
                                <tr>
                                    <td>${product.productId}</td>
                                    <td style="font-weight: bold; color: #009fce;">${product.brandName}</td>
                                    <td class="product-name-cell">${product.productName}</td>
                                    <td><fmt:formatNumber value="${product.price}" pattern="#,###"/>원</td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 'STOP'}">
                                                <span style="color: #c62828; font-weight: bold;">판매중지</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #35c5f0; font-weight: bold;">판매중</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 'STOP'}">
                                                <button type="button" class="btn-manage" 
                                                        style="background-color: #e3f2fd; color: #0288d1; border: 1px solid #90caf9;" 
                                                        onclick="if(confirm('이 상품의 판매를 재개하시겠습니까?')) location.href='${pageContext.request.contextPath}/admin/productStatus.htm?productId=${product.productId}&status=ACTIVE'">
                                                    판매재개
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn-manage" 
                                                        style="background-color: #fff3e0; color: #f57c00; border: 1px solid #ffcc80;" 
                                                        onclick="if(confirm('이 상품을 강제로 판매중지 처리하시겠습니까?')) location.href='${pageContext.request.contextPath}/admin/productStatus.htm?productId=${product.productId}&status=STOP'">
                                                    판매중지
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <button type="button" class="btn-manage btn-delete" 
                                                onclick="if(confirm('정말 이 상품을 강제 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/admin/deleteProduct.htm?productId=${product.productId}'">
                                            강제삭제
                                        </button>
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