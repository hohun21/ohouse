<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    /* 푸터 영역 스타일 */
    .footer-wrapper { background-color: #F7F9FA; padding: 40px 0; border-top: 1px solid #EAEDEF; }
    .footer-container { width: 1136px; margin: 0 auto; padding: 0 15px; display: grid; grid-template-columns: 280px 1fr 1fr; gap: 40px; }
    
    /* 좌측: 고객센터 박스 영역 */
    .footer-cs .cs-title { font-size: 18px; font-weight: 700; color: #2F3438; margin-bottom: 20px; display: block; text-decoration: none; }
    .cs-box { background: #fff; border: 1px solid #EAEDEF; border-radius: 8px; padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; cursor: pointer; }
    .cs-box-left { display: flex; flex-direction: column; gap: 4px; }
    .cs-box-title { font-size: 15px; font-weight: 700; color: #2F3438; }
    .cs-box-desc { font-size: 12px; color: #757575; line-height: 1.4; }
    .cs-box-arrow { color: #BDBDBD; font-weight: 700; }

    /* 중앙: 링크 메뉴 (2열) */
    .footer-links { display: flex; justify-content: space-between; padding-right: 40px; }
    .footer-links ul { list-style: none; padding: 0; margin: 0; display: flex; flex-direction: column; gap: 16px; }
    .footer-links li { font-size: 13px; color: #424242; cursor: pointer; }
    .footer-links li.bold { font-weight: 700; color: #2F3438; }
    .footer-links li:hover { text-decoration: underline; }

    /* 우측: 회사 정보 및 인증마크 */
    .footer-info { font-size: 12px; color: #757575; line-height: 1.6; }
    .info-text { margin-bottom: 15px; }
    
    /* 인증 마크 박스들 */
    .cert-marks { display: flex; gap: 10px; margin-bottom: 15px; }
    .cert-box { border: 1px solid #EAEDEF; background: #fff; padding: 8px; border-radius: 4px; display: flex; align-items: center; gap: 8px; font-size: 10px; color: #9E9E9E; }
    .cert-box img { height: 20px; }

    .disclaimer { font-size: 11px; color: #9E9E9E; line-height: 1.5; margin-bottom: 20px; }

    /* 하단 SNS 아이콘 */
    .footer-sns { display: flex; gap: 12px; margin-bottom: 20px; }
    .sns-icon { width: 32px; height: 32px; border-radius: 50%; background-color: #EAEDEF; display: flex; justify-content: center; align-items: center; color: #757575; font-size: 16px; cursor: pointer; }
    .sns-icon:hover { background-color: #DADCE0; }
    
    .copyright { font-size: 11px; color: #9E9E9E; }
</style>

<footer class="footer-wrapper">
    <div class="footer-container">
        
        <!-- 좌측: 고객센터 -->
        <div class="footer-cs">
            <a href="#" class="cs-title">고객센터 ></a>
            
            <div class="cs-box">
                <div class="cs-box-left">
                    <span class="cs-box-title">1:1 문의</span>
                    <span class="cs-box-desc">24시간 접수 · 평일 09:00-18:00 답변</span>
                </div>
                <span class="cs-box-arrow">></span>
            </div>
            
            <div class="cs-box">
                <div class="cs-box-left">
                    <span class="cs-box-title">채팅 상담</span>
                    <span class="cs-box-desc">평일 09:00-18:00</span>
                </div>
                <span class="cs-box-arrow">></span>
            </div>
            
            <div class="cs-box">
                <div class="cs-box-left">
                    <span class="cs-box-title">1670-0876</span>
                    <span class="cs-box-desc">평일 09:00-18:00 · 일요일 : 휴무<br>토·공휴일 : 원하는날도착 주문건 상담</span>
                </div>
                <span class="cs-box-arrow">></span>
            </div>
        </div>

        <!-- 중앙: 링크 메뉴 -->
        <div class="footer-links">
            <ul>
                <li>회사소개</li>
                <li>채용정보</li>
                <li>이용약관</li>
                <li class="bold">개인정보 처리방침</li>
                <li>공지사항</li>
                <li>권리보호센터</li>
            </ul>
            <ul>
                <li>입점신청</li>
                <li>제휴/광고 문의</li>
                <li>시공파트너 안내</li>
                <li class="bold">파트너 개인정보 처리방침</li>
                <li>상품광고 소개</li>
                <li>결제대행 위탁사</li>
            </ul>
        </div>

        <!-- 우측: 정보 및 인증 -->
        <div class="footer-info">
            <div class="info-text">
                (주)버킷플레이스 | 대표이사 이승재 | 서울 서초구 서초대로74길 4 삼성생명서초타워 25층, 27층<br>
                contact@bucketplace.net | 사업자등록번호 119-86-91245 <a href="#" style="text-decoration:underline; font-weight:700;">사업자정보확인</a><br>
                통신판매업신고번호 제2018-서울서초-0580호
            </div>
            
            <div class="info-text" style="color:#2F3438;">
                고객님이 현금결제한 금액에 대해 우리은행과 채무지급보증 계약을 체결하여 안전거래를 보장하고 있습니다. <a href="#" style="text-decoration:underline; font-weight:700;">서비스가입사실확인</a>
            </div>

            <!-- 3개 인증마크 레이아웃 -->
            <div class="cert-marks">
                <div class="cert-box">
                    <span style="font-size:16px; font-weight:900; color:#2F3438;">ISMS</span>
                    <span>오늘의집 서비스 운영<br>2024. 09. 08 ~ 2027. 09. 07</span>
                </div>
                <div class="cert-box">
                    <span style="font-size:16px; font-weight:900; color:#00A6EA;">DNV</span>
                </div>
                <div class="cert-box">
                    <span style="font-size:16px; font-weight:900; color:#1877F2;">PCR</span>
                </div>
            </div>

            <div class="disclaimer">
                (주)버킷플레이스는 통신판매중개자로 거래 당사자가 아니므로, 판매자가 등록한 상품정보 및 거래 등에 대해 책임을 지지 않습니다. 단, (주)버킷플레이스가 판매자로 등록 판매한 상품은 판매자로서 책임을 부담합니다.
            </div>

            <div class="footer-sns">
                <div class="sns-icon">Y</div>
                <div class="sns-icon">I</div>
                <div class="sns-icon">F</div>
                <div class="sns-icon">K</div>
            </div>

            <div class="copyright">
                Copyright 2014. bucketplace, Co., Ltd. All rights reserved.
            </div>
        </div>

    </div>
</footer>
</body>
</html>