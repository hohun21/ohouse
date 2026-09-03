<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<title>오늘의집 - 회원탈퇴</title>

<link rel="stylesheet" as="style" crossorigin
    href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />

<style>

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', 'Pretendard', sans-serif;
        background-color: #fff;
        color: #292929;
    }

    a {
        text-decoration: none;
        color: inherit;
    }

    .container {
        max-width: 1136px;
        margin: 0 auto;
        padding: 0 20px;
        box-sizing: border-box;
    }

    /* 상단 네비게이션 탭 */

    .top-nav {
        display: flex;
        justify-content: center;
        border-bottom: 1px solid #ededed;
        padding: 15px 0;
    }

    .top-nav a {
        margin: 0 15px;
        font-size: 16px;
        font-weight: bold;
        color: #424242;
        transition: color 0.2s ease;
    }

    .top-nav a:hover {
        color: #35c5f0;
    }

    .top-nav a.active {
        color: #35c5f0;
    }

    /* 서브 하위 탭 */

    .sub-nav {
        display: flex;
        justify-content: center;
        border-bottom: 1px solid #ededed;
        padding: 15px 0;
        margin-bottom: 50px;
    }

    .sub-nav a {
        margin: 0 15px;
        font-size: 15px;
        font-weight: bold;
        color: #757575;
        position: relative;
        padding-bottom: 15px;
        transition: color 0.2s ease;
    }

    .sub-nav a:hover {
        color: #35c5f0;
    }

    .sub-nav a.active {
        color: #35c5f0;
    }

    .sub-nav a.active::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 3px;
        background-color: #35c5f0;
    }

    /* 회원탈퇴 영역 */

    .withdraw-wrapper {
        max-width: 700px;
        margin: 0 auto 100px;
    }
    
    /* 탈퇴 사유 영역 */
.withdraw-reason-area {
    margin-top: 70px;
}

.withdraw-reason-area h2,
.withdraw-feedback-area h2 {
    font-size: 18px;
    font-weight: bold;
    color: #292929;
    margin-bottom: 20px;
}

.withdraw-reason-area h2 span,
.withdraw-feedback-area h2 span {
    color: #999;
    font-weight: normal;
}

.withdraw-reason-area h2 strong {
    color: #f06060;
    font-size: 14px;
    margin-left: 4px;
}

/* 탈퇴 사유 박스 */
.reason-list {
    border: 1px solid #dbdbdb;
    border-radius: 4px;
    padding: 28px 30px;
}

.reason-item {
    display: flex;
    align-items: center;
    margin-bottom: 18px;
    cursor: pointer;
    font-size: 14px;
    color: #424242;
}

.reason-item:last-child {
    margin-bottom: 0;
}

.reason-item input {
    width: 22px;
    height: 22px;
    margin-right: 10px;
    cursor: pointer;
    accent-color: #35c5f0;
}

/* 불편사항 */
.withdraw-feedback-area {
    margin-top: 42px;
}

.withdraw-feedback-area p {
    font-size: 14px;
    color: #424242;
    margin-bottom: 20px;
}

/* textarea */
.textarea-wrapper {
    position: relative;
    width: 100%;
}

.textarea-wrapper textarea {
    width: 100%;
    height: 200px;
    padding: 16px;
    border: 1px solid #dbdbdb;
    border-radius: 4px;
    resize: none;
    outline: none;
    font-family: inherit;
    font-size: 14px;
    line-height: 1.5;
    color: #424242;
}

.textarea-wrapper textarea:focus {
    border-color: #35c5f0;
}

.textarea-wrapper textarea::placeholder {
    color: #bdbdbd;
}

.text-count {
    position: absolute;
    right: 12px;
    bottom: 10px;
    font-size: 12px;
    color: #999;
}

/* 하단 버튼 */
.withdraw-buttons {
    display: flex;
    justify-content: center;
    gap: 10px;
    margin-top: 42px;
    margin-bottom: 80px;
}

.cancel-withdraw-btn,
.withdraw-submit-btn {
    width: 160px;
    height: 46px;
    border-radius: 4px;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
}

