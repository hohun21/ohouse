<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">

<title>판매자 입점 진행 상태</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    background-color: #f7f8fa;
    font-family: Arial, "맑은 고딕", sans-serif;
    color: #222;	
}

.seller-status-container {
    width: 700px;
    margin: 70px auto;
}

.page-title {
    margin-bottom: 35px;
    text-align: center;
    font-size: 30px;
}

/* 입점 처리 절차 */
.signup-process {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    margin: 0 0 45px;
    padding: 0;
    list-style: none;
}

.signup-process li {
    position: relative;
    width: 180px;
    text-align: center;
    color: #aaa;
    font-size: 15px;
    font-weight: 700;
}

.signup-process li:not(:last-child)::after {
    content: "";
    position: absolute;
    top: 22px;
    left: calc(50% + 30px);
    width: 120px;
    height: 2px;
    background-color: #ddd;
}

.step-number {
    position: relative;
    z-index: 1;
    display: flex;
    width: 46px;
    height: 46px;
    margin: 0 auto 12px;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background-color: #ddd;
    color: #777;
    font-size: 18px;
}

.signup-process li.completed {
    color: #555;
}

.signup-process li.completed .step-number {
    background-color: #555;
    color: white;
}

.signup-process li.active {
    color: #35c5f0;
}

.signup-process li.active .step-number {
    background-color: #35c5f0;
    color: white;
}

.signup-process li.completed:not(:last-child)::after {
    background-color: #555;
}

/* 본인 확인 폼 */
.verification-box,
.result-box {
    padding: 40px;
    border: 1px solid #ddd;
    border-radius: 10px;
    background-color: white;
}

.verification-box h2,
.result-box h2 {
    margin: 0 0 10px;
    text-align: center;
    font-size: 24px;
}

.description {
    margin: 0 0 30px;
    text-align: center;
    color: #777;
    line-height: 1.6;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-size: 14px;
    font-weight: 700;
}

.form-group input {
    width: 100%;
    height: 48px;
    padding: 0 14px;
    border: 1px solid #ccc;
    border-radius: 5px;
    font-size: 15px;
    outline: none;
}

.form-group input:focus {
    border-color: #35c5f0;
}

.check-button {
    width: 100%;
    height: 50px;
    border: 0;
    border-radius: 5px;
    background-color: #35c5f0;
    color: white;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
}

.check-button:hover {
    background-color: #20b2df;
}

.check-button:disabled {
    background-color: #aaa;
    cursor: default;
}

/* AJAX 처리 결과 */
#statusResult {
    display: none;
    margin-top: 30px;
}

.result-box {
    text-align: center;
}

.result-box p {
    margin: 0;
    color: #666;
    line-height: 1.8;
}

.result-box.error {
    border-color: #ffcdd2;
    background-color: #fffafa;
}

.result-box.error h2 {
    color: #e53935;
}

.result-box.error .error-detail {
    margin-top: 15px;
    color: #e53935;
    font-size: 15px;
    font-weight: 600;
}

.login-link {
    display: inline-block;
    margin-top: 25px;
    padding: 14px 45px;
    border-radius: 5px;
    background-color: #35c5f0;
    color: white;
    font-weight: 700;
    text-decoration: none;
}

.login-link:hover {
    background-color: #20b2df;
}
</style>
</head>

<body>

