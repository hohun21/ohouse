<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 센터 - 쿠폰 관리</title>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f7f9fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
    
    /* 관리자 사이드바 스타일 */
    .sidebar { width: 240px; background-color: #2b333b; color: white; display: flex; flex-direction: column; flex-shrink: 0; }
    .sidebar-brand { padding: 20px; font-size: 18px; font-weight: bold; background-color: #1e242b; text-align: center; }
    .sidebar-menu { list-style: none; padding: 20px 0; }
    .sidebar-menu li a { display: block; padding: 12px 20px; color: #b0c4de; text-decoration: none; font-size: 14px; transition: 0.2s; }
    .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #ff4d4f; color: white; }
    
    /* 메인 영역 */
    .main-content { flex: 1; display: flex; flex-direction: column; height: 100vh; overflow: hidden; }
    .top-header { height: 60px; background-color: white; border-bottom: 1px solid #e1e4e6; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; flex-shrink: 0; }
    
    .content-body { flex: 1; width: calc(100% - 80px); max-width: 1400px; margin: 0 auto; padding: 30px; overflow-y: auto; }
    
    .page-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #e1e4e6; padding-bottom: 15px; margin-bottom: 20px; }
    .page-title { font-size: 20px; font-weight: bold; color: #2b333b; margin: 0; }
    
    .btn-primary { background-color: #ff4d4f; color: white; border: none; padding: 10px 18px; border-radius: 4px; font-size: 14px; font-weight: bold; cursor: pointer; transition: 0.2s; }
    .btn-primary:hover { background-color: #d9363e; }
    
    /* 상태 관리 버튼 스타일 */
    .btn-status { padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: bold; cursor: pointer; border: none; }
    .btn-issue { background-color: #35c5f0; color: white; }
    .btn-issue:hover { background-color: #009fce; }
    .btn-activate { background-color: #e3f2fd; color: #0288d1; border: 1px solid #90caf9; }
    .btn-deactivate { background-color: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }

    /* 데이터 테이블 스타일 */
    .data-table { width: 100%; border-collapse: collapse; background-color: white; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); border: 1px solid #e1e4e6; margin-bottom: 20px; }
    .data-table th, .data-table td { padding: 15px; text-align: center; border-bottom: 1px solid #e1e4e6; font-size: 14px; }
    .data-table th { background-color: #f0f2f5; font-weight: bold; color: #444; }
    .data-table tr:hover { background-color: #fafafa; }
    .empty-msg { text-align: center; padding: 50px; color: #888; }

    /* 모달 스타일 */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 999; justify-content: center; align-items: center; }
    .modal-box { background: white; padding: 30px; border-radius: 8px; width: 450px; max-height: 90vh; overflow-y: auto; box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
    .modal-header { font-size: 18px; font-weight: bold; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
    .modal-close { cursor: pointer; font-size: 20px; color: #888; border: none; background: none; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; font-size: 13px; font-weight: bold; margin-bottom: 5px; color: #555; }
    .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
    .modal-footer { margin-top: 25px; display: flex; justify-content: flex-end; gap: 10px; }
    .btn-cancel { background-color: #f0f2f5; color: #333; border: 1px solid #ddd; padding: 10px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; }
</style>
<script>
    function toggleMaxDiscount() {
        const type = document.getElementById("discountType").value;
        const maxInput = document.getElementById("maxDiscount");
        if(type === 'AMOUNT') {
            maxInput.value = '';
            maxInput.disabled = true;
            maxInput.placeholder = "정액 할인은 입력 불가";
        } else {
            maxInput.disabled = false;
            maxInput.placeholder = "최대 할인 금액 (원)";
        }
    }

    function confirmCouponAction(couponId, targetStatus, actionType) {
        let msg = "";
        let targetUrl = "";
        
        if (actionType === 'issue') {
            msg = "쿠폰을 모두에게 뿌리겠습니까?";
            targetUrl = "${pageContext.request.contextPath}/admin/issueCoupon.htm?couponId=" + couponId;
        } else if (actionType === 'deactivate') {
            msg = "쿠폰을 비활성화 시키겠습니까?";
            targetUrl = "${pageContext.request.contextPath}/admin/couponStatusUpdate.htm?couponId=" + couponId + "&status=" + targetStatus;
        } else if (actionType === 'activate') {
            msg = "쿠폰을 활성화 시키겠습니까?";
            targetUrl = "${pageContext.request.contextPath}/admin/couponStatusUpdate.htm?couponId=" + couponId + "&status=" + targetStatus;
        }

        if(confirm(msg)) {
            location.href = targetUrl;
        }
    }
</script>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-brand">🛡️ O-House Admin</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/memberList.htm">👥 전체 일반회원 조회</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/sellerList.htm">🤝 전체 판매자 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/productList.htm">📦 전체 상품 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/settlementList.htm">💰 판매자 정산 관리</a></li>
            <li><a href="#" class="active">🎟️ 쿠폰 관리</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="top-header">
            <span style="font-weight: bold;">👋 환영합니다, <strong style="color: #ff4d4f;">관리자</strong>님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <div class="content-body">
            <div class="page-header">
                <h2 class="page-title">🎟️ 쿠폰 발급 및 관리</h2>
                <button type="button" class="btn-primary" onclick="openModal()">➕ 신규 쿠폰 등록</button>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>쿠폰 ID</th>
                        <th>쿠폰명</th>
                        <th>할인 정보</th>
                        <th>최소 주문금액</th>
                        <th>최대 할인금액</th>
                        <th>유효 기간</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty couponList}">
                            <tr>
                                <td colspan="8" class="empty-msg">등록된 쿠폰 내역이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <jsp:useBean id="now" class="java.util.Date"/>
                            
                            <c:forEach var="coupon" items="${couponList}">
                                <tr>
                                    <td>${coupon.couponId}</td>
                                    <td style="font-weight: bold; color: #111;">${coupon.couponName}</td>
                                    
                                    <td style="color: #ff4d4f; font-weight: bold;">
                                        <fmt:formatNumber value="${coupon.discountValue}" pattern="#,###"/>
                                        ${coupon.discountType == 'RATE' ? '%' : '원'}
                                    </td>
                                    
                                    <td><fmt:formatNumber value="${coupon.minOrderPrice}" pattern="#,###"/>원</td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${coupon.discountType == 'RATE' and not empty coupon.maxDiscount}">
                                                <fmt:formatNumber value="${coupon.maxDiscount}" pattern="#,###"/>원
                                            </c:when>
                                            <c:otherwise> - </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <fmt:formatDate value="${coupon.startDate}" pattern="yyyy.MM.dd"/> ~ 
                                        <fmt:formatDate value="${coupon.endDate}" pattern="yyyy.MM.dd"/>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${coupon.endDate.time < now.time}">
                                                <span style="color: #bfbfbf; font-weight: bold;">유효기간 만료</span>
                                            </c:when>
                                            <c:when test="${coupon.status == 1}">
                                                <span style="color: #52c41a; font-weight: bold;">활성</span>
                                            </c:when>
                                            <c:when test="${coupon.status == 0}">
                                                <span style="color: #faad14; font-weight: bold;">미활성</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #ff4d4f; font-weight: bold;">비활성</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td>
                                        <c:choose>
                                            <c:when test="${coupon.endDate.time < now.time}">
                                                <span style="color: #999; font-size: 13px;">-</span>
                                            </c:when>
                                            <c:when test="${coupon.status == 0}">
                                                <button type="button" class="btn-status btn-issue" onclick="confirmCouponAction(${coupon.couponId}, 1, 'issue')">🎁 뿌리기</button>
                                            </c:when>
                                            <c:when test="${coupon.status == 1}">
                                                <button type="button" class="btn-status btn-deactivate" onclick="confirmCouponAction(${coupon.couponId}, -1, 'deactivate')">비활성화</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn-status btn-activate" onclick="confirmCouponAction(${coupon.couponId}, 1, 'activate')">활성화</button>
                                            </c:otherwise>
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

    <!-- 쿠폰 등록 모달 창 -->
    <div class="modal-overlay" id="couponModal">
        <div class="modal-box">
            <div class="modal-header">
                <span>➕ 신규 쿠폰 등록</span>
                <button class="modal-close" onclick="closeModal()">×</button>
            </div>
            
            <form action="${pageContext.request.contextPath}/admin/addCoupon.htm" method="post">
                <div class="form-group">
                    <label>쿠폰명</label>
                    <input type="text" name="couponName" placeholder="예: 봄맞이 5천원 할인" required>
                </div>
                
                <div class="form-group">
                    <label>할인 방식</label>
                    <select name="discountType" id="discountType" required onchange="toggleMaxDiscount()">
                        <option value="AMOUNT">정액 할인 (원)</option>
                        <option value="RATE">정률 할인 (%)</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>할인 수치 (금액 또는 퍼센트)</label>
                    <input type="number" name="discountValue" placeholder="숫자만 입력" required>
                </div>
                
                <div class="form-group">
                    <label>최소 주문 금액 조건</label>
                    <input type="number" name="minOrderPrice" placeholder="예: 30000 (0입력 시 조건 없음)" required>
                </div>
                
                <div class="form-group">
                    <label>최대 할인 금액 (정률 할인 시 적용)</label>
                    <input type="number" name="maxDiscount" id="maxDiscount" placeholder="정액 할인은 입력 불가" disabled>
                </div>
                
                <div class="form-group">
                    <label>유효 기간 (종료일)</label>
                    <input type="date" name="endDate" required>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeModal()">취소</button>
                    <button type="submit" class="btn-primary">등록하기</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const modal = document.getElementById('couponModal');
        
        function openModal() {
            modal.style.display = 'flex';
        }
        
        function closeModal() {
            modal.style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>