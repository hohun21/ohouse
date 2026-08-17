<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 - 오늘의집</title>
<!-- 프리텐다드 폰트 적용 -->
<link rel="stylesheet" as="style" crossorigin
    href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<style>
* {
    box-sizing: border-box;
    font-family: 'Pretendard', sans-serif;
    margin: 0;
    padding: 0;
}

/* 화면 정중앙 배치를 위한 Flexbox 설정 */
body {
    background-color: #FAFAFA;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
    position: relative;
}

a {
    text-decoration: none;
    color: inherit;
}

/* 🌟 1. 메인 로그인 컨테이너 */
.login-container {
    width: 100%;
    max-width: 360px;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-bottom: 40px;
}

/* 🌟 2. 로고 영역 */
.logo-area {
    display: flex;
    justify-content: center;
    margin-bottom: 40px;
    cursor: pointer;
}

.logo-area svg {
    height: 50px;
    width: auto;
}

/* 입력 폼 영역 */
form {
    width: 100%;
}

/* 🌟 3. 이메일, 비밀번호 그룹 */
.input-group {
    width: 100%;
    border: 1px solid #DADCE0;
    border-radius: 4px;
    overflow: hidden;
    background: #fff;
    margin-bottom: 20px;
}

.input-group input {
    width: 100%;
    border: none;
    padding: 16px 18px;
    font-size: 16px;
    outline: none;
    color: #2F3438;
}

.input-group input::placeholder {
    color: #BDBDBD;
    font-weight: 400;
}

.input-group input:first-child {
    border-bottom: 1px solid #DADCE0;
}

.input-group input:focus {
    background-color: #FAFAFA;
}

/* 🌟 4. 로그인 버튼 */
.btn-login {
    width: 100%;
    padding: 18px;
    background-color: #1496f4;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 18px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.2s;
}

.btn-login:hover {
    background-color: #0b80d6;
}

/* 텍스트 링크 */
.sub-links {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 24px;
    margin-top: 24px;
    font-size: 14px;
    color: #424242;
}

.sub-links a:hover {
    text-decoration: underline;
}

/* SNS 간편 로그인 영역 */
.sns-login-area {
    margin-top: 55px;
    text-align: center;
    width: 100%;
}

.sns-title {
    font-size: 13px;
    color: #757575;
    margin-bottom: 20px;
}

.sns-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin-bottom: 40px;
}

/* 🌟 5. SNS 버튼 크기 */
.sns-btn {
    width: 54px;
    height: 54px;
    border-radius: 50%;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    border: none;
    transition: opacity 0.2s;
}

.sns-btn:hover {
    opacity: 0.85;
}

.sns-btn.facebook {
    background-color: #3b5998;
    color: white;
    font-size: 30px;
    font-family: serif;
    font-style: italic;
    font-weight: bold;
    padding-top: 4px;
    padding-right: 2px;
}

.sns-btn.kakao {
    background-color: #FEE500;
    color: #381E1F;
    font-size: 15px;
    font-weight: 900;
}

.sns-btn.naver {
    background-color: #03C75A;
    color: white;
    font-size: 22px;
    font-weight: 900;
}

/* 하단 링크 및 구분선 */
.trouble-link {
    font-size: 14px;
    color: #9E9E9E;
    margin-bottom: 25px;
    display: block;
    text-align: center;
}

.trouble-link:hover {
    text-decoration: underline;
}

.divider {
    width: 100%;
    height: 1px;
    background-color: #EAEDEF;
    margin-bottom: 25px;
}

.guest-link {
    font-size: 14px;
    color: #424242;
    text-align: center;
    display: block;
    cursor: pointer;
}

.guest-link:hover {
    text-decoration: underline;
}