<div class="seller-status-container">

    <h1 class="page-title">
        판매자 입점 진행 상태
    </h1>

    <!-- 입점 처리 절차 -->
    <ol class="signup-process">

        <li id="step1">
            <span class="step-number">1</span>
            <span>입점 신청</span>
        </li>

        <li id="step2">
            <span class="step-number">2</span>
            <span>입점 심사</span>
        </li>

        <li id="step3">
            <span class="step-number">3</span>
            <span>입점 완료</span>
        </li>

    </ol>

    <!-- 판매자 본인 확인 폼 -->
    <section class="verification-box">

        <h2>입점 신청 정보 확인</h2>

        <p class="description">
            입점 신청 시 입력한 정보를 입력해 주세요.
        </p>

        <form id="statusCheckForm">

            <div class="form-group">

                <label for="email">
                    이메일
                </label>

                <input type="email"
                       id="email"
                       name="email"
                       placeholder="이메일을 입력해 주세요."
                       autocomplete="username"
                       required>

            </div>

            <div class="form-group">

                <label for="password">
                    비밀번호
                </label>

                <input type="password"
                       id="password"
                       name="password"
                       placeholder="비밀번호를 입력해 주세요."
                       autocomplete="current-password"
                       required>

            </div>

            <div class="form-group">

                <label for="businessNumber">
                    사업자등록번호
                </label>

                <input type="text"
                       id="businessNumber"
                       name="businessNumber"
                       placeholder="숫자 10자리를 입력해 주세요."
                       maxlength="10"
                       inputmode="numeric"
                       required>

            </div>

            <button type="submit"
                    id="checkButton"
                    class="check-button">

                입점 상태 확인

            </button>

        </form>

    </section>

    <!-- AJAX 결과 출력 영역 -->
    <div id="statusResult"></div>

</div>

