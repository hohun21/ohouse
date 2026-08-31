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

.form-container h2 {
	text-align: center;
	color: #333;
	margin-bottom: 20px;
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
</style>
</head>
<body>

	<div class="form-container">
		<h2>✏️ 상품 정보 수정</h2>

		<form action="/seller/productList.htm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="productId" value="${product.productId}">

			<!-- 카테고리 선택 -->
			<div class="form-group">
				<label for="categoryId">카테고리</label> 
				<select id="categoryId" name="categoryId" required>
					<option value="">카테고리를 선택하세요</option>
					<c:forEach var="cat" items="${categoryList}">
						<option value="${cat.categoryId}"
							${cat.categoryId == product.categoryId ? 'selected' : ''}>
							${cat.categoryName}</option>
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

			<!-- 원가 (original_price) -->
			<div class="form-group">
				<label>원가 (정가 - 원)</label> 
				<input type="number" id="originalPrice" name="originalPrice" value="${product.originalPrice}" placeholder="할인 전 원래 가격을 입력하세요" required>
			</div>
			
			<!-- 할인율 (discount_rate) -->
			<div class="form-group">
				<label>할인율 (%)</label> 
				<input type="number" id="discountRate" name="discountRate" value="${product.discountRate}" placeholder="예: 25 (숫자만 입력, 할인 없으면 0 입력)" required>
			</div>

			<!-- 기본 판매 가격 (price - 자동 계산 연동) -->
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
    </script>
</body>
</html>