/* 최하단 카피라이트 */
.copyright {
    position: absolute;
    bottom: 30px;
    font-size: 12px;
    color: #9E9E9E;
    text-align: center;
    width: 100%;
}
</style>
</head>
<body>

    <div class="login-container">
        <!-- 로고 -->
        <!-- 로고 클릭 시 메인페이지(main.htm)로 이동하도록 링크 수정 -->
        <a href="main.htm" class="logo-area"> <svg
                xmlns="http://www.w3.org/2000/svg" viewBox="0 0 481 136">
                <path fill="#111"
                    d="M459.317 41.715H443.04c.134 2.783 1.008 5.303 4.532 8.903s9.133 7.32 15.825 11.457l-6.497 10.51c-6.865-4.243-13.264-8.501-17.985-13.322-.983-1.004-1.92-1.884-2.791-2.98a30 30 0 0 1-2.791 3.323c-4.721 4.82-11.12 9.251-17.985 13.494l-6.497-10.51c6.692-4.137 12.3-8.03 15.825-11.63 3.525-3.599 4.398-6.462 4.532-9.245h-16.277V30.73h46.386zM202.316 29.28c17.481 0 26.613 11.252 26.613 24.263v1.758c0 11.355-6.9 21.37-20.325 23.736V91.98h32.522v10.983h-78.087V91.981h32.522V79.04c-13.441-2.358-20.349-12.378-20.349-23.74v-1.758c0-13.01 9.132-24.263 26.613-24.263zm-.245 10.64c-9.429 0-14.073 6.716-14.073 13.79v1.424c0 7.074 4.714 13.79 14.073 13.79s14.073-6.716 14.073-13.79V53.71c0-7.074-4.645-13.79-14.073-13.79m197.014 73.188h-13.043V94.844c-3.364.484-9.354 1.26-18.175 2.086-14.622 1.372-40.328 1.125-40.328 1.125l-.209-11.819s25.813.169 39.599-.952c9.613-.782 16.079-1.739 19.113-2.247V26.154h13.043zM353.77 30.996c14.752 0 22.408 9.841 22.408 21.089v1.757c0 11.247-7.728 21.088-22.408 21.088l-.491-.005c-14.68 0-22.408-9.836-22.408-21.083v-1.757c0-11.248 7.656-21.089 22.408-21.089zm-.245 10.726c-6.727 0-10.126 5.376-10.126 10.706v1.07c0 5.897 3.399 10.684 10.127 10.706 6.662.022 10.124-4.82 10.124-10.706v-1.07c0-5.33-3.462-10.706-10.125-10.706M268.667 43.4h44.696v10.813h-57.739V26.85h13.043zm-23.778 26.215h78.086V58.803h-78.086z" />
                <path fill="#111"
                    d="M479.999 99.939c-.011 10.413-2.221 12.533-12.761 12.54-11.69.007-18.439.011-30.148 0-10.245-.01-12.616-2.046-12.697-11.824-.077-9.232.002-25.554.002-25.567h13.043v9.153h29.69V26.155H480s.03 45.359-.001 73.784m-42.561 1.728h29.69V94.71h-29.69zM313.005 74.209l.004 24.48h-45.043v4.739h46.979v10.297h-47.151c-10.653 0-12.846-2.098-12.871-12.595-.01-4.223 0-12.396 0-12.396h45.039v-4.4h-44.691V74.208z" />
                <path fill="#00a1ff"
                    d="M75.001 1.243a20.72 20.72 0 0 0-14.136 0c-8.591 3.093-36.22 21.208-51.007 36.46C1.88 45.928 0 51.618 0 61.48v5.078c.126 15.644.914 34.269 3.675 43.324 4.773 15.652 11.949 25.984 57.295 25.984h13.926c45.345 0 52.521-10.332 57.295-25.984 2.761-9.055 3.549-27.68 3.675-43.325v-5.078c0-9.861-1.882-15.551-9.858-23.777-14.789-15.25-42.414-33.366-51.007-36.459" />
            </svg>
        </a>

        <!-- 💡 폼 제출 경로를 MVC 패턴 규칙인 .htm 으로 수정 -->
        <form action="login.htm" method="post">
            <div class="input-group">
                <input type="email" name="email" placeholder="이메일" required>
                <input type="password" name="password" placeholder="비밀번호" required>
            </div>
            <button type="submit" class="btn-login">로그인</button>
        </form>

        <!-- 회원가입 링크도 나중에 연결할 signup.htm 으로 미리 수정해두었습니다 -->
        <div class="sub-links">
            <a href="#">비밀번호 재설정</a> <a href="signup.htm">회원가입</a>
        </div>

        <!-- SNS 로그인 -->
        <div class="sns-login-area">
            <div class="sns-title">SNS계정으로 간편 로그인/회원가입</div>
            <div class="sns-buttons">
                <button class="sns-btn facebook">f</button>
                <button class="sns-btn kakao">TALK</button>
                <button class="sns-btn naver">N</button>
            </div>

            <a href="#" class="trouble-link">로그인에 문제가 있으신가요?</a>
            <div class="divider"></div>
            <a href="#" class="guest-link">비회원 주문 조회하기</a>
        </div>
    </div>

    <!-- 카피라이트 -->
    <div class="copyright">© bucketplace, Co., Ltd.. All Rights
        Reserved</div>

</body>
</html>