<script>
$(function () {

    const contextPath =
            "${pageContext.request.contextPath}";


    /*
     * 사업자등록번호에는 숫자만 입력되도록 처리
     */
    $("#businessNumber").on(
            "input",
            function () {

        let number =
                $(this)
                .val()
                .replace(/[^0-9]/g, "");

        if (number.length > 10) {
            number = number.substring(0, 10);
        }

        $(this).val(number);
    });


    /*
     * 입점 상태 확인 폼 전송
     */
    $("#statusCheckForm").on(
            "submit",
            function (event) {

        event.preventDefault();

        const email =
                $("#email").val().trim();

        const password =
                $("#password").val();

        const businessNumber =
                $("#businessNumber")
                .val()
                .replace(/[^0-9]/g, "");

        /*
         * 클라이언트 유효성 검사
         */
        if (email === "") {

            resetSteps();
            showError("이메일을 입력해 주세요.");

            $("#email").focus();

            return;
        }

        if (password === "") {

            resetSteps();
            showError("비밀번호를 입력해 주세요.");

            $("#password").focus();

            return;
        }

        if (!/^\d{10}$/.test(businessNumber)) {

            resetSteps();

            showError(
                    "사업자등록번호 숫자 10자리를 입력해 주세요."
            );

            $("#businessNumber").focus();

            return;
        }

        const $button =
                $("#checkButton");

        /*
         * 이전 결과를 숨기고 버튼 비활성화
         */
        $("#statusResult")
            .stop(true, true)
            .hide()
            .empty();

        $button
            .prop("disabled", true)
            .text("확인 중...");


        /*
         * 입점 상태 AJAX 조회
         */
        $.ajax({
            url: contextPath
                    + "/seller/sellerSignupStatus.htm",

            type: "POST",
            dataType: "json",
            timeout: 10000,

            data: {
                email: email,
                password: password,
                businessNumber: businessNumber
            }
        })

        /*
         * 서버가 JSON을 정상적으로 반환한 경우
         */
        .done(function (response) {

            console.log(
                    "입점 상태 조회 응답:",
                    response
            );

            if (!response
                    || response.success !== true) {

                resetSteps();

                showError(
                        response
                        && response.message
                        ? response.message
                        : "입력한 판매자 정보를 확인해 주세요."
                );

                return;
            }

            const status =
                    String(response.status)
                    .trim()
                    .toUpperCase();

            if (status === "PENDING") {
                showPending();
                return;
            }

            if (status === "ACTIVE") {
                showActive();
                return;
            }

            // 💡 REJECTED 상태 처리 추가!
            if (status === "REJECTED") {
                showRejected();
                return;
            }

            resetSteps();

            showError(
                    "현재 입점 상태를 확인할 수 없습니다."
            );
        })

        /*
         * HTTP 요청 실패 또는 JSON 변환 실패
         */
        .fail(function (
                xhr,
                textStatus,
                errorThrown) {

            console.log(
                    "HTTP 상태:",
                    xhr.status
            );

            console.log(
                    "요청 상태:",
                    textStatus
            );

            console.log(
                    "오류:",
                    errorThrown
            );

            console.log(
                    "서버 응답:",
                    xhr.responseText
            );

            resetSteps();

            let message =
                    "입점 상태를 조회하는 중 오류가 발생했습니다.";

            if (textStatus === "timeout") {

                message =
                        "서버 응답 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요.";

            } else if (
                    xhr.responseJSON
                    && xhr.responseJSON.message) {

                message =
                        xhr.responseJSON.message;

            } else if (xhr.responseText) {

                try {
                    const errorResponse =
                            JSON.parse(
                                    xhr.responseText
                            );

                    if (errorResponse.message) {
                        message =
                                errorResponse.message;
                    }

                } catch (e) {
                    console.log(
                            "JSON 변환 실패:",
                            e
                    );
                }
            }

            showError(message);
        })

        /*
         * 성공 또는 실패와 관계없이 항상 실행
         */
        .always(function () {

            $button
                .prop("disabled", false)
                .text("입점 상태 확인");
        });

    });


    /*
     * 입점 처리 단계 초기화
     */
    function resetSteps() {

        $("#step1, #step2, #step3")
            .removeClass(
                    "completed active"
            );
    }


    /*
     * 오류 메시지 출력
     */
    function showError(message) {

        let errorMessage =
                "입력한 판매자 정보를 확인해 주세요.";

        if (typeof message === "string"
                && message.trim() !== "") {

            errorMessage =
                    message.trim();
        }

        console.log(
                "화면 오류 메시지:",
                errorMessage
        );

        const html =
                '<section class="result-box error">'
              + '    <h2>'
              + '        입점 상태를 확인할 수 없습니다.'
              + '    </h2>'
              + '    <p class="error-detail"></p>'
              + '</section>';

        const $statusResult =
                $("#statusResult");

        $statusResult
            .stop(true, true)
            .hide()
            .html(html);

        $statusResult
            .find(".error-detail")
            .text(errorMessage);

        $statusResult
            .css("display", "block");
    }


    /*
     * PENDING 상태 출력
     */
    function showPending() {

        resetSteps();

        $("#step1")
            .addClass("completed");

        $("#step2")
            .addClass("active");

        const html =
                '<section class="result-box">'
              + '    <h2>'
              + '        입점 심사가 진행 중입니다.'
              + '    </h2>'
              + '    <p>'
              + '        판매자 입점 신청이 정상적으로 접수되었습니다.<br>'
              + '        관리자가 제출하신 정보를 확인하고 있습니다.<br>'
              + '        심사가 완료될 때까지 잠시 기다려 주세요.'
              + '    </p>'
              + '</section>';

        $("#statusResult")
            .stop(true, true)
            .hide()
            .html(html)
            .slideDown();
    }


    /*
     * ACTIVE 상태 출력
     */
    function showActive() {

        resetSteps();

        $("#step1, #step2")
            .addClass("completed");

        $("#step3")
            .addClass("active");

        const loginUrl =
                contextPath
                + "/seller/login.htm";

        const html =
                '<section class="result-box">'
              + '    <h2>'
              + '        판매자 입점이 완료되었습니다.'
              + '    </h2>'
              + '    <p>'
              + '        입점 심사가 승인되었습니다.<br>'
              + '        판매자 계정으로 로그인하여 서비스를 이용해 주세요.'
              + '    </p>'
              + '    <a class="login-link" href="'
              + loginUrl
              + '">'
              + '        판매자 로그인'
              + '    </a>'
              + '</section>';

        $("#statusResult")
            .stop(true, true)
            .hide()
            .html(html)
            .slideDown();
    }
    
    /*
     * 💡 REJECTED 상태 출력 함수 추가!
     */
    function showRejected() {

        resetSteps();

        $("#step1")
            .addClass("completed");

        const html =
                '<section class="result-box error">'
              + '    <h2>'
              + '        입점 심사가 거절되었습니다.'
              + '    </h2>'
              + '    <p class="error-detail">'
              + '        입점 기준에 부합하지 않거나 서류 미비로 인해 심사가 반려되었습니다.<br>'
              + '        자세한 사유는 고객센터로 문의해 주시기 바랍니다.'
              + '    </p>'
              + '</section>';

        $("#statusResult")
            .stop(true, true)
            .hide()
            .html(html)
            .slideDown();
    }

});
</script>

</body>
</html>