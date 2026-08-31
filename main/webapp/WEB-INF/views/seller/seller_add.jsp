<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매자 센터 - 상품 등록</title>
<style>
body {
	font-family: 'Malgun Gothic', sans-serif;
	background-color: #f7f9fa;
	margin: 0;
	padding: 40px;
}

.form-container {
	max-width: 750px;
	background-color: white;
	padding: 30px;
	margin: 0 auto;
	border-radius: 8px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

/* 💡 타이틀 영역 정렬을 위한 스타일 추가 */
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
	font-size: 22px;
}

/* 대시보드 가기 버튼 스타일 */
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

.brand-display {
	font-size: 15px;
	font-weight: bold;
	color: #35c5f0;
	padding: 10px;
	background-color: #f0f9fc;
	border: 1px solid #bce8f1;
	border-radius: 4px;
}
</style>
</head>
<body>

	<div class="form-container">
		<!-- 💡 타이틀과 대시보드 버튼을 감싸는 헤더 영역 -->
		<div class="form-header">
			<h2>📦 내 상품 상세 등록</h2>
			<a href="${pageContext.request.contextPath}/seller/dashboard.htm" class="btn-dashboard">📊 대시보드로 가기</a>
		</div>

		<form action="/seller/addPro.htm" method="post"
			enctype="multipart/form-data">

			<!-- 카테고리 선택 -->
			<div class="form-group">
				<label for="categoryId">카테고리</label> <select id="categoryId"
					name="categoryId" required>
					<option value="">카테고리를 선택하세요</option>
					<c:forEach var="cat" items="${categoryList}">
						<option value="${cat.categoryId}">${cat.categoryName}</option>
					</c:forEach>
				</select>
			</div>

			<!-- 브랜드명 (세션에서 자동 연동 및 고정 출력) -->
			<div class="form-group">
				<label for="brandName">브랜드명</label> <input type="text" id="brandName" name="brandName" 
       value="${sessionScope.sellerAuth.brandName}" readonly>
			</div>

			<!-- 상품명 -->
			<div class="form-group">
				<label>상품명</label> <input type="text" name="productName"
					placeholder="예: [단독] 아쿠아텍스 3인용 소파" required>
			</div>

			<!-- 상품 상세 설명 -->
			<div class="form-group">
				<label>상품 상세 설명</label>
				<textarea name="description" rows="5"
					placeholder="상품에 대한 상세한 설명을 입력하세요" required></textarea>
			</div>

			<!-- 원가 (original_price) -->
			<div class="form-group">
				<label>원가 (정가 - 원)</label> <input type="number" id="originalPrice"
					name="originalPrice" placeholder="할인 전 원래 가격을 입력하세요" required>
			</div>

			<!-- 할인율 (discount_rate) -->
			<div class="form-group">
				<label>할인율 (%)</label> <input type="number" id="discountRate"
					name="discountRate" placeholder="예: 25 (숫자만 입력, 할인 없으면 0 입력)"
					value="0" required>
			</div>

			<!-- 기본 판매 가격 (price - 자동 계산 연동) -->
			<div class="form-group">
				<label id="basePriceLabel">기본 판매 가격 (실제 판매가 - 원)</label> <input
					type="number" id="basePrice" name="price"
					placeholder="원가와 할인율을 입력하면 자동으로 계산됩니다" required>
			</div>

			<!-- 상품 이미지 첨부 영역 -->
			<div class="form-group">
				<label style="color: #333;">상품 이미지 첨부 (다중 선택 가능)</label> <input
					type="file" name="productImages" accept="image/*" multiple
					style="width: 100%; padding: 15px; border: 2px dashed #ddd; border-radius: 5px; background-color: #fafafa; cursor: pointer; box-sizing: border-box;">
				<p
					style="margin-top: 8px; font-size: 13px; color: #888; margin-bottom: 0;">
					💡 Shift나 Ctrl을 누른 상태로 여러 장의 사진을 한 번에 선택할 수 있습니다. (첫 번째 사진이 대표 이미지로
					지정됩니다)</p>
			</div>

			<!-- 필수 옵션 설정 -->
			<div class="form-group">
				<div class="option-header">
					<label>필수 옵션 설정 (쉼표로 구분)</label>
					<button type="button" class="btn-small" id="addOptionBtn">➕
						옵션 추가</button>
				</div>

				<div id="optionContainer">
					<div class="option-item">
						<input type="text" name="optionNames" class="opt-name"
							placeholder="옵션명 (예: 색상)"> <input type="text"
							name="optionValues" class="opt-val" placeholder="옵션값 (예: 화이트,블랙)">
					</div>
				</div>
				<button type="button" class="btn-generate" id="generateTableBtn">옵션
					목록 만들기</button>

				<table class="sku-table" id="skuTable" style="display: none;">
					<thead>
						<tr>
							<th>옵션 조합명</th>
							<th>판매가 (원)</th>
							<th>재고 (개)</th>
						</tr>
					</thead>
					<tbody id="skuTbody"></tbody>
				</table>
			</div>

			<!-- 추가 상품 설정 -->
			<div class="form-group">
				<div class="option-header">
					<label>추가 상품 설정 (선택)</label>
					<button type="button" class="btn-small" id="addExtraBtn"
						style="background-color: #35c5f0; color: white; border: none;">➕
						추가상품 추가</button>
				</div>

				<table class="sku-table" id="extraTable" style="display: none;">
					<thead>
						<tr>
							<th>추가 상품명</th>
							<th>추가 가격 (원)</th>
							<th>재고 (개)</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody id="extraTbody"></tbody>
				</table>
			</div>

			<button type="submit" class="submit-btn">상품 등록하기</button>
		</form>
	</div>

	<script>
        document.addEventListener('DOMContentLoaded', function() {
            // 1. 원가 및 할인율에 따른 판매가 자동 계산 로직
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

            // 2. 필수 옵션 조합형 테이블 생성 로직
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
                newOptionDiv.querySelector('button').className = 'remove-btn';
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
                    `;
                    skuTbody.appendChild(tr);
                });
                skuTable.style.display = 'table';
            });

            // 3. 추가 상품 독립형 테이블 생성 로직
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

        function removeExtraRow(btn) {
            const tbody = document.getElementById('extraTbody');
            btn.parentElement.parentElement.remove();
            if(tbody.children.length === 0) {
                document.getElementById('extraTable').style.display = 'none';
            }
        }
    </script>
</body>
</html>