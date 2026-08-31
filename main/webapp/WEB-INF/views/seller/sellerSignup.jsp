<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>오늘의 집 파트너 회원가입</title>

<style>
* { box-sizing: border-box; }
body { margin: 0; color: #2f3438; font-family: Arial, "Noto Sans KR", sans-serif; background-color: #f7f8fa; }
a { color: inherit; text-decoration: none; }

button, input, select { font-family: inherit; }

/* 헤더 */
.header { height: 72px; padding: 0 40px; display: flex; align-items: center; justify-content: space-between; background-color: #fff; border-bottom: 1px solid #eaedef; }

.logo { color: #35c5f0; font-size: 23px; font-weight: 800; }

.login-link { font-size: 14px; font-weight: 700; }
.login-link:hover { color: #35c5f0; }

/* 전체 영역 */
.container { width: 680px; max-width: calc(100% - 40px); margin: 55px auto 100px; }
.page-title { margin: 0 0 40px; text-align: center; font-size: 30px; }

/* 입점 절차 */
.steps { position: relative; display: flex; margin-bottom: 48px; }
.steps::before { content: ""; position: absolute; top: 19px; left: 16%; right: 16%; height: 2px; background-color: #dfe3e8; }
.step { position: relative; z-index: 1; width: 33.33%; color: #a4acb3; text-align: center; font-size: 14px; }
.step strong { width: 40px; height: 40px; margin: 0 auto 11px; display: flex; align-items: center; justify-content: center; color: #fff; background-color: #c7cdd2; border-radius: 50%; }
.step span { display: block; }
.step.active { color: #2f3438; font-weight: 700; }
.step.active strong { background-color: #35c5f0; }

/* 안내 사항 */
.notice { margin-bottom: 25px; padding: 22px 25px; color: #656e75; background-color: #fff; border: 1px solid #eaedef; border-radius: 8px; font-size: 14px; line-height: 1.7; }
.notice strong { color: #2f3438; }
.notice p { margin: 5px 0 0; }

/* 회원가입 폼 */
.signup-form { padding: 40px; background-color: #fff; border: 1px solid #eaedef; border-radius: 8px; }
.form-section + .form-section { margin-top: 40px; padding-top: 35px; border-top: 1px solid #eaedef; }
.form-section h2 { margin: 0 0 25px; font-size: 20px; }
.form-label { display: block; margin: 20px 0 9px; font-size: 14px; font-weight: 700; }
.required { margin-left: 3px; color: #35c5f0; }
.signup-form input, .signup-form select { width: 100%; height: 48px; padding: 0 14px; border: 1px solid #dadde0; border-radius: 4px; outline: none; background-color: #fff; font-size: 15px; }
.signup-form input::placeholder { color: #b1b8be; }
.signup-form input:focus, .signup-form select:focus { border-color: #35c5f0; }

/* 이메일 */
.email-group { display: flex; align-items: center; gap: 10px; }
.email-group input, .email-group select { flex: 1; min-width: 0; }
.email-group span { color: #828c94; }

/* 버튼이 포함된 입력창 */
.input-button-group { display: flex; gap: 10px; }
.input-button-group input { flex: 1; min-width: 0; }
.sub-button { width: 110px; height: 48px; flex-shrink: 0; border: 1px solid #35c5f0; border-radius: 4px; color: #35c5f0; font-weight: 700; background-color: #fff; cursor: pointer; }
.sub-button:hover { color: #fff; background-color: #35c5f0; }
.address-detail { margin-top: 10px; }

/* 유효성 검사 메시지 */
.error-message { margin: 7px 0 0; color: #f06060; font-size: 13px; }

/* 약관 동의 */
.agreement { margin-top: 35px; display: flex; align-items: flex-start; color: #656e75; font-size: 14px; line-height: 20px; cursor: pointer; }
.agreement input { width: 18px; height: 18px; margin: 1px 9px 0 0; flex-shrink: 0; }

/* 가입 버튼 */
.submit-button { width: 100%; height: 54px; margin-top: 25px; border: 0; border-radius: 4px; color: #fff; background-color: #35c5f0; font-size: 16px; font-weight: 700; cursor: pointer; }
.submit-button:hover { background-color: #09addb; }

/* 로그인 안내 */
.login-guide { margin: 25px 0 0; color: #656e75; text-align: center; font-size: 14px; }
.login-guide a { margin-left: 7px; color: #2f3438; font-weight: 700; text-decoration: underline; }

/* 모바일 */
@media (max-width: 600px) {
    .header { padding: 0 20px; }
    .logo { font-size: 19px; }
    .container { margin-top: 35px; }
    .page-title { font-size: 26px; }
    .signup-form { padding: 28px 20px; }
    .email-group { flex-wrap: wrap; }
    .email-group input, .email-group select { flex: 1 1 40%; }
    .input-button-group { flex-direction: column; }
    .sub-button { width: 100%; }
}
.error-message {
    margin: 7px 0 0;
    color: #f06060;
    font-size: 13px;
}

.success-message {
    margin: 7px 0 0;
    color: #35c5f0;
    font-size: 13px;
}
</style>
</head>

<body>

<header class="header">
    <a class="logo"
       href="${pageContext.request.contextPath}/main.htm">
        오늘의 집
    </a>

    <a class="login-link"
       href="${pageContext.request.contextPath}/seller/login.htm">
        오늘의 집 파트너 로그인
    </a>
</header>

<main class="container">

    <h1 class="page-title">판매자 회원가입</h1>

    <!-- 입점 절차 -->
    <div class="steps">
        <div class="step active">
            <strong>01</strong>
            <span>입점 신청</span>
        </div>

        <div class="step">
            <strong>02</strong>
            <span>입점 심사</span>
        </div>

        <div class="step">
            <strong>03</strong>
            <span>입점 완료</span>
        </div>
    </div>

    <!-- 안내 사항 -->
    <div class="notice">
        <strong>판매자 정보 입력 안내</strong>
        <p>입력한 사업자 정보는 상품 페이지의 판매자 정보에 표시됩니다.</p>
        <p>사업자등록증과 동일한 정보를 정확하게 입력해 주세요.</p>
        <p>입점 신청이 완료되면 담당자가 입력 내용을 검토합니다.</p>
    </div>

    <!-- 판매자 회원가입 폼 -->
    <form class="signup-form"
          action="${pageContext.request.contextPath}/seller/signup.htm"
          method="post">

        <!-- 계정 정보 -->
        <section class="form-section">
            <h2>계정 정보</h2>

            <label class="form-label" for="emailId">
                이메일<span class="required">*</span>
            </label>

            <div class="email-group">
                <input type="text"
                       id="emailId"
                       name="emailId"
                       value="${param.emailId}"
                       placeholder="이메일"
                       required>

                <span>@</span>

                <select id="emailDomain"
                        name="emailDomain"
                        required>
                    <option value="">선택해주세요</option>

                    <option value="naver.com"
                        ${param.emailDomain == 'naver.com' ? 'selected' : ''}>
                        naver.com
                    </option>

                    <option value="gmail.com"
                        ${param.emailDomain == 'gmail.com' ? 'selected' : ''}>
                        gmail.com
                    </option>

                    <option value="daum.net"
                        ${param.emailDomain == 'daum.net' ? 'selected' : ''}>
                        daum.net
                    </option>
                </select>
            </div>
            <p id="emailMessage"
			   class="error-message"
			   style="display:none;">
			</p>

            <c:if test="${errors.emailId}">
                <p class="error-message">이메일을 입력해 주세요.</p>
            </c:if>
            
            <c:if test="${errors.emailDomain}">
                <p class="error-message">이메일 도메인을 선택해 주세요.</p>
            </c:if>

            <c:if test="${errors.duplicateEmail}">
                <p class="error-message">이미 가입된 이메일입니다.</p>
            </c:if>

            <c:if test="${errors.invalidEmail}">
                <p class="error-message">올바른 이메일 형식이 아닙니다.</p>
            </c:if>

            <label class="form-label" for="password">
                비밀번호<span class="required">*</span>
            </label>

            <input type="password"
                   id="password"
                   name="password"
                   minlength="8"
                   maxlength="20"
                   placeholder="8자 이상 입력해 주세요"
                   required>
			<p id="passwordMessage"
			   class="error-message"
			   style="display:none;">
			</p>
            <c:if test="${errors.password}">
                <p class="error-message">비밀번호를 입력해 주세요.</p>
            </c:if>

            <c:if test="${errors.invalidPassword}">
                <p class="error-message">
                영문, 숫자를 포함한 8자 이상의 비밀번호를 입력해주세요.</p>
            </c:if>

            <label class="form-label" for="passwordConfirm">
                비밀번호 확인<span class="required">*</span>
            </label>

            <input type="password"
                   id="passwordConfirm"
                   name="passwordConfirm"
                   minlength="8"
                   maxlength="20"
                   placeholder="비밀번호를 다시 입력해 주세요"
                   required>

            <p id="passwordConfirmMessage"
			   class="error-message"
			   style="display:none;">
			</p>
            <c:if test="${errors.notMatch}">
                <p class="error-message">비밀번호가 일치하지 않습니다.</p>
            </c:if>
        </section>

        <!-- 사업자 정보 -->
        <section class="form-section">
            <h2>사업자 정보</h2>

            <label class="form-label" for="brandName">
                상호<span class="required">*</span>
            </label>

            <input type="text"
                   id="brandName"
                   name="brandName"
                   value="${param.brandName}"
                   placeholder="사업자등록증에 표시된 상호"
                   required>
            <p id="brandNameMessage" class="error-message" style="display:none;"></p>

            <label class="form-label" for="representativeName">
                대표자<span class="required">*</span>
            </label>

            <input type="text"
                   id="representativeName"
                   name="representativeName"
                   value="${param.representativeName}"
                   placeholder="대표자 이름"
                   required>

            <label class="form-label" for="businessNumber">
                사업자 등록번호<span class="required">*</span>
            </label>

            <div class="input-button-group">
                <input type="text"
                       id="businessNumber"
                       name="businessNumber"
                       value="${param.businessNumber}"
                       maxlength="10"
                       inputmode="numeric"
                       pattern="[0-9]{10}"
                       placeholder="- 없이 숫자 10자리"
                       required>

                <button type="button"
                        class="sub-button"
                        id="businessVerifyButton">
                    인증하기
                </button>
            </div>

            <p class="error-message"
               id="businessNumberMessage"
               style="display:none;">
            </p>

            <label class="form-label" for="mailOrderNumber">
                통신판매업 신고번호<span class="required">*</span>
            </label>

            <input type="text"
                   id="mailOrderNumber"
                   name="mailOrderNumber"
                   value="${param.mailOrderNumber}"
                   placeholder="예: 2026-서울강남-1234"
                   required>
            <%-- 💡 여기로 메시지 위치를 옮겼습니다! --%>
            <p id="mailOrderNumberMessage" class="error-message" style="display:none;"></p>
        </section>

        <!-- 판매자 연락처 -->
        <section class="form-section">
            <h2>판매자 연락처</h2>

            <label class="form-label" for="businessAddrLine1">
                사업장 소재지<span class="required">*</span>
            </label>

            <input type="text"
                   id="businessAddrLine1"
                   name="businessAddrLine1"
                   value="${param.businessAddrLine1}"
                   placeholder="사업장 기본 주소"
                   required>

            <input type="text"
                   class="address-detail"
                   id="businessAddrLine2"
                   name="businessAddrLine2"
                   value="${param.businessAddrLine2}"
                   placeholder="상세 주소"
                   required>

            <label class="form-label" for="representativeContact">
                대표번호<span class="required">*</span>
            </label>

            <input type="tel"
                   id="representativeContact"
                   name="representativeContact"
                   value="${param.representativeContact}"
                   placeholder="예: 070-4290-8686"
                   required>

            <label class="form-label" for="customerServicePhone">
                판매자 전화번호<span class="required">*</span>
            </label>

            <input type="tel"
                   id="customerServicePhone"
                   name="customerServicePhone"
                   value="${param.customerServicePhone}"
                   placeholder="고객 문의용 전화번호"
                   required>
        </section>

        <label class="agreement">
            <input type="checkbox"
                   name="agreement"
                   value="true"
                   required>

            <span>
                입력한 판매자 정보가 상품 페이지에 공개되는 것에
                동의합니다.
            </span>
        </label>

        <button type="submit" class="submit-button">
            입점 신청하기
        </button>
    </form>

    <p class="login-guide">
        이미 입점 신청을 하셨나요?
        <a href="${pageContext.request.contextPath}/seller/sellerSignupStatus.htm">
            입점 신청 진행 과정 확인
        </a>
    </p>

</main>

<script>
$(function () {
    const contextPath = "${pageContext.request.contextPath}";

    const EMAIL_ID_PATTERN = /^(?!\.)(?!.*\.\.)(?:[A-Za-z0-9_-]+)(?:\.[A-Za-z0-9_-]+)*$/;
    const PASSWORD_PATTERN = /^(?=.*[A-Za-z])(?=.*[0-9])[\x21-\x7E]{8,20}$/;
    const PHONE_PATTERN = /^(?:0\d{1,2})-?\d{3,4}-?\d{4}$/;
    const MAIL_ORDER_PATTERN = /^\d{4}-[가-힣A-Za-z0-9]{4}-[가-힣A-Za-z0-9]{4}/;

    // 서버 중복검사를 통과한 '현재 값'을 저장한다. 값이 바뀌면 다시 검사해야 한다.
    const checkedValues = {
        email: null,
        brandName: null,
        businessNumber: null,
        mailOrderNumber: null
    };

    let pendingAjax = 0;

    function showMessage($target, message, success) {
        $target
            .removeClass("error-message success-message")
            .addClass(success ? "success-message" : "error-message")
            .text(message)
            .show();
    }

    function hideMessage(selector) {
        $(selector).hide().text("");
    }

    function getEmail() {
        return $.trim($("#emailId").val()) + "@" + $("#emailDomain").val();
    }

    function requestDuplicateCheck(options) {
        const value = options.value();
        const $message = $(options.messageSelector);

        checkedValues[options.stateKey] = null;
        if (!options.validate(value)) {
            showMessage($message, options.invalidMessage, false);
            return $.Deferred().reject().promise();
        }

        pendingAjax++;
        return $.ajax({
            url: contextPath + options.url,
            method: "POST",
            dataType: "json",
            data: { [options.parameter]: value }
        }).done(function (result) {
            // DAO 응답 형식: {"count": 0}. 문자열 숫자도 안전하게 처리한다.
            const available = Number(result.count) === 0 && !result.code;
            if (available) {
                checkedValues[options.stateKey] = value;
                showMessage($message, options.successMessage, true);
            } else {
                showMessage($message,
                    result.code === "SERVER_ERROR" ? "확인 중 서버 오류가 발생했습니다." : options.duplicateMessage,
                    false);
            }
        }).fail(function () {
            showMessage($message, "중복 확인 중 오류가 발생했습니다.", false);
        }).always(function () {
            pendingAjax--;
        });
    }

    // 이메일 중복 검사
    function checkEmail() {
        const emailId = $.trim($("#emailId").val());
        const emailDomain = $("#emailDomain").val();
        return requestDuplicateCheck({
            stateKey: "email",
            value: getEmail,
            validate: function () { return EMAIL_ID_PATTERN.test(emailId) && emailDomain !== ""; },
            url: "/emailcheck.ajax",
            parameter: "email",
            messageSelector: "#emailMessage",
            invalidMessage: "올바른 이메일을 입력해 주세요.",
            successMessage: "사용 가능한 이메일입니다.",
            duplicateMessage: "이미 가입된 이메일입니다."
        });
    }

    // 비밀번호는 서버 SellerSignupRequest와 같은 규칙으로 검사한다.
    function checkPassword() {
        const password = $("#password").val();
        const $message = $("#passwordMessage");
        const valid = PASSWORD_PATTERN.test(password);
        showMessage($message,
            valid ? "사용 가능한 비밀번호입니다." : "영문과 숫자를 포함한 8~20자의 비밀번호를 입력해 주세요.",
            valid);
        checkPasswordConfirm();
        return valid;
    }

    // 비밀번호 확인값 비교
    function checkPasswordConfirm() {
        const password = $("#password").val();
        const passwordConfirm = $("#passwordConfirm").val();
        const $message = $("#passwordConfirmMessage");

        if (passwordConfirm === "") {
            $message.hide();
            return false;
        }

        const matched = password === passwordConfirm;

        if (matched) {
            showMessage(
                $message,
                "비밀번호가 일치합니다.",
                true
            );
        } else {
            showMessage(
                $message,
                "비밀번호가 일치하지 않습니다.",
                false
            );
        }

        return matched;
    }

    $("#emailId, #emailDomain").on("input change", function () {
        checkedValues.email = null;
        hideMessage("#emailMessage");
    });

    // 이메일 입력 완료 시 AJAX 검사
    $("#emailId").on("blur", checkEmail);
    $("#emailDomain").on("change", checkEmail);

    $("#password").on("input", function () {
        hideMessage("#passwordMessage");
        checkPasswordConfirm();
    });

    // 비밀번호 입력 완료 시 AJAX 검사
    $("#password").on("blur", checkPassword);

    // 비밀번호 확인 실시간 검사
    $("#passwordConfirm").on(
        "input blur",
        checkPasswordConfirm
    );

    // 사업자번호에는 숫자만 입력
    $("#businessNumber").on("input", function () {
        const number = $(this)
            .val()
            .replace(/[^0-9]/g, "");

        $(this).val(number);
        checkedValues.businessNumber = null;
        hideMessage("#businessNumberMessage");
    });

    $("#brandName").on("input", function () {
        checkedValues.brandName = null;
        hideMessage("#brandNameMessage");
    }).on("blur", function () {
        requestDuplicateCheck({
            stateKey: "brandName", value: () => $.trim($(this).val()), validate: v => v.length >= 2,
            url: "/brandnamecheck.ajax", parameter: "brandName", messageSelector: "#brandNameMessage",
            invalidMessage: "상호를 2자 이상 입력해 주세요.", successMessage: "사용 가능한 상호입니다.",
            duplicateMessage: "이미 등록된 상호입니다."
        });
    });

    $("#mailOrderNumber").on("input", function () {
        checkedValues.mailOrderNumber = null;
        hideMessage("#mailOrderNumberMessage");
    }).on("blur", function () {
        requestDuplicateCheck({
            stateKey: "mailOrderNumber", value: () => $.trim($(this).val()), validate: v => MAIL_ORDER_PATTERN.test(v),
            url: "/mailordernumbercheck.ajax", parameter: "mailOrderNumber", messageSelector: "#mailOrderNumberMessage",
            invalidMessage: "예: 2026-서울강남-1234 형식으로 입력해 주세요.", successMessage: "사용 가능한 신고번호입니다.",
            duplicateMessage: "이미 등록된 통신판매업 신고번호입니다."
        });
    });

    // 사업자번호 확인 버튼
    $("#businessVerifyButton").on("click", function () {
        const businessNumber =
            $("#businessNumber").val();

        const valid = /^\d{10}$/.test(businessNumber);

        if (!valid) {
            showMessage(
                $("#businessNumberMessage"),
                "사업자 등록번호 10자리를 입력해 주세요.",
                false
            );

            $("#businessNumber").trigger("focus");
            return;
        }

        requestDuplicateCheck({
            stateKey: "businessNumber", value: () => businessNumber, validate: v => /^\d{10}$/.test(v),
            url: "/businessnumbercheck.ajax", parameter: "businessNumber", messageSelector: "#businessNumberMessage",
            invalidMessage: "사업자 등록번호 10자리를 입력해 주세요.", successMessage: "사용 가능한 사업자 등록번호입니다.",
            duplicateMessage: "이미 등록된 사업자 등록번호입니다."
        });
    });

    // 최종 폼 제출 검사
    $(".signup-form").on("submit", function (event) {
        const checks = [
            [pendingAjax === 0, "중복 확인이 끝날 때까지 잠시 기다려 주세요.", "#emailId"],
            [checkedValues.email === getEmail(), "이메일 중복 확인을 완료해 주세요.", "#emailId"],
            [checkPassword(), "비밀번호 형식을 확인해 주세요.", "#password"],
            [checkPasswordConfirm(), "비밀번호가 일치하지 않습니다.", "#passwordConfirm"],
            [checkedValues.brandName === $.trim($("#brandName").val()), "상호 중복 확인을 완료해 주세요.", "#brandName"],
            [checkedValues.businessNumber === $("#businessNumber").val(), "사업자 등록번호 확인을 완료해 주세요.", "#businessNumber"],
            [checkedValues.mailOrderNumber === $.trim($("#mailOrderNumber").val()), "통신판매업 신고번호 중복 확인을 완료해 주세요.", "#mailOrderNumber"],
            [PHONE_PATTERN.test($("#representativeContact").val()), "올바른 대표번호를 입력해 주세요.", "#representativeContact"],
            [PHONE_PATTERN.test($("#customerServicePhone").val()), "올바른 판매자 전화번호를 입력해 주세요.", "#customerServicePhone"]
        ];

        for (const [valid, message, selector] of checks) {
            if (!valid) {
                event.preventDefault();
                alert(message);
                $(selector).trigger("focus");
                return;
            }
        }
    });
});
</script>

</body>
</html>