.cancel-withdraw-btn {
    background-color: #fff;
    border: 1px solid #dbdbdb;
    color: #424242;
}

.withdraw-submit-btn {
    background-color: #35c5f0;
    border: 1px solid #35c5f0;
    color: #fff;
}

.withdraw-submit-btn:disabled {
    background-color: #ededed;
    border-color: #ededed;
    color: #bdbdbd;
    cursor: default;
}
    
    /* 회원탈퇴 제목 */

.withdraw-container h1 {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 34px;
}

.withdraw-description {
    font-size: 14px;
    font-weight: bold;
    color: #292929;
    margin-bottom: 18px;
}

.withdraw-description.error {
    color: #ff5a5f;
}

/* 회원탈퇴 안내 박스 */

.withdraw-notice {
    border: 1px solid #dbdbdb;
    border-radius: 4px;
    padding: 16px 20px 18px;
    margin-bottom: 18px;
}

.withdraw-notice h2 {
    font-size: 15px;
    font-weight: 700;
    margin-bottom: 12px;
}

.withdraw-notice ul {
    padding-left: 20px;
    margin-bottom: 12px;
}

.withdraw-notice li {
    font-size: 13px;
    line-height: 1.6;
    margin-bottom: 3px;
}

.withdraw-notice p {
    font-size: 13px;
    line-height: 1.7;
    margin: 0 0 14px;
    padding-left: 20px;
}

.withdraw-notice p:last-child {
    margin-bottom: 0;
}


/* 안내 확인 체크 */

.withdraw-check-area {
    margin-bottom: 48px;
}

.check-item {
    display: flex;
    align-items: center;
    gap: 9px;
    cursor: pointer;
    font-size: 13px;
}

.check-item input[type="checkbox"] {
    width: 22px;
    height: 22px;
    cursor: pointer;
}

.check-item strong {
    color: #f06060;
    font-weight: 600;
}


/* 고객센터 */

.withdraw-customer {
	position : absolute;
	right : 0;
	top : 2px;
    font-size: 13px;
    color: #757575;
}

.withdraw-customer strong {
    color: #424242;
}

.withdraw-error {
    display: none;
    margin-top: 8px;
    font-size: 12px;
    color: #f06060;
}

.withdraw-error.show {
    display: block;
}

/* 필수 체크 영역 */
.withdraw-confirm-area {
	position : relative;
    margin-top: 18px;
    margin-bottom: 40px;
}

.check-item {
    display: flex;
    align-items: center;
    cursor: pointer;
    font-size: 14px;
    color: #424242;
}

.check-item input {
    appearance: none;
    width: 20px;
    height: 20px;
    border: 1px solid #dbdbdb;
    border-radius: 4px;
    margin-right: 10px;
    background-color: #fff;
    cursor: pointer;
    position: relative;
}

.check-item input:checked {
    background-color: #35c5f0;
    border-color: #35c5f0;
}

.check-item input:checked::after {
    content: "✓";
    position: absolute;
    color: #fff;
    font-size: 14px;
    font-weight: bold;
    left: 3px;
    top: 0px;
}

.check-item strong {
    color: #ff5a5f;
}


/* 탈퇴 사유 */
.reason-section {
    margin-bottom: 40px;
}

.reason-section h2 {
    font-size: 17px;
    color: #292929;
    margin-bottom: 18px;
}

.reason-section h2 span {
    font-weight: normal;
    color: #757575;
}

.reason-section h2 strong {
    color: #ff5a5f;
    font-size: 14px;
}


/* 탈퇴 사유 박스 */
.reason-box {
    border: 1px solid #dbdbdb;
    border-radius: 4px;
    padding: 24px 30px;
}

.reason-item {
    display: flex;
    align-items: center;
    margin-bottom: 18px;
    font-size: 14px;
    color: #424242;
    cursor: pointer;
}

.reason-item:last-child {
    margin-bottom: 0;
}

.reason-item input {
    appearance: none;
    width: 21px;
    height: 21px;
    border: 1px solid #dbdbdb;
    border-radius: 4px;
    margin-right: 10px;
    background-color: #fff;
    cursor: pointer;
    position: relative;
}

