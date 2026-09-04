const product_id = new URLSearchParams(window.location.search).get("product_id");
const selects = Array.from(document.querySelectorAll(".option-select"));
const warning = document.getElementById("optionWarning");

/* 처음 상태 */
let first_required = true;

selects.forEach(function (select) {
    if (select.dataset.required === "0") {
        select.disabled = false;
    } else if (first_required) {
        select.disabled = false;
        first_required = false;
    } else {
        select.disabled = true;
    }
});

/* 옵션 변경 */
selects.forEach(function (select) {
    select.addEventListener("change", function () {

        /* 필수 옵션 */
        if (this.dataset.required === "1") {
            const required_selects = selects.filter(function (select) {
                return select.dataset.required === "1";
            });

            /* 선택을 취소한 경우 */
            if (this.value === "") {
                const current_index = required_selects.indexOf(this);

                for (let i = current_index + 1; i < required_selects.length; i++) {
                    required_selects[i].value = "";
                    required_selects[i].disabled = true;
                }

                warning.style.display = "block";
                return;
            }

            /* 다음 필수 옵션 활성화 */
            const current_index = required_selects.indexOf(this);
            const next_required = required_selects[current_index + 1];

            if (next_required) {
                next_required.disabled = false;
            }

            /* 필수 옵션 전부 선택됐는지 확인 */
            const all_required_selected = required_selects.every(function (select) {
                return select.value !== "";
            });

            if (!all_required_selected) {
                warning.style.display = "block";
                return;
            }

            warning.style.display = "none";
            findProductOption();
            return;
        }

        /* 추가 옵션 */
        if (this.dataset.required === "0" && this.value !== "") {
            findAdditionalProductOption(this);
        }
    });
});


function findProductOption() {
    const required_selects = selects.filter(function (select) {
        return select.dataset.required === "1";
    });

    /* 필수 옵션 */
    const all_required_selected = required_selects.every(function (select) {
        return select.value !== "";
    });

    if (all_required_selected) {
        const option_value_ids = required_selects.map(function (select) {
            return select.value;
        });
        const optionKey = option_value_ids.join(",");

        const selectedOptions =
            document.querySelectorAll(".selected-option");

        for (const selectedOption of selectedOptions) {
            if (selectedOption.dataset.option_value_ids === optionKey) {
                showToast("이미 선택된 옵션입니다.");
                initOptions();
                return;
            }
        }

        const names = required_selects.map(function (select) {
            return select.dataset.group_name + " : " +
                select.options[select.selectedIndex].text;
        });

        fetch(
            "productOption.htm?product_id=" +
            encodeURIComponent(product_id) +
            "&option_value_ids=" +
            encodeURIComponent(option_value_ids.join(","))
        )
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("HTTP " + response.status);
                }
                return response.json();
            })
            .then(function (data) {
                if (!data) {
                    showToast("선택한 옵션 조합이 없습니다.");
                    initOptions();
                    return;
                }

                if (data.status !== "ACTIVE") {
                    showToast("현재 판매할 수 없는 옵션입니다.");
                    initOptions();
                    return;
                }

                if (Number(data.stock) <= 0) {
                    showToast("현재 품절된 옵션입니다.");
                    initOptions();
                    return;
                }

                createSelectedOption(data, names, option_value_ids);
            })
            .catch(function (error) {
                console.error("상품 옵션 AJAX 오류:", error);
                alert("옵션 정보를 가져오지 못했습니다.");
            });
    } else {
        warning.style.display = "block";
    }

}

/* 추가상품은 필수 옵션 조합과 독립적으로 조회한다. */
function findAdditionalProductOption(select) {
    const optionValueId = select.value;
    const name = select.dataset.group_name + " : " +
        select.options[select.selectedIndex].text;

    fetch(
        "productOption.htm?product_id=" +
        encodeURIComponent(product_id) +
        "&option_value_ids=" +
        encodeURIComponent(optionValueId)
    )
        .then(function (response) {
            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }
            return response.json();
        })
        .then(function (data) {
            if (!data) {
                showToast("선택한 추가 옵션이 없습니다.");
                select.value = "";
                return;
            }

            if (data.status !== "ACTIVE") {
                showToast("현재 판매할 수 없는 추가 옵션입니다.");
                select.value = "";
                return;
            }

            if (Number(data.stock) <= 0) {
                showToast("현재 품절된 추가 옵션입니다.");
                select.value = "";
                return;
            }

            createSelectedOption(
                data,
                [name],
                [optionValueId]
            );

            select.value = "";
        })
        .catch(function (error) {
            console.error("추가 옵션 AJAX 오류:", error);
            alert("추가 옵션 정보를 가져오지 못했습니다.");
        });
}

function showToast(message) {
    const toast = document.getElementById("optionToast");

    toast.textContent = message;
    toast.style.display = "block";

    clearTimeout(toast.timer);

    toast.timer = setTimeout(function () {
        toast.style.display = "none";
    }, 2000);
}

