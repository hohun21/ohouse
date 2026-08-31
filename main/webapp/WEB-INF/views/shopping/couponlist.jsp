<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>쿠폰</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #f7f7f7; font-family: Arial, sans-serif; color: #333; }
        .coupon-wrap { width: 900px; margin: 50px auto; }
        .title { font-size: 28px; font-weight: 700; margin-bottom: 30px; }
        .coupon-list { display: flex; flex-direction: column; gap: 15px; }
        .coupon { display: flex; align-items: center; background: #fff; border: 1px solid #ddd; border-radius: 10px; padding: 25px 30px; }
        .coupon-discount { width: 150px; font-size: 30px; font-weight: 700; color: #35c5f0; }
        .coupon-info { flex: 1; }
        .coupon-name { font-size: 18px; font-weight: 700; margin-bottom: 10px; }
        .coupon-condition { font-size: 14px; color: #777; margin-bottom: 7px; }
        .coupon-period { font-size: 13px; color: #999; }
        .coupon-status { width: 100px; text-align: center; font-size: 14px; font-weight: 600; }
        .available { color: #35c5f0; }
        .used { color: #999; }
        .empty { padding: 80px 0; text-align: center; background: #fff; border: 1px solid #ddd; border-radius: 10px; color: #999; }
    </style>
</head>
<body>

<div class="coupon-wrap">
    <div class="title">내 쿠폰</div>

    <div class="coupon-list">
        <c:choose>
            <c:when test="${empty clist}">
                <div class="empty">
                    보유한 쿠폰이 없습니다.
                </div>
            </c:when>

            <c:otherwise>
                <c:forEach var="coupon" items="${clist}">
                    <div class="coupon">
                        <div class="coupon-discount">
                            <c:choose>
                                <c:when test="${coupon.discount_type eq 'RATE'}">
                                    ${coupon.discount_value}%<br>
                                    <span style="font-size: 14px;">할인</span>
                                </c:when>
                                <c:otherwise>
                                    ${coupon.discount_value}원<br>
                                    <span style="font-size: 14px;">할인</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="coupon-info">
                            <div class="coupon-name">
                                ${coupon.coupon_name}
                            </div>

                            <div class="coupon-condition">
                                <c:if test="${coupon.min_order_price > 0}">
                                    ${coupon.min_order_price}원 이상 구매 시 사용 가능
                                </c:if>
                            </div>

                            <div class="coupon-period">
                                ${coupon.start_date} ~ ${coupon.end_date}
                            </div>
                        </div>

                        <div class="coupon-status">
                            <c:choose>
                                <c:when test="${coupon.status eq 'AVAILABLE'}">
                                    <span class="available">사용 가능</span>
                                </c:when>
                                <c:when test="${coupon.status eq 'USED'}">
                                    <span class="used">사용 완료</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="used">사용 불가</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>