.reason-item input:checked {
    background-color: #35c5f0;
    border-color: #35c5f0;
}

.reason-item input:checked::after {
    content: "✓";
    position: absolute;
    color: #fff;
    font-size: 14px;
    font-weight: bold;
    left: 3px;
    top: 0px;
}


/* 에러 상태 */
.withdraw-error {
    display: none;
    margin-top: 10px;
    color: #ff5a5f;
    font-size: 12px;
}

.withdraw-error.show {
    display: block;
}


/* 체크박스 에러 상태 */
.withdraw-confirm-area.error .check-item input {
    border-color: #ff5a5f;
}

.reason-section.error .reason-item input {
    border-color: #ff5a5f;
}

.reason-section.error .reason-box {
    border-color: #dbdbdb;
}


/* 에러 상태에서 필수 글씨 */
.withdraw-confirm-area.error .check-item strong {
    color: #ff5a5f;
}

.reason-section.error h2 {
    color: #ff5a5f;
}

.reason-section.error h2 span {
    color: #757575;
}

.reason-section.error h2 strong {
    color: #ff5a5f;
}

/* 탈퇴 확인 모달 */
.withdraw-modal {
    display: none;
    position: fixed;
    z-index: 9999;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.35);

    align-items: center;
    justify-content: center;
}

.withdraw-modal-content {
    position: relative;
    width: 270px;
    background-color: #fff;
    border-radius: 6px;
    padding: 24px 12px 12px;
    text-align: center;
}

.withdraw-modal-content h2 {
    font-size: 15px;
    font-weight: bold;
    margin-bottom: 12px;
}

.withdraw-modal-content p {
    font-size: 12px;
    line-height: 1.6;
    color: #424242;
    margin: 0;
}

.withdraw-modal-content .modal-warning {
    margin-top: 2px;
}

.modal-close {
    position: absolute;
    top: 10px;
    right: 12px;
    border: none;
    background: none;
    font-size: 22px;
    color: #292929;
    cursor: pointer;
}

.modal-buttons {
    display: flex;
    gap: 6px;
    margin-top: 18px;
}

.modal-buttons > button,
.modal-buttons > form {
    flex: 1;
    width: 0;
}

.modal-buttons form {
    margin: 0;
}

.modal-buttons button {
    width: 100%;
    height: 34px;
    border-radius: 5px;
    font-size: 12px;
    cursor: pointer;
}

.cancel-btn {
    background-color: #fff;
    border: 1px solid #dbdbdb;
    color: #424242;
}

.confirm-withdraw-btn {
    background-color: #35c5f0;
    border: 1px solid #35c5f0;
    color: #fff;
    font-weight: bold;
}

</style>

</head>

