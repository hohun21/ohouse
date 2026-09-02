<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오늘의집 - 비밀번호 변경</title>
<link rel="stylesheet" as="style" crossorigin
    href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', 'Pretendard', sans-serif; background-color: #fff; color: #292929; }
    a { text-decoration: none; color: inherit; }
    .container { max-width: 1136px; margin: 0 auto; padding: 0 20px; box-sizing: border-box; }

    /* 상단 네비게이션 탭 */
    .top-nav { display: flex; justify-content: center; border-bottom: 1px solid #ededed; padding: 15px 0; }
    .top-nav a { margin: 0 15px; font-size: 16px; font-weight: bold; color: #424242; transition: color 0.2s ease; }
    .top-nav a:hover { color: #35c5f0; }
    .top-nav a.active { color: #35c5f0; }

    /* 서브 하위 탭 */
    .sub-nav { display: flex; justify-content: center; border-bottom: 1px solid #ededed; padding: 15px 0; margin-bottom: 50px; }
    .sub-nav a { margin: 0 15px; font-size: 15px; font-weight: bold; color: #757575; position: relative; padding-bottom: 15px; transition: color 0.2s ease; }
    .sub-nav a:hover { color: #35c5f0; }
    .sub-nav a.active { color: #35c5f0; }
    .sub-nav a.active::after { content: ""; position: absolute; bottom: 0; left: 0; width: 100%; height: 3px; background-color: #35c5f0; }

    /* 비밀번호 변경 폼 영역 */
    .password-form-wrapper { max-width: 400px; margin: 0 auto 100px; }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-size: 14px; font-weight: bold; color: #292929; margin-bottom: 8px; }
    .form-group label span { color: #35c5f0; }
    
    .input-box { width: 100%; padding: 14px 16px; border: 1px solid #dbdbdb; border-radius: 4px; font-size: 15px; outline: none; box-sizing: border-box; transition: border-color 0.2s; }
    .input-box:focus { border-color: #35c5f0; box-shadow: 0 0 0 3px rgba(53, 197, 240, 0.12); }
    
    /* 에러 스타일 */
    .input-box.error-input { border-color: #f06060; }
    .error-text { font-size: 13px; color: #f06060; margin-top: 6px; display: none; }
    .error-text.show { display: block; }

    .guide-text { font-size: 12px; color: #757575; margin-top: 6px; }
    .server-error { margin-bottom: 18px; padding: 13px 14px; border: 1px solid #ffcdd2; border-radius: 4px; background-color: #fff5f5; color: #e53935; font-size: 14px; }

    .btn-change { width: 100%; padding: 15px; background-color: #35c5f0; color: white; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
    .btn-change:hover { background-color: #20b2df; }
    .btn-change:disabled { background-color: #ededed; color: #c2c2c2; cursor: default; }
    .form-notice { text-align: center; font-size: 13px; color: #757575; margin-top: 16px; }
</style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp">
		<jsp:param name="showSubHeaderAtTop" value="false"/>
	</jsp:include>

    <div class="top-nav">
        <a href="${pageContext.request.contextPath}/member/myPage.htm">프로필</a>
        <a href="#">나의 쇼핑</a>
        <a href="${pageContext.request.contextPath}/member/myReview.htm">나의 리뷰</a>
        <a href="${pageContext.request.contextPath}/changePwd.htm" class="active">설정</a>
    </div>

    <div class="sub-nav">
        <a href="#">회원정보수정</a>
        <a href="#">알림 설정</a>
        <a href="#">사용자 숨기기 설정</a>
        <a href="${pageContext.request.contextPath}/addressList.htm">배송지 설정</a>
        <a href="${pageContext.request.contextPath}/changePwd.htm" class="active">비밀번호 변경</a>
        <a href="#">추천코드</a>
        <a href="${pageContext.request.contextPath}/member/withdraw.htm">회원 탈퇴</a>
    </div>

    <div class="container">
        <div class="password-form-wrapper">
            
            <form action="${pageContext.request.contextPath}/changePwdPro.htm" method="post" id="passwordForm">
                
                <!-- 1. 현재 비밀번호 -->
                <div class="form-group">
                    <label for="currentPwd">현재 비밀번호<span>*</span></label>
                    <input type="password" id="currentPwd" name="currentPwd" class="input-box" placeholder="사용 중인 비밀번호를 입력해주세요." required>
                    <p id="currentPwdError" class="error-text">꼭 입력해야 해요.</p>
                </div>

                <!-- 2. 새 비밀번호 -->
                <div class="form-group">
                    <label for="newPwd">새 비밀번호<span>*</span></label>
                    <input type="password" id="newPwd" name="newPwd" class="input-box" placeholder="바꿀 비밀번호를 입력해주세요." minlength="8" maxlength="20" required>
                    <div id="newPwdGuide" class="guide-text">영문, 숫자를 포함해 8자 이상으로 만들어주세요.</div>
                    <p id="newPwdError" class="error-text">꼭 입력해야 해요.</p>
                </div>

                <!-- 3. 새 비밀번호 확인 -->
                <div class="form-group">
                    <label for="confirmPwd">새 비밀번호 확인<span>*</span></label>
                    <input type="password" id="confirmPwd" name="confirmPwd" class="input-box" placeholder="1번 더 입력해주세요." minlength="8" maxlength="20" required>
                    <p id="confirmPwdError" class="error-text">꼭 입력해야 해요.</p>
                </div>

                <button type="submit" id="changeButton" class="btn-change" disabled>완료</button>
                <div class="form-notice">비밀번호를 바꾸면 새 비밀번호로 다시 로그인해주세요.</div>
            </form>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <!-- 비밀번호 변경 성공 시 알림창 및 로그인 페이지 리다이렉트 처리 -->
    <c:if test="${not empty showAlert}">
        <script>
            alert("비밀번호 변경이 완료되었습니다!");
            location.href = "${redirectUrl}";
        </script>
    </c:if>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const currentPwd = document.getElementById("currentPwd");
    const newPwd = document.getElementById("newPwd");
    const confirmPwd = document.getElementById("confirmPwd");
    
    const currentPwdError = document.getElementById("currentPwdError");
    const newPwdError = document.getElementById("newPwdError");
    const newPwdGuide = document.getElementById("newPwdGuide");
    const confirmPwdError = document.getElementById("confirmPwdError");
    const changeButton = document.getElementById("changeButton");

    const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+\-=]{8,20}$/;
    
    let isCurrentPwdValid = false;

    function checkFormValidity() {
        const cValid = isCurrentPwdValid;
        const nVal = newPwd.value.trim();
        const nValid = nVal !== "" && passwordRegex.test(nVal) && nVal !== currentPwd.value.trim();
        const cfVal = confirmPwd.value.trim();
        const cfValid = cfVal !== "" && cfVal === nVal;

        changeButton.disabled = !(cValid && nValid && cfValid);
    }

    currentPwd.addEventListener("blur", function () {
        const val = currentPwd.value.trim();
        if (val === "") {
            currentPwd.classList.add("error-input");
            currentPwdError.textContent = "꼭 입력해야 해요.";
            currentPwdError.classList.add("show");
            isCurrentPwdValid = false;
            checkFormValidity();
            return;
        }

        fetch("${pageContext.request.contextPath}/checkCurrentPwd.ajax", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
            body: "currentPwd=" + encodeURIComponent(val)
        })
        .then(response => response.json())
        .then(data => {
            if (data.isMatch) {
                currentPwd.classList.remove("error-input");
                currentPwdError.classList.remove("show");
                isCurrentPwdValid = true;
            } else {
                currentPwd.classList.add("error-input");
                currentPwdError.textContent = "비밀번호가 일치하지 않아요.";
                currentPwdError.classList.add("show");
                isCurrentPwdValid = false;
            }
            checkFormValidity();
        });
    });

    currentPwd.addEventListener("input", function () {
        if (currentPwd.value.trim() !== "") {
            currentPwd.classList.remove("error-input");
            currentPwdError.classList.remove("show");
        }
        checkFormValidity();
    });

    newPwd.addEventListener("blur", function () {
        const val = newPwd.value.trim();
        const cVal = currentPwd.value.trim();

        if (val === "") {
            newPwd.classList.add("error-input");
            newPwdError.textContent = "꼭 입력해야 해요.";
            newPwdError.classList.add("show");
            newPwdGuide.style.display = "none";
        } else if (!passwordRegex.test(val)) {
            newPwd.classList.add("error-input");
            newPwdError.textContent = "영문, 숫자를 포함해 8~20자여야 합니다.";
            newPwdError.classList.add("show");
            newPwdGuide.style.display = "none";
        } else if (cVal !== "" && cVal === val) {
            newPwd.classList.add("error-input");
            newPwdError.textContent = "새 비밀번호는 현재 비밀번호와 달라야 합니다.";
            newPwdError.classList.add("show");
            newPwdGuide.style.display = "none";
        } else {
            newPwd.classList.remove("error-input");
            newPwdError.classList.remove("show");
            newPwdGuide.style.display = "block";
        }
        checkFormValidity();
    });

    newPwd.addEventListener("input", function () {
        const val = newPwd.value.trim();
        const cVal = currentPwd.value.trim();

        if (val === "" || (passwordRegex.test(val) && val !== cVal)) {
            newPwd.classList.remove("error-input");
            newPwdError.classList.remove("show");
            newPwdGuide.style.display = "block";
        }
        checkFormValidity();
    });

    confirmPwd.addEventListener("blur", function () {
        const val = confirmPwd.value.trim();
        const nVal = newPwd.value.trim();

        if (val === "") {
            confirmPwd.classList.add("error-input");
            confirmPwdError.textContent = "꼭 입력해야 해요.";
            confirmPwdError.classList.add("show");
        } else if (val !== nVal) {
            confirmPwd.classList.add("error-input");
            confirmPwdError.textContent = "새 비밀번호가 일치하지 않습니다.";
            confirmPwdError.classList.add("show");
        } else {
            confirmPwd.classList.remove("error-input");
            confirmPwdError.classList.remove("show");
        }
        checkFormValidity();
    });

    confirmPwd.addEventListener("input", function () {
        const val = confirmPwd.value.trim();
        const nVal = newPwd.value.trim();

        if (val === "" || val === nVal) {
            confirmPwd.classList.remove("error-input");
            confirmPwdError.classList.remove("show");
        }
        checkFormValidity();
    });
});
</script>
</body>
</html>