<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>오늘의 집 파트너 로그인</title>

<link rel="stylesheet"
      as="style"
      crossorigin
      href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css">

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    font-family: "Pretendard", sans-serif;
}

body {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f7f8fa;
    color: #2f3438;
}

a {
    color: inherit;
    text-decoration: none;
}

.login-container {
    width: 100%;
    max-width: 430px;
    padding: 46px 40px;
    border: 1px solid #eaedef;
    border-radius: 12px;
    background-color: white;
    box-shadow: 0 8px 30px rgba(33, 38, 41, 0.06);
}

.logo {
    display: block;
    margin-bottom: 34px;
    text-align: center;
    font-size: 29px;
    font-weight: 800;
}

.logo span {
    color: #35c5f0;
}

.login-title {
    margin-bottom: 10px;
    text-align: center;
    font-size: 25px;
}

.login-description {
    margin-bottom: 30px;
    text-align: center;
    color: #828c94;
    font-size: 14px;
    line-height: 1.6;
}

.form-group {
    margin-bottom: 16px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    font-weight: 700;
}

.form-group input {
    width: 100%;
    height: 50px;
    padding: 0 15px;
    border: 1px solid #dadce0;
    border-radius: 5px;
    font-size: 15px;
    outline: none;
}

.form-group input:focus {
    border-color: #35c5f0;
    box-shadow: 0 0 0 3px rgba(53, 197, 240, 0.12);
}

.field-error {
    margin-top: 7px;
    color: #f44336;
    font-size: 13px;
}

.login-error {
    margin-bottom: 18px;
    padding: 13px 14px;
    border: 1px solid #ffcdd2;
    border-radius: 5px;
    background-color: #fff5f5;
    color: #e53935;
    font-size: 14px;
    line-height: 1.55;
}

.login-button {
    width: 100%;
    height: 52px;
    margin-top: 6px;
    border: 0;
    border-radius: 5px;
    background-color: #35c5f0;
    color: white;
    font-size: 17px;
    font-weight: 700;
    cursor: pointer;
}

.login-button:hover {
    background-color: #20b2df;
}

.links {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-top: 25px;
    color: #656e75;
    font-size: 14px;
}

.links a:hover {
    text-decoration: underline;
}

.member-login {
    display: block;
    margin-top: 30px;
    padding-top: 24px;
    border-top: 1px solid #eaedef;
    text-align: center;
    color: #828c94;
    font-size: 14px;
}

.member-login:hover {
    text-decoration: underline;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>

<body>

<main class="login-container">

    <!-- 로고 -->
    <a class="logo"
       href="${pageContext.request.contextPath}/main.htm">

        오늘의<span>집</span>

    </a>

    <h1 class="login-title">
        파트너 로그인
    </h1>

    <!-- 이메일 또는 비밀번호 불일치 -->
    <c:if test="${errors.emailOrPwNotMatch}">

        <div class="login-error">
            이메일, 비밀번호 또는 사업자등록번호가 일치하지 않습니다.
        </div>

    </c:if>


    <!-- 아직 입점 심사가 완료되지 않은 판매자 -->
    <c:if test="${errors.notActive}">

        <div class="login-error">

            아직 입점 심사가 완료되지 않은 계정입니다.<br>
            입점 진행 상태를 먼저 확인해 주세요.

        </div>

    </c:if>


    <!-- 판매자 로그인 폼 -->
    <form action="${pageContext.request.contextPath}/seller/login.htm"
           id="loginForm" method="post">

        <!-- 이메일 -->
        <div class="form-group">

            <label for="email">
                이메일
            </label>

            <input type="email"
                   id="email"
                   name="email"
                   value="<c:out value='${email}'/>"
                   placeholder="이메일을 입력해 주세요."
                   autocomplete="username">

            <c:if test="${errors.email}">

                <p class="field-error">
                    이메일을 입력해 주세요.
                </p>

            </c:if>

        </div>


        <!-- 비밀번호 -->
        <div class="form-group">

            <label for="password">
                비밀번호
            </label>

            <input type="password"
                   id="password"
                   name="password"
                   placeholder="비밀번호를 입력해 주세요."
                   autocomplete="current-password">

            <c:if test="${errors.password}">

                <p class="field-error">
                    비밀번호를 입력해 주세요.
                </p>

            </c:if>

        </div>
        
        <!-- 사업자등록번호 -->
		<div class="form-group">
		
		    <label for="businessNumber">
		        사업자등록번호
		    </label>
		
		    <input type="text"
		           id="businessNumber"
		           name="businessNumber"
		           value="<c:out value='${businessNumber}'/>"
		           placeholder="사업자등록번호 숫자 10자리를 입력해 주세요."
		           maxlength="10"
		           inputmode="numeric">
		
		    <c:if test="${errors.businessNumber}">
		
		        <p class="field-error">
		            사업자등록번호 숫자 10자리를 입력해 주세요.
		        </p>
		
		    </c:if>
		
		</div>


        <button type="submit"
                class="login-button">

            파트너 로그인

        </button>

    </form>


    <!-- 판매자 관련 링크 -->
    <div class="links">

        <a href="${pageContext.request.contextPath}/seller/sellerSignupStatus.htm">
            입점 상태 확인
        </a>

        <a href="${pageContext.request.contextPath}/seller/signup.htm">
            파트너 회원가입
        </a>

    </div>


    <!-- 일반 회원 로그인 -->
    <a class="member-login"
       href="${pageContext.request.contextPath}/login.htm">

        일반 회원 로그인으로 이동

    </a>

</main>
<script>
	document.getElementById("businessNumber")
			.addEventListener("input", function () {
        let number = this.value.replace(/[^0-9]/g, "");
        if (number.length > 10) {
            number = number.substring(0, 10);
        }
        this.value = number;
    });
</script>
<script>
$(function () {
    // 로그인 버튼을 눌렀을 때 상태 확인
    $("#loginForm").on("submit", function (event) {
        event.preventDefault();

        const form = this;
        const email = $("#email").val().trim();

        if (email === "") {
            alert(" 이메일을 입력해주세요.");
            $("#email").focus();
            return;
        }

        $.ajax({
            url: "${pageContext.request.contextPath}/sellerStatusCheck.ajax",
            type: "GET",
            data: {
                email: email
            },
            dataType: "json",

            success: function (result) {

                if (result.code === "WITHDRAWN") {
                    alert("탈퇴한 계정입니다.");
                    return;
                }

                if (result.code === "STOP") {
                    alert("정지된 계정입니다.");
                    return;
                }

                if (result.code === "NOT_FOUND") {
                    alert("등록되지 않은 계정입니다.");
                    return;
                }

                if (result.code === "ACTIVE") {
                    // 정상 회원인 경우에만 실제 로그인 요청
                    form.submit();
                    return;
                }

                alert("회원 상태를 확인할 수 없습니다.");
            },

            error: function (xhr, textStatus, errorThrown) {
            	console.log("HTTP 상태:", xhr.status);
                console.log("jQuery 상태:", textStatus);
                console.log("파싱 오류:", errorThrown);
                console.log("실제 서버 응답:", xhr.responseText);

                alert("서버 오류가 발생했습니다. 상태 코드: " + xhr.status);
            }
        });
    });
});
</script>
</body>
</html>