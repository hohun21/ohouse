<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오늘의집 - 배송지 설정</title>
<link rel="stylesheet" as="style" crossorigin
    href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', 'Pretendard', sans-serif; background-color: #fff; color: #292929; }
    a { text-decoration: none; color: inherit; }
    .container { max-width: 1136px; margin: 0 auto; padding: 0 20px; box-sizing: border-box; }

    .top-nav { display: flex; justify-content: center; border-bottom: 1px solid #ededed; padding: 15px 0; }
    .top-nav a { margin: 0 15px; font-size: 16px; font-weight: bold; color: #424242; transition: color 0.2s ease; }
    .top-nav a:hover { color: #35c5f0; }
    .top-nav a.active { color: #35c5f0; }

    .sub-nav { display: flex; justify-content: center; border-bottom: 1px solid #ededed; padding: 15px 0; margin-bottom: 50px; }
    .sub-nav a { margin: 0 15px; font-size: 15px; font-weight: bold; color: #757575; position: relative; padding-bottom: 15px; transition: color 0.2s ease; }
    .sub-nav a:hover { color: #35c5f0; }
    .sub-nav a.active { color: #35c5f0; }
    .sub-nav a.active::after { content: ""; position: absolute; bottom: 0; left: 0; width: 100%; height: 3px; background-color: #35c5f0; }

    .address-form-wrapper { max-width: 500px; margin: 0 auto 100px; }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 14px; font-weight: bold; color: #292929; margin-bottom: 8px; }
    .form-group label span { color: #35c5f0; }
    
    .input-box { width: 100%; padding: 14px 16px; border: 1px solid #dbdbdb; border-radius: 4px; font-size: 15px; outline: none; box-sizing: border-box; transition: border-color 0.2s; font-family: inherit;}
    .input-box:focus { border-color: #35c5f0; box-shadow: 0 0 0 3px rgba(53, 197, 240, 0.12); }
    
    .flex-row { display: flex; gap: 10px; margin-bottom: 10px; }
    .flex-row .input-box { flex: 1; }
    .flex-row .short-input { width: 120px; flex: none; }

    .checkbox-group { display: flex; align-items: center; gap: 8px; margin: 20px 0; cursor: pointer; }
    .checkbox-group input[type="checkbox"] { width: 18px; height: 18px; cursor: pointer; accent-color: #35c5f0; }
    .checkbox-group span { font-size: 15px; color: #292929; font-weight: 500; }

    .btn-submit { width: 100%; padding: 15px; background-color: #35c5f0; color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
    .btn-submit:hover { background-color: #20b2df; }
    
    .list-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #292929; padding-bottom: 10px;}
    .list-header h3 { font-size: 18px; margin: 0; }
    .btn-list { padding: 6px 12px; border: 1px solid #35c5f0; background-color: #fff; color: #35c5f0; border-radius: 4px; font-size: 13px; font-weight: bold; cursor: pointer; transition: 0.2s; }
    .btn-list:hover { background-color: #f0f8fb; }

    .modal-overlay {
        display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5); z-index: 9999;
        align-items: center; justify-content: center;
    }
    .modal-overlay.show { display: flex; }

    .modal-content {
        background: #fff; width: 90%; max-width: 500px;
        border-radius: 8px; box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        overflow: hidden; display: flex; flex-direction: column;
    }

    .modal-header {
        display: flex; justify-content: space-between; align-items: center;
        padding: 20px; border-bottom: 1px solid #ededed;
    }
    .modal-header h2 { font-size: 18px; margin: 0; color: #292929; }
    .btn-close-modal { background: none; border: none; font-size: 24px; color: #999; cursor: pointer; line-height: 1; }
    
    .modal-body { padding: 20px; max-height: 60vh; overflow-y: auto; background-color: #f7f9fa; }

    /* 배송지 아이템 리스트 디자인 */
    .address-item { background: #fff; border: 1px solid #dbdbdb; border-radius: 6px; padding: 20px; margin-bottom: 12px; }
    .item-head { margin-bottom: 12px; display: flex; align-items: center; gap: 8px; }
    .item-head .name { font-weight: bold; font-size: 16px; color: #292929; }
    .item-head .badge { font-size: 11px; color: #35c5f0; background: #f0f8fb; padding: 3px 6px; border-radius: 4px; font-weight: bold; }
    
    .item-body p { font-size: 14px; color: #424242; margin-bottom: 6px; line-height: 1.4; }
    .item-body .req-msg { margin-top: 12px; padding-top: 12px; border-top: 1px solid #ededed; color: #757575; font-size: 13px; }
    
    .item-footer { display: flex; justify-content: flex-end; gap: 8px; margin-top: 15px; }
    .btn-item { padding: 6px 12px; font-size: 13px; border: 1px solid #dbdbdb; background: #fff; border-radius: 4px; cursor: pointer; color: #424242; }
    .btn-item:hover { background: #fafafa; }
    .empty-msg { text-align: center; padding: 40px 0; color: #757575; font-size: 15px; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp">
		<jsp:param name="showSubHeaderAtTop" value="false"/>
	</jsp:include>

    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/member/myPage.htm">프로필</a>
        <a href="${pageContext.request.contextPath}/member/myShopping.htm">나의 쇼핑</a>
        <a href="#">나의 리뷰</a>
        <a href="${pageContext.request.contextPath}/changePwd.htm" class="active">설정</a>
    </div>

    <div class="sub-nav">
        <a href="#">회원정보수정</a>
        <a href="#">알림 설정</a>
        <a href="#">사용자 숨기기 설정</a>
        <a href="${pageContext.request.contextPath}/addressList.htm" class="active">배송지 설정</a>
        <a href="${pageContext.request.contextPath}/changePwd.htm">비밀번호 변경</a>
        <a href="#">추천코드</a>
        <a href="${pageContext.request.contextPath}/member/withdraw.htm">회원 탈퇴</a>
    </div>

    <div class="container">
        <div class="address-form-wrapper">
            
            <div class="list-header">
                <h3>새 배송지 추가</h3>
                <button type="button" class="btn-list" id="btnShowList">목록 보기</button>
            </div>

            <form action="${pageContext.request.contextPath}/addressAddPro.htm" method="post" id="addressForm">
                <div class="form-group">
                    <label for="address_name">배송지명</label>
                    <input type="text" id="address_name" name="address_name" class="input-box" placeholder="예) 집, 회사">
                </div>
                <div class="form-group">
                    <label for="recipient_name">받는 사람<span>*</span></label>
                    <input type="text" id="recipient_name" name="recipient_name" class="input-box" placeholder="수령인 이름" required>
                </div>
                <div class="form-group">
                    <label for="phone">전화번호<span>*</span></label>
                    <input type="text" id="phone" name="phone" class="input-box" placeholder="예) 010-1234-5678" required>
                </div>
                <div class="form-group">
                    <label>주소<span>*</span></label>
                    <div class="flex-row">
                        <input type="text" name="zip_code" class="input-box short-input" placeholder="우편번호" required>
                    </div>
                    <div class="flex-row">
                        <input type="text" name="base_address" class="input-box" placeholder="기본 주소 (시/군/구 동)" required>
                    </div>
                    <div class="flex-row">
                        <input type="text" name="detail_address" class="input-box" placeholder="상세 주소 (동/호수 등)">
                    </div>
                </div>
                <label class="checkbox-group">
                    <input type="checkbox" name="is_default" value="Y">
                    <span>기본 배송지로 저장</span>
                </label>
                <div class="form-group">
                    <select name="request_msg" class="input-box">
                        <option value="">배송시 요청사항을 선택해주세요</option>
                        <option value="부재시 문 앞에 놓아주세요.">부재시 문 앞에 놓아주세요.</option>
                        <option value="부재시 경비실에 맡겨주세요.">부재시 경비실에 맡겨주세요.</option>
                        <option value="부재시 전화 또는 문자주세요.">부재시 전화 또는 문자주세요.</option>
                        <option value="택배함에 넣어주세요.">택배함에 넣어주세요.</option>
                        <option value="직접입력">직접입력</option>
                    </select>
                </div>
                <button type="submit" class="btn-submit">저장하기</button>
            </form>
        </div>
    </div>

    <div class="modal-overlay" id="addressModal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>등록된 배송지 목록</h2>
                <button class="btn-close-modal" id="btnCloseModal">✕</button>
            </div>
            
            <div class="modal-body">
                <c:choose>
                    <c:when test="${empty addressList}">
                        <div class="empty-msg">등록된 배송지가 없습니다.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="addr" items="${addressList}">
                            <div class="address-item">
                                <div class="item-head">
                                    <span class="name">
                                        ${addr.recipient_name}
                                        <c:if test="${not empty addr.address_name}"> (${addr.address_name})</c:if>
                                    </span>
                                    <c:if test="${addr.is_default == 'Y'}">
                                        <span class="badge">기본배송지</span>
                                    </c:if>
                                </div>
                                <div class="item-body">
                                    <p>[${addr.zip_code}] ${addr.base_address}</p>
                                    <p>${addr.detail_address}</p>
                                    <p>${addr.phone}</p>
                                    <c:if test="${not empty addr.request_msg}">
                                        <div class="req-msg">배송 요청사항: ${addr.request_msg}</div>
                                    </c:if>
                                </div>
                                <div class="item-footer">
                                    <c:if test="${addr.is_default == 'N'}">
                                        <button type="button" class="btn-item" onclick="location.href='${pageContext.request.contextPath}/addressSetDefault.htm?address_id=${addr.address_id}'">기본배송지로 설정</button>
                                    </c:if>
                                    <button type="button" class="btn-item" onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/addressDelete.htm?address_id=${addr.address_id}'">삭제</button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script>
        const modal = document.getElementById("addressModal");
        const btnShowList = document.getElementById("btnShowList");
        const btnCloseModal = document.getElementById("btnCloseModal");

        btnShowList.addEventListener("click", () => {
            modal.classList.add("show");
        });

        btnCloseModal.addEventListener("click", () => {
            modal.classList.remove("show");
        });

        modal.addEventListener("click", (e) => {
            if (e.target === modal) {
                modal.classList.remove("show");
            }
        });
        
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('openModal') === 'true') {
            modal.classList.add("show");
            
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    </script>
</body>
</html>