<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - 오늘의집</title>
    <!-- 프리텐다드 폰트 적용 -->
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <style>
        * { box-sizing: border-box; font-family: 'Pretendard', sans-serif; margin: 0; padding: 0; }
        body { background-color: #fff; color: #2F3438; display: flex; flex-direction: column; align-items: center; padding-bottom: 80px; }
        a { text-decoration: none; color: inherit; }

        /* 좌측 상단 로고 (위치 오른쪽으로 살짝 이동 & SVG 적용) */
        .header-logo { width: 100%; padding: 40px 0 0 60px; }
        .logo-area { display: inline-flex; align-items: center; cursor: pointer; }
        .logo-area svg { height: 42px; width: auto; } /* 로고 크기도 로그인과 동일하게 확대 */

        /* 메인 컨테이너 (가로 넓이 400px -> 440px로 확대) */
        .signup-container { width: 100%; max-width: 440px; margin-top: 20px; }
        .page-title { font-size: 24px; font-weight: 700; text-align: left; margin-bottom: 40px; }

        /* SNS 간편 회원가입 */
        .sns-area { text-align: center; margin-bottom: 35px; }
        .sns-title { font-size: 13px; color: #757575; margin-bottom: 18px; }
        .sns-buttons { display: flex; justify-content: center; gap: 20px; }
        
        /* SNS 버튼 크기 확대 (48px -> 54px) */
        .sns-btn { width: 54px; height: 54px; border-radius: 50%; display: flex; justify-content: center; align-items: center; cursor: pointer; border: none; transition: opacity 0.2s; }
        .sns-btn:hover { opacity: 0.85; }
        .sns-btn.facebook { background-color: #3b5998; color: white; font-size: 30px; font-family: serif; font-style: italic; font-weight: bold; padding-top: 4px; padding-right: 2px; }
        .sns-btn.kakao { background-color: #FEE500; color: #381E1F; font-size: 15px; font-weight: 900; }
        .sns-btn.naver { background-color: #03C75A; color: white; font-size: 22px; font-weight: 900; }
        
        .divider { width: 100%; height: 1px; background-color: #EAEDEF; margin-bottom: 35px; }

        /* 폼 입력 영역 (글자 크기 & 패딩 확대) */
        .form-group { margin-bottom: 30px; }
        .label { display: block; font-size: 15px; font-weight: 700; margin-bottom: 12px; }
        .sub-text { font-size: 13px; color: #757575; margin-bottom: 10px; display: block; }
        
        .input-box { width: 100%; border: 1px solid #DADCE0; border-radius: 4px; padding: 15px; font-size: 16px; outline: none; color: #2F3438; }
        .input-box:focus { border-color: #1496f4; }
        .input-box::placeholder { color: #BDBDBD; }

        /* 이메일 입력 특수 레이아웃 (크기 확대) */
        .email-wrap { display: flex; align-items: center; gap: 6px; margin-bottom: 12px; }
        .email-wrap input { flex: 1; padding: 15px; border: 1px solid #DADCE0; border-radius: 4px; font-size: 16px; outline: none; color: #2F3438; }
        .email-wrap input:focus { border-color: #1496f4; }
        .email-wrap span { color: #BDBDBD; font-size: 16px; font-weight: 600; }
        .email-wrap select { flex: 1; padding: 15px; border: 1px solid #DADCE0; border-radius: 4px; font-size: 16px; outline: none; color: #757575; background: #fff; cursor: pointer; }
        .email-wrap select:focus { border-color: #1496f4; }
        
        /* 인증 버튼 확대 */
        .btn-verify { width: 100%; padding: 15px; background-color: #F7F9FA; color: #BDBDBD; border: 1px solid #EAEDEF; border-radius: 4px; font-size: 15px; font-weight: 700; cursor: pointer; transition: background-color 0.2s; }
        .btn-verify:hover { background-color: #F0F2F4; }

        /* 약관 동의 박스 (크기 확대) */
        .terms-box { border: 1px solid #DADCE0; border-radius: 4px; padding: 0 18px; background: #fff; margin-bottom: 25px; }
        .term-item { display: flex; align-items: center; justify-content: space-between; padding: 18px 0; border-bottom: 1px solid #EAEDEF; font-size: 15px; color: #2F3438; cursor: pointer; }
        .term-item:last-child { border-bottom: none; }
        .term-left { display: flex; align-items: center; gap: 12px; }
        .term-left input[type="checkbox"] { width: 20px; height: 20px; accent-color: #1496f4; cursor: pointer; }
        .term-item.bold .term-left span { font-weight: 700; }
        .term-sub { font-size: 13px; color: #9E9E9E; font-weight: 400; margin-left: 6px; }
        .term-arrow { color: #BDBDBD; font-weight: 700; font-size: 16px; }

        /* 리캡챠 가짜 UI (크기 확대) */
        .recaptcha-box { border: 1px solid #DADCE0; border-radius: 4px; background: #FAFAFA; padding: 18px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px; }
        .recaptcha-left { display: flex; align-items: center; gap: 12px; font-size: 15px; font-weight: 500; }
        .recaptcha-checkbox { width: 28px; height: 28px; border: 2px solid #C1C1C1; border-radius: 2px; background: #fff; }
        .recaptcha-right { text-align: center; font-size: 11px; color: #9E9E9E; }
        .recaptcha-icon { font-size: 24px; margin-bottom: 4px; }

        /* 제출 버튼 (파란색 & 크기 확대) */
        .btn-submit { width: 100%; padding: 18px; background-color: #1496f4; color: white; border: none; border-radius: 4px; font-size: 18px; font-weight: 700; cursor: pointer; margin-bottom: 25px; transition: background-color 0.2s; }
        .btn-submit:hover { background-color: #0b80d6; }

        /* 하단 링크 */
        .login-link { text-align: center; font-size: 15px; color: #424242; }
        .login-link a { font-weight: 700; text-decoration: underline; margin-left: 6px; }
    </style>
</head>
<body>

    <header class="header-logo">
        <!-- 💡 로고 클릭 시 메인페이지(main.htm)로 가도록 링크 수정 -->
        <a href="main.htm" class="logo-area">
            <!-- 찐 오늘의집 SVG 로고 적용 -->
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 481 136">
                <path fill="#111" d="M459.317 41.715H443.04c.134 2.783 1.008 5.303 4.532 8.903s9.133 7.32 15.825 11.457l-6.497 10.51c-6.865-4.243-13.264-8.501-17.985-13.322-.983-1.004-1.92-1.884-2.791-2.98a30 30 0 0 1-2.791 3.323c-4.721 4.82-11.12 9.251-17.985 13.494l-6.497-10.51c6.692-4.137 12.3-8.03 15.825-11.63 3.525-3.599 4.398-6.462 4.532-9.245h-16.277V30.73h46.386zM202.316 29.28c17.481 0 26.613 11.252 26.613 24.263v1.758c0 11.355-6.9 21.37-20.325 23.736V91.98h32.522v10.983h-78.087V91.981h32.522V79.04c-13.441-2.358-20.349-12.378-20.349-23.74v-1.758c0-13.01 9.132-24.263 26.613-24.263zm-.245 10.64c-9.429 0-14.073 6.716-14.073 13.79v1.424c0 7.074 4.714 13.79 14.073 13.79s14.073-6.716 14.073-13.79V53.71c0-7.074-4.645-13.79-14.073-13.79m197.014 73.188h-13.043V94.844c-3.364.484-9.354 1.26-18.175 2.086-14.622 1.372-40.328 1.125-40.328 1.125l-.209-11.819s25.813.169 39.599-.952c9.613-.782 16.079-1.739 19.113-2.247V26.154h13.043zM353.77 30.996c14.752 0 22.408 9.841 22.408 21.089v1.757c0 11.247-7.728 21.088-22.408 21.088l-.491-.005c-14.68 0-22.408-9.836-22.408-21.083v-1.757c0-11.248 7.656-21.089 22.408-21.089zm-.245 10.726c-6.727 0-10.126 5.376-10.126 10.706v1.07c0 5.897 3.399 10.684 10.127 10.706 6.662.022 10.124-4.82 10.124-10.706v-1.07c0-5.33-3.462-10.706-10.125-10.706M268.667 43.4h44.696v10.813h-57.739V26.85h13.043zm-23.778 26.215h78.086V58.803h-78.086z"/>
                <path fill="#111" d="M479.999 99.939c-.011 10.413-2.221 12.533-12.761 12.54-11.69.007-18.439.011-30.148 0-10.245-.01-12.616-2.046-12.697-11.824-.077-9.232.002-25.554.002-25.567h13.043v9.153h29.69V26.155H480s.03 45.359-.001 73.784m-42.561 1.728h29.69V94.71h-29.69zM313.005 74.209l.004 24.48h-45.043v4.739h46.979v10.297h-47.151c-10.653 0-12.846-2.098-12.871-12.595-.01-4.223 0-12.396 0-12.396h45.039v-4.4h-44.691V74.208z"/>
                <path fill="#1496f4" d="M75.001 1.243a20.72 20.72 0 0 0-14.136 0c-8.591 3.093-36.22 21.208-51.007 36.46C1.88 45.928 0 51.618 0 61.48v5.078c.126 15.644.914 34.269 3.675 43.324 4.773 15.652 11.949 25.984 57.295 25.984h13.926c45.345 0 52.521-10.332 57.295-25.984 2.761-9.055 3.549-27.68 3.675-43.325v-5.078c0-9.861-1.882-15.551-9.858-23.777-14.789-15.25-42.414-33.366-51.007-36.459"/>
            </svg>
        </a>
    </header>

    <main class="signup-container">
        <h1 class="page-title">회원가입</h1>

        <!-- SNS 가입 -->
        <div class="sns-area">
            <div class="sns-title">SNS계정으로 간편하게 회원가입</div>
            <div class="sns-buttons">
                <button class="sns-btn facebook" type="button">f</button>
                <button class="sns-btn kakao" type="button">TALK</button>
                <button class="sns-btn naver" type="button">N</button>
            </div>
        </div>

        <div class="divider"></div>

        <!-- 💡 회원가입 폼 제출 경로를 MVC 패턴 규칙인 .htm 으로 수정 -->
        <form action="signup.htm" method="post">
            
            <!-- 이메일 -->
            <div class="form-group">
                <label class="label">이메일</label>
                <div class="email-wrap">
                    <input type="text" name="emailId" placeholder="이메일" required>
                    <span>@</span>
                    <select name="emailDomain" required>
                        <option value="">선택해주세요</option>
                        <option value="naver.com">naver.com</option>
                        <option value="gmail.com">gmail.com</option>
                        <option value="daum.net">daum.net</option>
                    </select>
                </div>
                <button type="button" class="btn-verify">이메일 인증하기</button>
            </div>

            <!-- 비밀번호 -->
            <div class="form-group">
                <label class="label">비밀번호</label>
                <span class="sub-text">영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.</span>
                <input type="password" name="password" class="input-box" placeholder="비밀번호" required>
            </div>

            <!-- 비밀번호 확인 -->
            <div class="form-group">
                <label class="label">비밀번호 확인</label>
                <input type="password" name="passwordConfirm" class="input-box" placeholder="비밀번호 확인" required>
            </div>

            <!-- 닉네임 -->
            <div class="form-group">
                <label class="label">닉네임</label>
                <span class="sub-text">다른 유저와 겹치지 않도록 입력해주세요. (2~20자)</span>
                <input type="text" name="nickname" class="input-box" placeholder="별명 (2~20자)" required>
            </div>

            <!-- 약관 동의 -->
            <div class="form-group">
                <label class="label">약관동의</label>
                <div class="terms-box">
                    <label class="term-item bold">
                        <div class="term-left">
                            <input type="checkbox" id="checkAll">
                            <span>전체동의 <span class="term-sub">선택항목에 대한 동의 포함</span></span>
                        </div>
                    </label>
                    <label class="term-item">
                        <div class="term-left">
                            <input type="checkbox" name="agreeAge" required>
                            <span>만 14세 이상입니다 <span class="term-sub" style="color:#1496f4;">(필수)</span></span>
                        </div>
                    </label>
                    <label class="term-item">
                        <div class="term-left">
                            <input type="checkbox" name="agreeTerms" required>
                            <span>이용약관 <span class="term-sub" style="color:#1496f4;">(필수)</span></span>
                        </div>
                        <span class="term-arrow">&gt;</span>
                    </label>
                    <label class="term-item">
                        <div class="term-left">
                            <input type="checkbox" name="agreeMarketing">
                            <span>개인정보 마케팅 활용 동의 <span class="term-sub">(선택)</span></span>
                        </div>
                        <span class="term-arrow">&gt;</span>
                    </label>
                    <label class="term-item">
                        <div class="term-left">
                            <input type="checkbox" name="agreeEvent">
                            <span>이벤트, 쿠폰, 특가 알림 메일 및 SMS 등 수신 <span class="term-sub">(선택)</span></span>
                        </div>
                    </label>
                </div>
            </div>

            <!-- 리캡챠 (디자인용 Mockup) -->
            <div class="recaptcha-box">
                <div class="recaptcha-left">
                    <div class="recaptcha-checkbox"></div>
                    <span>로봇이 아닙니다.</span>
                </div>
                <div class="recaptcha-right">
                    <div class="recaptcha-icon">♻️</div>
                    <div>reCAPTCHA</div>
                </div>
            </div>

            <button type="submit" class="btn-submit">회원가입하기</button>
        </form>

        <!-- 💡 로그인 페이지 링크 수정 -->
        <div class="login-link">
            이미 아이디가 있으신가요? <a href="login.htm">로그인</a>
        </div>
    </main>

</body>
</html>