<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp">
        <jsp:param name="showSubHeaderAtTop" value="false"/>
    </jsp:include>


    <div class="top-nav">

        <a href="${pageContext.request.contextPath}/member/myPage.htm">
            프로필
        </a>

        <a href="${pageContext.request.contextPath}/member/myShopping.htm">
            나의 쇼핑
        </a>

        <a href="#">
            나의 리뷰
        </a>

        <a href="${pageContext.request.contextPath}/changePwd.htm"
           class="active">
            설정
        </a>

    </div>


    <div class="sub-nav">

        <a href="#">
            회원정보수정
        </a>

        <a href="#">
            알림 설정
        </a>

        <a href="#">
            사용자 숨기기 설정
        </a>

        <a href="${pageContext.request.contextPath}/addressList.htm">
            배송지 설정
        </a>

        <a href="${pageContext.request.contextPath}/changePwd.htm">
            비밀번호 변경
        </a>

        <a href="#">
            추천코드
        </a>

        <a href="${pageContext.request.contextPath}/member/withdraw.htm"
           class="active">
            회원 탈퇴
        </a>

    </div>


    <div class="container">

        <div class="withdraw-wrapper">

            <!-- 회원탈퇴 본문 -->

            <div class="withdraw-page">

                <div class="withdraw-container">

                    <h1>회원탈퇴 신청</h1>

                    <p class="withdraw-description">
                        회원 탈퇴 신청에 앞서 아래 내용을 반드시 확인해주세요.
                    </p>

                    <div class="withdraw-notice">

                        <h2>회원탈퇴 시 처리내용</h2>

                        <ul>
                            <li>오늘의집 포인트·쿠폰은 소멸되며 환불되지 않습니다.</li>
                            <li>오늘의집 구매 정보가 삭제됩니다.</li>
                            <li>소비자보호에 관한 법률 제6조에 의거,계약 또는 청약철회 등에 관한 기록은 5년, 대금결제 및 재화등의 공급에 관한 기록은 5년, 소비자의 불만 또는 분쟁처리에 관한 기록은 3년 동안 보관됩니다. 동 개인정보는 법률에 의한 보유 목적 외에 다른 목적으로는 이용되지 않습니다.</li>
                        </ul>

                        <h2>회원탈퇴 시 게시물 관리</h2>
                        <p>회원탈퇴 후 오늘의집 서비스에 입력한 게시물 및 댓글은 삭제되지 않으며, 회원정보 삭제로 인해 작성자 본인을 확인할 수 없으므로 게시물 편집 및 삭제 처리가 원천적으로 불가능 합니다. 게시물 삭제를 원하시는 경우에는 먼저 해당 게시물을 삭제 하신 후, 탈퇴를 신청하시기 바랍니다.</p>
                        <h2>회원탈퇴 후 재가입 규정</h2>
                        <p>탈퇴 회원이 재가입하더라도 기존의 오늘의집 포인트는 이미 소멸되었기 때문에 양도되지 않습니다.</p>
                    </div>
                    
                   <!-- 안내사항 확인 -->
<div class="withdraw-confirm-area">

    <label class="check-item">
        <input type="checkbox"
               id="noticeCheck"
               class="withdraw-check">

        <span>
            위 내용을 모두 확인하였습니다. <strong>(필수)</strong>
        </span>
    </label>
    
       <div class="withdraw-customer">
        고객센터 <strong>1670-0876</strong>
   		 </div>

    <p id="noticeError" class="withdraw-error">
        필수 동의 항목입니다.
    </p>

</div>


<!-- 탈퇴 사유 -->
<div class="reason-section">

    <h2>
        오늘의집 회원에서 탈퇴하려는 이유가 무엇인가요?
        <span>(복수선택 가능)</span>
        <strong>필수</strong>
    </h2>

    <div class="reason-box">

        <label class="reason-item">
            <input type="checkbox"
                   name="withdrawReason"
                   value="이용빈도 낮음">
            <span>이용빈도 낮음</span>
        </label>

        <label class="reason-item">
            <input type="checkbox"
                   name="withdrawReason"
                   value="재가입">
            <span>재가입</span>
        </label>

        <label class="reason-item">
            <input type="checkbox"
                   name="withdrawReason"
                   value="콘텐츠/제품정보/상품 부족">
            <span>콘텐츠/제품정보/상품 부족</span>
        </label>

        <label class="reason-item">
            <input type="checkbox"
                   name="withdrawReason"
                   value="개인정보보호">
            <span>개인정보보호</span>
        </label>

        <label class="reason-item">
            <input type="checkbox"
                   name="withdrawReason"
                   value="회원특혜/쇼핑혜택 부족">
            <span>회원특혜/쇼핑혜택 부족</span>
        </label>

        <label class="reason-item">
            <input type="checkbox"
                   name="withdrawReason"
                   value="기타">
            <span>기타</span>
        </label>

    </div>

    <p id="reasonError" class="withdraw-error">
        필수 입력 항목입니다.
    </p>

</div>
</div>