const selectOptionData = [];

function createSelectedOption(data, names, option_value_ids) {
    const selectedOptionValueIds = option_value_ids.map(Number);
    const maxStock = Number(data.stock);

    const options =
        selects
            .filter(function (select) {
                return selectedOptionValueIds.includes(
                    Number(select.value)
                );
            })
            .map(function (select) {

                const selectedOption =
                    select.options[select.selectedIndex];

                return {
                    option_group_id: Number(select.dataset.group_id),
                    option_group_name: select.dataset.group_name,
                    option_value_id: Number(select.value),
                    option_value_name: selectedOption.text
                };
            });
            
    const productName = document.querySelector(".product-name").textContent.trim();
    const productImage = document.querySelector("#mainProductImage").src;

    const optionData = {
        brand_id : data.brand_id,
        brand_name: data.brand_name,
        product_option_id: data.product_option_id,
        product_id: data.product_id,
        sku: data.sku,
        price: data.price,
        product_name: productName,
        image_url: productImage,
        quantity: 1,
        options: options
    };
    selectOptionData.push(optionData);

    const selectedList = document.getElementById("selectedList");
    if (!selectedList) return;

    const div = document.createElement("div");
    div.className = "selected-option";
    div.dataset.option_value_ids = option_value_ids.join(",");

    const nameDiv = document.createElement("div");
    nameDiv.className = "selected-name";
    nameDiv.textContent = names.join(" / ");

    const bottomDiv = document.createElement("div");
    bottomDiv.className = "selected-bottom";

    const quantityDiv = document.createElement("div");
    quantityDiv.className = "quantity";

    const minusButton = document.createElement("button");
    minusButton.type = "button";
    minusButton.textContent = "-";

    const quantityNumber = document.createElement("span");
    quantityNumber.className = "quantity-number";
    quantityNumber.textContent = "1";

    const plusButton = document.createElement("button");
    plusButton.type = "button";
    plusButton.textContent = "+";

    quantityDiv.appendChild(minusButton);
    quantityDiv.appendChild(quantityNumber);
    quantityDiv.appendChild(plusButton);

    const priceSpan = document.createElement("span");
    priceSpan.className = "selected-price";

    const unitPrice = Number(data.price);
    priceSpan.textContent = unitPrice.toLocaleString("ko-KR") + "원";

    const removeButton = document.createElement("button");
    removeButton.type = "button";
    removeButton.className = "remove";
    removeButton.textContent = "×";

    bottomDiv.appendChild(quantityDiv);
    bottomDiv.appendChild(priceSpan);
    bottomDiv.appendChild(removeButton);

    div.appendChild(nameDiv);
    div.appendChild(bottomDiv);
    selectedList.appendChild(div);

    minusButton.addEventListener("click", function () {
        let quantity = Number(quantityNumber.textContent);

        if (quantity > 1) {
            quantity--;
            quantityNumber.textContent = quantity;
            optionData.quantity = quantity

            priceSpan.textContent =
                (unitPrice * quantity).toLocaleString("ko-KR") + "원";

            updateTotalPrice();
        }
    });

    plusButton.addEventListener("click", function () {
        let quantity = Number(quantityNumber.textContent);

        if (quantity >= maxStock) {
            alert(`재고가 부족합니다. (최대 ${maxStock}개 구매 가능)`);
            return;
        }

        quantity++;
        quantityNumber.textContent = quantity;
        optionData.quantity = quantity

        priceSpan.textContent =
            (unitPrice * quantity).toLocaleString("ko-KR") + "원";

        updateTotalPrice();
    });

    removeButton.addEventListener("click", function () {
        const index = selectOptionData.indexOf(optionData);
        if (index !== -1) selectOptionData.splice(index, 1);
        div.remove();
        updateTotalPrice();
    });

    initOptions();
    updateTotalPrice();
}

function initOptions() {
    const required_selects = Array.from(
        document.querySelectorAll(".option-select")
    ).filter(function (select) {
        return select.dataset.required === "1";
    });

    required_selects.forEach(function (select, index) {
        select.value = "";

        if (index === 0) {
            select.disabled = false;
        } else {
            select.disabled = true;
        }
    });
}

function updateTotalPrice() {
    const selectedOptions = document.querySelectorAll(".selected-option");
    let total_price = 0;

    selectedOptions.forEach(function (selectedOption) {
        const priceText = selectedOption.querySelector(".selected-price")
                .textContent
                .replace(/[^0-9]/g, "");
        const price = Number(priceText);
        total_price += price;
    });

    const totalPrice = document.getElementById("totalPrice");
    if (totalPrice) {
        totalPrice.textContent = total_price.toLocaleString("ko-KR") + "원";
    }
}

function changeImage(element) {
    const image = element.querySelector("img");
    const mainImage = document.getElementById("mainProductImage");

    if (!image || !mainImage) {
        return;
    }

    mainImage.src = image.src;

    document.querySelectorAll(".thumb").forEach(function (thumb) {
        thumb.classList.remove("active");
    });

    element.classList.add("active");
}

