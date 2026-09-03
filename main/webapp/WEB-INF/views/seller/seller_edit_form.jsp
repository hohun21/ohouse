<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 상품 수정</title>
<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    body {
        font-family: 'Malgun Gothic', sans-serif;
        background-color: #f7f9fa;
        color: #333;
        display: flex;
        height: 100vh;
        overflow: hidden;
    }

    /* 좌측 사이드바 영역 (다른 페이지와 완벽 통일) */
    .sidebar {
        width: 240px;
        background-color: #2b333b;
        color: white;
        display: flex;
        flex-direction: column;
        flex-shrink: 0;
    }
    .sidebar-brand {
        padding: 20px;
        font-size: 18px;
        font-weight: bold;
        background-color: #1e242b;
        text-align: center;
    }
    .sidebar-menu {
        list-style: none;
        padding: 20px 0;
    }
    .sidebar-menu li a {
        display: block;
        padding: 12px 20px;
        color: #b0c4de;
        text-decoration: none;
        font-size: 14px;
        transition: 0.2s;
    }
    .sidebar-menu li a:hover, .sidebar-menu li a.active {
        background-color: #35c5f0;
        color: white;
    }

    /* 우측 메인 콘텐츠 영역 */
    .main-content {
        flex: 1;
        display: flex;
        flex-direction: column;
        overflow-y: auto;
    }
    .top-header {
        height: 60px;
        background-color: white;
        border-bottom: 1px solid #e1e4e6;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        flex-shrink: 0;
    }
    .top-header .welcome-text {
        font-size: 15px;
        font-weight: bold;
    }

    /* 수정 폼 컨테이너 바디 */
    .content-body {
        padding: 30px;
    }

    .form-container {
        max-width: 800px;
        background-color: white;
        padding: 30px;
        margin: 0 auto;
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        border: 1px solid #e1e4e6;
    }

    /* 타이틀 영역 정렬 */
    .form-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        border-bottom: 2px solid #f0f0f0;
        padding-bottom: 15px;
    }

    .form-container h2 {
        margin: 0;
        color: #333;
        font-size: 20px;
    }

    /* 목록으로 돌아가기 버튼 스타일 */
    .btn-dashboard {
        background-color: #f0f2f5;
        color: #555;
        border: 1px solid #d1d5db;
        padding: 8px 14px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: bold;
        text-decoration: none;
        transition: 0.2s;
    }

    .btn-dashboard:hover {
        background-color: #e4e7eb;
        color: #111;
    }

    .form-group {
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eee;
    }

    .form-group:last-child {
        border-bottom: none;
    }

    .form-group label {
        display: block;
        font-weight: bold;
        margin-bottom: 8px;
        color: #555;
        font-size: 14px;
    }

    .form-group input[type="text"], .form-group input[type="number"],
    .form-group select, .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
        font-size: 14px;
    }

    .submit-btn {
        width: 100%;
        padding: 15px;
        background-color: #35c5f0;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        transition: 0.3s;
        margin-top: 10px;
    }

    .submit-btn:hover {
        background-color: #009fce;
    }

    .option-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 10px;
    }

    .btn-small {
        background-color: #f0f0f0;
        border: 1px solid #ddd;
        padding: 6px 12px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 12px;
        font-weight: bold;
    }

    .btn-small:hover {
        background-color: #e0e0e0;
    }

    .btn-generate {
        background-color: #ffaa00;
        color: white;
        border: none;
        padding: 12px;
        border-radius: 4px;
        width: 100%;
        cursor: pointer;
        font-weight: bold;
        margin-top: 10px;
    }

    .btn-generate:hover {
        background-color: #e69900;
    }

    .option-item {
        display: flex;
        gap: 10px;
        margin-bottom: 10px;
        align-items: center;
        background: #fafafa;
        padding: 10px;
        border: 1px dashed #ccc;
        border-radius: 4px;
    }

    .option-item input {
        flex: 1;
        margin: 0;
    }

    .remove-btn {
        background-color: #ff4d4f;
        color: white;
        border: none;
        padding: 10px 15px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
    }

    .sku-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }

    .sku-table th, .sku-table td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }

    .sku-table th {
        background-color: #f5f5f5;
        font-size: 13px;
    }

    .sku-table td input {
        width: 90%;
        padding: 8px;
        text-align: center;
    }