<!-- 서비스 이용 불편사항 -->
<div class="withdraw-feedback-area">

    <h2>
        오늘의집 서비스 이용 중 어떤 부분이 불편하셨나요?
        <span>선택</span>
    </h2>

    <p>
        오늘의집에 떠나는 이유를 자세히 알려주시겠어요?
        여러분의 소중한 의견을 반영해 더 좋은 서비스로 꼭 찾아뵙겠습니다.
    </p>

    <div class="textarea-wrapper">

        <textarea
            id="withdrawFeedback"
            name="withdrawFeedback"
            maxlength="2000"
            placeholder="선택하신 항목에 대한 자세한 이유를 남겨주시면 서비스 개선에 큰 도움이 됩니다."></textarea>

        <span class="text-count">
            <span id="textCount">0</span> / 2000
        </span>

    </div>

</div>

<!-- 버튼 -->
<div class="withdraw-buttons">

    <button type="button"
            class="cancel-withdraw-btn"
            onclick="history.back();">
        취소하기
    </button>

    <button type="button"
            id="withdrawBtn"
            class="withdraw-submit-btn">
        탈퇴신청
    </button>

</div>

                </div>

            </div>

        </div>

    </div>


<!-- 탈퇴 확인 모달 -->
<div id="withdrawModal" class="withdraw-modal">

    <div class="withdraw-modal-content">

        <button type="button"
                id="closeWithdraw"
                class="modal-close">
            ×
        </button>

        <h2>회원 탈퇴</h2>

        <p>
            포인트·쿠폰이 모두 소멸되며 복구할 수 없어요.
        </p>

        <p class="modal-warning">
            정말 탈퇴하시겠어요?
        </p>

 <div class="modal-buttons">

    <button type="button"
            id="cancelWithdraw"
            class="cancel-btn">
        취소
    </button>

    <form method="post"
          action="${pageContext.request.contextPath}/member/withdrawPro.htm">

        <button type="submit"
                class="confirm-withdraw-btn">
            탈퇴하기
        </button>

    </form>

</div>

    </div>

</div>


    <script>

$(function() {

    const $noticeDescription = $(".withdraw-description");
    const $noticeArea = $(".withdraw-confirm-area");
    const $noticeCheck = $("#noticeCheck");
    const $noticeError = $("#noticeError");

    const $reasonSection = $(".reason-section");
    const $reasonChecks = $("input[name='withdrawReason']");
    const $reasonError = $("#reasonError");

    const $withdrawBtn = $("#withdrawBtn");
    const $withdrawModal = $("#withdrawModal");


    // 안내사항 체크
    $noticeCheck.on("change", function() {

        if ($(this).is(":checked")) {

            $noticeDescription.removeClass("error");
            $noticeArea.removeClass("error");
            $noticeError.removeClass("show");

        }

    });


    // 탈퇴 사유 체크
    $reasonChecks.on("change", function() {

        if ($reasonChecks.filter(":checked").length > 0) {

            $reasonSection.removeClass("error");
            $reasonError.removeClass("show");

        }

    });


    // 탈퇴신청
    $withdrawBtn.on("click", function() {

        const noticeChecked = $noticeCheck.is(":checked");

        const reasonChecked =
            $reasonChecks.filter(":checked").length > 0;

        let hasError = false;


        // 안내사항 미확인
        if (!noticeChecked) {

            $noticeDescription.addClass("error");
            $noticeArea.addClass("error");
            $noticeError.addClass("show");

            hasError = true;
        }


        // 탈퇴 사유 미선택
        if (!reasonChecked) {

            $reasonSection.addClass("error");
            $reasonError.addClass("show");

            hasError = true;
        }


        // 하나라도 조건을 만족하지 못하면 모달 X
        if (hasError) {

            const $firstError =
                $(".withdraw-error.show").first();

            $("html, body").animate({
                scrollTop: $firstError.offset().top - 120
            }, 300);

            return;
        }


        // 필수 조건 모두 만족
        $withdrawModal.css("display", "flex");

    });


    // 모달 취소
    $("#cancelWithdraw").on("click", function() {
        $withdrawModal.hide();
    });


    // 모달 X
    $("#closeWithdraw").on("click", function() {
        $withdrawModal.hide();
    });


    // 모달 바깥 클릭
    $withdrawModal.on("click", function(e) {

        if (e.target === this) {
            $withdrawModal.hide();
        }

    });

});

</script>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>

</body>

</html>