$(".cart").on("click", async function () {
    if (selectOptionData.length === 0) {
        showToast("옵션 선택 후에 버튼을 클릭해주세요.");
        return;
    }

    try {
        const response = await fetch("/cart/cartAdd.htm", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(selectOptionData)
        });

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`장바구니 전송 실패 (${response.status})`);
        }

        location.href = "/cart/cart.htm";

    } catch (error) {
        console.error("장바구니 처리 오류:", error);
    }
});

$(".buy").on("click", async function () {
    if (selectOptionData.length === 0) {
        showToast("옵션 선택 후에 버튼을 클릭해주세요.");
        return;
    }

    try {
        const response = await fetch("/productOrder.htm", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(selectOptionData)
        });

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(`주문정보 전송 실패 (${response.status})`);
        }

        location.href = "/order/order.htm";

    } catch (error) {
        console.error("주문 처리 오류:", error);
    }
});

document.querySelectorAll('.tabs a').forEach(tab => {
    tab.addEventListener('click', function(e) {
        e.preventDefault(); 
        document.querySelectorAll('.tabs a').forEach(t => t.classList.remove('active'));
        this.classList.add('active');

        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        
        const targetId = this.getAttribute('href');
        document.querySelector(targetId).classList.add('active');
    });
});

// 수정 모달 열기 (기존 리뷰 데이터를 가져와서 모달 폼에 채워주는 비동기 호출 등 연결)
// 수정 모달 열기 및 기존 데이터 바인딩
// 수정 모달 열기 및 기존 데이터 바인딩 (안전 장치 포함)
function openEditReviewModal(reviewId, rating, content, imageUrl) {
	
    console.log("openEditReviewModal 실행됨! 데이터:", { reviewId, rating, content, imageUrl });

    const reviewIdEl = document.getElementById("editReviewId");
    const ratingEl = document.getElementById("editRating");
    const contentEl = document.getElementById("editContent");
    const imageUrlEl = document.getElementById("editImageUrl");
    const modalEl = document.getElementById("reviewEditModal");

    // 각 요소가 실제로 존재하는지 확인 (없으면 콘솔에 에러 출력)
    if (!reviewIdEl) console.error("id가 'editReviewId'인 요소를 찾을 수 없습니다.");
    if (!ratingEl) console.error("id가 'editRating'인 요소를 찾을 수 없습니다.");
    if (!contentEl) console.error("id가 'editContent'인 요소를 찾을 수 없습니다.");
    if (!imageUrlEl) console.error("id가 'editImageUrl'인 요소를 찾을 수 없습니다.");
    if (!modalEl) console.error("id가 'reviewEditModal'인 요소를 찾을 수 없습니다.");

    if (reviewIdEl) reviewIdEl.value = reviewId;
    if (ratingEl) ratingEl.value = rating;
    if (contentEl) contentEl.value = content;
    if (imageUrlEl) imageUrlEl.value = imageUrl;
    
    if (modalEl) {
        modalEl.style.display = "flex";
        console.log("모달 display = flex 적용 완료!");
    }
}

// 모달 닫기
function closeEditReviewModal() {
    const modalEl = document.getElementById("reviewEditModal");
    if (modalEl) {
        modalEl.style.display = "none";
    }
}

// 리뷰 삭제 요청 함수
function deleteReview(reviewId, productId) {
    if (confirm("정말 삭제하시겠습니까?")) {
		location.href = "deleteReview.htm?reviewId=" + reviewId;
       }
}

// 이벤트 위임 (data-* 속성 매칭)
document.addEventListener("click", function(event) {
    const editBtn = event.target.closest(".js-edit-review-btn");
    if (editBtn) {
        const reviewId = editBtn.getAttribute("data-review-id");
        const rating = editBtn.getAttribute("data-rating");
        const content = editBtn.getAttribute("data-content");
		const imageUrl = editBtn.getAttribute("date-image-url");
        
        openEditReviewModal(reviewId, rating, content);
    }
});


document.addEventListener("DOMContentLoaded", function () {
    const urlParams = new URLSearchParams(window.location.search);
    
    // 마이페이지에서 수정 버튼을 눌러 넘어온 경우
    if (urlParams.get("openEdit") === "true") {
        const reviewId = urlParams.get("reviewId");
        const rating = urlParams.get("rating");
        const content = decodeURIComponent(urlParams.get("content") || "");
        const imageUrl = decodeURIComponent(urlParams.get("imageUrl") || "");
        const productId = urlParams.get("product_id");

        // 위에 정의하신 openEditReviewModal 함수 호출
        if (typeof openEditReviewModal === "function") {
            openEditReviewModal(reviewId, rating, content, imageUrl);
        }
        
        // 주소창 파라미터 정리 (새로고침 시 모달 중복 실행 방지)
        window.history.replaceState({}, document.title, window.location.pathname + "?product_id=" + productId);
    }
});