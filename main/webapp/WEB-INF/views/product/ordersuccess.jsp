<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
<div class="success-container">
    <div class="success-icon">✓</div>

    <h1>결제가 완료되었습니다.</h1>

    <p>주문이 정상적으로 접수되었습니다.</p>
    <p>이용해 주셔서 감사합니다.</p>

    <div class="success-actions">
        <a href="${pageContext.request.contextPath}/main.htm" class="btn-home">
            홈으로 가기
        </a>
        <a href="${pageContext.request.contextPath}/order/orderlist.htm" class="btn-order">
            주문내역 확인
        </a>
    </div>
</div>
</main>

<style>
    .payment-success {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 500px;
        padding: 60px 20px;
    }

    .success-container {
        width: 100%;
        max-width: 500px;
        text-align: center;
        padding: 50px 30px;
        border: 1px solid #eee;
        border-radius: 12px;
    }

    .success-icon {
        width: 70px;
        height: 70px;
        margin: 0 auto 25px;
        border-radius: 50%;
        background: #35c5f0;
        color: white;
        font-size: 42px;
        line-height: 70px;
    }

    .success-container h1 {
        margin-bottom: 15px;
        font-size: 26px;
    }

    .success-container p {
        margin: 5px 0;
        color: #777;
    }

    .success-actions {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 35px;
    }

    .success-actions a {
        padding: 12px 24px;
        border-radius: 6px;
        text-decoration: none;
        font-size: 14px;
    }

    .btn-home {
        border: 1px solid #ddd;
        color: #555;
    }

    .btn-order {
        background: #35c5f0;
        color: white;
    }
</style>
<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>