</style>
</head>
<body>

    <!-- 좌측 사이드바 -->
    <div class="sidebar">
        <div class="sidebar-brand">🏠 O-House Seller</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/seller/dashboard.htm">📊 대시보드 홈</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/addForm.htm">➕ 상품 등록</a></li>
            <!-- 수정 페이지는 보통 상품 목록에서 진입하므로 목록 관리에 active 지정 -->
            <li><a href="${pageContext.request.contextPath}/seller/productList.htm" class="active">📦 상품 목록 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/orderList.htm">🚚 주문 및 배송 관리</a></li>
            <li><a href="${pageContext.request.contextPath}/seller/settlementList.htm">💰 정산 관리</a></li>
            <li><a href="#">⭐ 리뷰 관리</a></li>
        </ul>
    </div>

    <!-- 우측 메인 영역 -->
    <div class="main-content">
        <!-- 상단 헤더 -->
        <div class="top-header">
            <span class="welcome-text">👋 환영합니다, <strong style="color: #35c5f0;">${sessionScope.sellerAuth.brandName}</strong> 파트너님!</span>
            <a href="${pageContext.request.contextPath}/member/myPage.htm" style="font-size: 13px; color: #666; text-decoration: none;">마이페이지로 가기</a>
        </div>

        <!-- 본문 폼 영역 -->
        <div class="content-body">
            <div class="form-container">
                <!-- 타이틀과 목록 가기 버튼 헤더 -->
                <div class="form-header">
                    <h2>✏️ 상품 정보 수정</h2>
                    <a href="${pageContext.request.contextPath}/seller/productList.htm" class="btn-dashboard">📦 상품 목록으로</a>
                </div>

                <form action="/seller/editPro.htm" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="productId" value="${product.productId}">

                    <!-- 카테고리 선택 -->
                    <div class="form-group">
                        <label for="categoryId">카테고리</label> 
                        <select id="categoryId" name="categoryId" required>
                            <option value="">카테고리를 선택하세요</option>
                            <c:forEach var="cat" items="${categoryList}">
                                <option value="${cat.category_id}"
                                    ${cat.category_id == product.categoryId ? 'selected' : ''}>
                                    ${cat.category_name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- 브랜드명 입력 -->
                    <div class="form-group">
                        <label for="brandName">브랜드명</label> 
                        <input type="text" id="brandName" name="brandName" value="${product.brandName}" required>
                    </div>

                    <!-- 상품명 -->
                    <div class="form-group">
                        <label>상품명</label> 
                        <input type="text" name="productName" value="${product.productName}" required>
                    </div>

                    <!-- 상품 상세 설명 -->
                    <div class="form-group">
                        <label>상품 상세 설명</label> 
                        <textarea name="description" rows="5" placeholder="상품에 대한 상세한 설명을 입력하세요" required>${product.description}</textarea>
                    </div>

                    <!-- 원가 -->
                    <div class="form-group">
                        <label>원가 (정가 - 원)</label> 
                        <input type="number" id="originalPrice" name="originalPrice" value="${product.originalPrice}" placeholder="할인 전 원래 가격을 입력하세요" required>
                    </div>
                    
                    <!-- 할인율 -->
                    <div class="form-group">
                        <label>할인율 (%)</label> 
                        <input type="number" id="discountRate" name="discountRate" value="${product.discountRate}" placeholder="예: 25 (숫자만 입력, 할인 없으면 0 입력)" required>
                    </div>

                    <!-- 기본 판매 가격 -->
                    <div class="form-group">
                        <label id="basePriceLabel">기본 판매 가격 (실제 판매가 - 원)</label> 
                        <input type="number" id="basePrice" name="price" value="${product.price}" placeholder="원가와 할인율을 입력하면 자동으로 계산됩니다" required>
                    </div>

                    <!-- 상품 이미지 변경 영역 -->
                    <div class="form-group">
                        <label style="color: #333;">상품 이미지 변경 (다중 선택)</label>
                        <input type="file" name="productImages" accept="image/*" multiple 
                            style="width: 100%; padding: 15px; border: 2px dashed #ddd; border-radius: 5px; background-color: #fafafa; cursor: pointer; box-sizing: border-box;">
                        <p style="margin-top: 8px; font-size: 13px; color: #888; margin-bottom: 0;">
                            💡 새로운 사진을 선택하면 기존 등록된 사진들은 모두 새로 업로드한 사진으로 교체됩니다. (첫 번째 사진이 대표 썸네일이 됩니다)
                        </p>
                    </div>

                    <!-- 필수 옵션 설정 -->
                    <div class="form-group">
                        <div class="option-header">
                            <label>필수 옵션 설정 (쉼표로 구분)</label>
                            <button type="button" class="btn-small" id="addOptionBtn">➕ 옵션 추가</button>
                        </div>

                        <div id="optionContainer">
                            <c:choose>
                                <c:when test="${not empty optionItems}">
                                    <c:forEach var="item" items="${optionItems}">
                                        <div class="option-item">
                                            <input type="text" name="optionNames" class="opt-name"
                                                value="${item.groupName}" placeholder="옵션명 (예: 색상)"> 
                                            <input type="text" name="optionValues" class="opt-val"
                                                value="${item.valuesStr}" placeholder="옵션값 (예: 화이트,블랙)">
                                            <button type="button" class="remove-btn" onclick="this.parentElement.remove()">X</button>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="option-item">
                                        <input type="text" name="optionNames" class="opt-name" placeholder="옵션명 (예: 색상)"> 
                                        <input type="text" name="optionValues" class="opt-val" placeholder="옵션값 (예: 화이트,블랙)">
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <button type="button" class="btn-generate" id="generateTableBtn">옵션 목록 다시 만들기</button>

                        <!-- 기존 SKU 조합 테이블 -->
                        <table class="sku-table" id="skuTable"
                            style="${not empty skuList ? 'display: table;' : 'display: none;'}">
                            <thead>
                                <tr>
                                    <th>옵션 조합명</th>
                                    <th>판매가 (원)</th>
                                    <th>재고 (개)</th>
                                    <th>삭제</th>
                                </tr>
                            </thead>
                            <tbody id="skuTbody">
                                <c:forEach var="sku" items="${skuList}">
                                    <tr>
                                        <td>${sku.sku} 
                                            <input type="hidden" name="skuNames" value="${sku.sku}">
                                        </td>
                                        <td><input type="number" name="skuPrices" value="${sku.price}" required></td>
                                        <td><input type="number" name="skuStocks" value="${sku.stock}" required></td>
                                        <td><button type="button" class="remove-btn" onclick="removeSkuRow(this)">X</button></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- 추가 상품 설정 -->
                    <div class="form-group">
                        <div class="option-header">
                            <label>추가 상품 설정 (선택)</label>
                            <button type="button" class="btn-small" id="addExtraBtn"
                                style="background-color: #35c5f0; color: white; border: none;">➕ 추가상품 추가</button>
                        </div>

                        <!-- 기존 추가 상품 테이블 -->
                        <table class="sku-table" id="extraTable"
                            style="${not empty extraList ? 'display: table;' : 'display: none;'}">
                            <thead>
                                <tr>
                                    <th>추가 상품명</th>
                                    <th>추가 가격 (원)</th>
                                    <th>재고 (개)</th>
                                    <th>삭제</th>
                                </tr>
                            </thead>
                            <tbody id="extraTbody">
                                <c:forEach var="extra" items="${extraList}">
                                    <tr>
                                        <td><input type="text" name="extraNames" value="${fn:replace(extra.sku, '[추가상품] ', '')}" required></td>
                                        <td><input type="number" name="extraPrices" value="${extra.price}" required></td>
                                        <td><input type="number" name="extraStocks" value="${extra.stock}" required></td>
                                        <td><button type="button" class="remove-btn" onclick="removeExtraRow(this)">X</button></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <button type="submit" class="submit-btn">상품 수정하기</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // ==========================================
            // 0. 원가 및 할인율에 따른 판매가 자동 계산 로직
            // ==========================================
            const originalPriceInput = document.getElementById('originalPrice');
            const discountRateInput = document.getElementById('discountRate');
            const basePriceInput = document.getElementById('basePrice');

            function calculatePrice() {
                const orgPrice = parseFloat(originalPriceInput.value) || 0;
                const discount = parseFloat(discountRateInput.value) || 0;

                if (orgPrice > 0) {
                    const finalPrice = orgPrice - (orgPrice * (discount / 100));
                    basePriceInput.value = Math.round(finalPrice);
                } else {
                    basePriceInput.value = '';
                }
            }

            originalPriceInput.addEventListener('input', calculatePrice);
            discountRateInput.addEventListener('input', calculatePrice);

            // ==========================================
            // 1. 필수 옵션 조합형 테이블 생성 로직
            // ==========================================
            const addOptionBtn = document.getElementById('addOptionBtn');
            const optionContainer = document.getElementById('optionContainer');
            const generateTableBtn = document.getElementById('generateTableBtn');
            const skuTable = document.getElementById('skuTable');
            const skuTbody = document.getElementById('skuTbody');

            addOptionBtn.addEventListener('click', function() {
                const newOptionDiv = document.createElement('div');
                newOptionDiv.className = 'option-item';
                newOptionDiv.innerHTML = `
                    <input type="text" name="optionNames" class="opt-name" placeholder="옵션명 (예: 사이즈)">
                    <input type="text" name="optionValues" class="opt-val" placeholder="옵션값 (예: S,M)">
                    <button type="button" class="remove-btn" onclick="this.parentElement.remove()">X</button>
                `;
                optionContainer.appendChild(newOptionDiv);
            });

            generateTableBtn.addEventListener('click', function() {
                const optVals = document.querySelectorAll('.opt-val');
                let optionArrays = []; 
                
                for(let i=0; i<optVals.length; i++) {
                    if(optVals[i].value.trim() !== '') {
                        const vals = optVals[i].value.split(',').map(v => v.trim()).filter(v => v !== '');
                        if(vals.length > 0) optionArrays.push(vals);
                    }
                }

                if(optionArrays.length === 0) {
                    alert("옵션값을 입력해주세요!");
                    return;
                }

                const combinations = optionArrays.reduce((acc, curr) => 
                    acc.flatMap(d => curr.map(e => [...d, e]))
                , [[]]);

                skuTbody.innerHTML = '';
                const defaultPrice = basePriceInput.value || 0; 

                combinations.forEach(combo => {
                    const comboName = combo.join(' / ');
                    const tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td>
                            \${comboName}
                            <input type="hidden" name="skuNames" value="\${comboName}">
                        </td>
                        <td><input type="number" name="skuPrices" value="\${defaultPrice}" required></td>
                        <td><input type="number" name="skuStocks" value="100" required></td>
                        <td><button type="button" class="remove-btn" onclick="removeSkuRow(this)">X</button></td>
                    `;
                    skuTbody.appendChild(tr);
                });
                skuTable.style.display = 'table';
            });

            // ==========================================
            // 2. 추가 상품 독립형 테이블 생성 로직
            // ==========================================
            const addExtraBtn = document.getElementById('addExtraBtn');
            const extraTable = document.getElementById('extraTable');
            const extraTbody = document.getElementById('extraTbody');

            addExtraBtn.addEventListener('click', function() {
                extraTable.style.display = 'table';
                const tr = document.createElement('tr');
                tr.innerHTML = `
                    <td><input type="text" name="extraNames" placeholder="예: 매트리스 방수커버" required></td>
                    <td><input type="number" name="extraPrices" placeholder="예: 25000" required></td>
                    <td><input type="number" name="extraStocks" value="100" required></td>
                    <td><button type="button" class="remove-btn" onclick="removeExtraRow(this)">X</button></td>
                `;
                extraTbody.appendChild(tr);
            });
        });

        function removeSkuRow(btn) {
            const tbody = document.getElementById('skuTbody');
            btn.parentElement.parentElement.remove();
            if(tbody.children.length === 0) {
                document.getElementById('skuTable').style.display = 'none';
            }
        }

        function removeExtraRow(btn) {
            const tbody = document.getElementById('extraTbody');
            btn.parentElement.parentElement.remove();
            if(tbody.children.length === 0) {
                document.getElementById('extraTable').style.display = 'none';
            }
        }
        
        document.querySelector('form').addEventListener('submit', async function(e) {
            e.preventDefault(); // 기본 폼 제출 동작을 잠시 막습니다.

            const form = this;
            const formData = new FormData(form);

            try {
                // 서버로 폼 데이터 전송 (ProductEditProHandler 실행)
                const response = await fetch(form.action, {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    // 성공 시 알림창 띄우기
                    alert("상품이 정상적으로 수정되었습니다!");
                    
                    // 서버가 리다이렉트한 최종 상세 페이지 주소(response.url)로 이동
                    window.location.href = response.url;
                } else {
                    alert("상품 수정에 실패했습니다. 입력값을 다시 확인해주세요.");
                }
            } catch (error) {
                console.error("상품 수정 오류:", error);
                alert("서버 통신 중 오류가 발생했습니다.");
            }
        });
    </script>
</body>
</html>