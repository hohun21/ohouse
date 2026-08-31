/* =====================================================
   결제수단
   ===================================================== */
updateTotalPrice();
const paymentMethods = document.querySelectorAll(".payment-method");

paymentMethods.forEach(function (button) {

    button.addEventListener("click", function () {

        paymentMethods.forEach(function (btn) {
            btn.classList.remove("active");
        });

        button.classList.add("active");

    });

});


/* =====================================================
주문 상품 데이터
===================================================== */

const orderItems = document.querySelectorAll(".order-item");


/* 현재 옵션 변경 중인 상품 */

let currentOrderItem = null;


/* 현재 선택된 변경 옵션 */

let changedOptionData = null;


/* =====================================================
처음 상품들의 수량 버튼
===================================================== */

orderItems.forEach(function (item) {

    const minusButton = item.querySelector(".quantity-minus");

    const plusButton = item.querySelector(".quantity-plus");

    const quantityNumber = item.querySelector(".quantity-number");

    const priceSpan = item.querySelector(".item-price");


    /* 단가 */

    let unitPrice = Number(item.dataset.price);


    /* ---------------------------------------------
       -
    --------------------------------------------- */

    minusButton.addEventListener("click", function () {

        let quantity = Number(quantityNumber.textContent);

        if (quantity <= 1) {
            return;
        }

        quantity--;

        quantityNumber.textContent = quantity;


        priceSpan.textContent = (unitPrice * quantity)
            .toLocaleString("ko-KR") + "원";


        updateTotalPrice();

    });


    /* ---------------------------------------------
       +
    --------------------------------------------- */

    plusButton.addEventListener("click", function () {

        let quantity = Number(quantityNumber.textContent);

        quantity++;

        quantityNumber.textContent = quantity;


        priceSpan.textContent = (unitPrice * quantity)
            .toLocaleString("ko-KR") + "원";


        updateTotalPrice();

    });

});


/* =====================================================
옵션 변경 버튼
===================================================== */

document.querySelectorAll(".option-change-btn")
    .forEach(function (button) {

        button.addEventListener("click", function () {

            /* 어떤 상품의 옵션을 변경하는지 저장 */

            currentOrderItem = this.closest(".order-item");


            if (!currentOrderItem) {
                return;
            }


            /* 모달 초기화 */

            changedOptionData = null;

            document.getElementById("changeOptionArea").innerHTML = "";


            /* 상품 ID */

            const productId = currentOrderItem.dataset.productId;


            /*
             * 상품상세 페이지에서
             * 해당 상품의 옵션 select를 가져온다.
             */

            loadOptionSelects(productId);

        });

    });


/* =====================================================
상품상세의 옵션 select 가져오기
===================================================== */

function loadOptionSelects(productId) {

    fetch("productDetail.htm?product_id=" + encodeURIComponent(productId))
        .then(function (response) {

            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }

            return response.text();

        })
        .then(function (html) {

            /*
             * 받아온 상품상세 HTML을
             * DOM으로 변환
             */

            const parser = new DOMParser();

            const documentData = parser.parseFromString(html, "text/html");


            /*
             * 상품상세에 있는
             * option-select 가져오기
             */

            const originalSelects = documentData.querySelectorAll(".option-select");


            if (originalSelects.length === 0) {

                alert("이 상품에는 선택할 옵션이 없습니다.");

                return;
            }


            const changeOptionArea = document.getElementById("changeOptionArea");


            /*
             * 기존 select를 복제해서
             * 주문서 모달에 넣는다.
             */

            originalSelects.forEach(function (originalSelect) {

                const select = originalSelect.cloneNode(true);


                /*
                 * 상품상세에서 선택된 값이
                 * 남아있을 수 있으므로 초기화
                 */

                select.value = "";


                /*
                 * required 옵션의 첫 번째만 활성화
                 * 나머지는 비활성화
                 */

                select.disabled = true;


                changeOptionArea.appendChild(select);

            });


            /*
             * 옵션 초기화
             */

            initChangeOptions();


            /*
             * 옵션 변경 이벤트
             */

            bindChangeOptionEvents();


            /*
             * 모달 열기
             */

            document.getElementById("optionModal")
                .classList.add("active");

        })
        .catch(function (error) {

            console.error("옵션 목록 가져오기 오류:", error);

            alert("상품 옵션 정보를 가져오지 못했습니다.");

        });

}


/* =====================================================
옵션 초기 상태
===================================================== */

function initChangeOptions() {

    const selects = Array.from(document.querySelectorAll("#changeOptionArea .option-select"));


    let firstRequired = true;


    selects.forEach(function (select) {

        /*
         * 추가 옵션
         */

        if (select.dataset.required === "0") {

            select.disabled = false;

            return;
        }


        /*
         * 필수 옵션
         */

        if (firstRequired) {

            select.disabled = false;

            firstRequired = false;

        } else {

            select.disabled = true;

        }

    });

}


/* =====================================================
옵션 변경 이벤트
===================================================== */

function bindChangeOptionEvents() {

    const selects = Array.from(document.querySelectorAll("#changeOptionArea .option-select"));


    selects.forEach(function (select) {

        select.addEventListener("change", function () {

            handleChangeOption(this);

        });

    });

}


/* =====================================================
옵션 변경 처리
===================================================== */

function handleChangeOption(currentSelect) {

    const selects = Array.from(document.querySelectorAll("#changeOptionArea .option-select"));


    const requiredSelects = selects.filter(function (select) {

        return select.dataset.required === "1";

    });


    /* ---------------------------------------------
       필수 옵션
    --------------------------------------------- */

    if (currentSelect.dataset.required === "1") {

        /*
         * 선택 취소
         */

        if (currentSelect.value === "") {

            const currentIndex = requiredSelects.indexOf(currentSelect);


            /*
             * 뒤에 있는 필수 옵션 초기화
             */

            for (let i = currentIndex + 1; i < requiredSelects.length; i++) {

                requiredSelects[i].value = "";

                requiredSelects[i].disabled = true;

            }


            changedOptionData = null;

            return;

        }


        /*
         * 다음 필수 옵션 활성화
         */

        const currentIndex = requiredSelects.indexOf(currentSelect);


        const nextRequired = requiredSelects[currentIndex + 1];


        if (nextRequired) {

            nextRequired.disabled = false;

        }


        /*
         * 필수 옵션이 전부 선택됐는지
         */

        const allRequiredSelected = requiredSelects.every(function (select) {

            return select.value !== "";

        });


        if (!allRequiredSelected) {

            changedOptionData = null;

            return;

        }


        /*
         * 필수 옵션 전부 선택됨
         */

        findChangedProductOption();

        return;

    }


    /* ---------------------------------------------
       추가 옵션
    --------------------------------------------- */

    if (currentSelect.dataset.required === "0" && currentSelect.value !== "") {

        findChangedProductOption();

    }

}


/* =====================================================
최종 옵션 찾기
===================================================== */

function findChangedProductOption() {

    if (!currentOrderItem) {
        return;
    }


    const productId = currentOrderItem.dataset.productId;


    const selects = Array.from(document.querySelectorAll("#changeOptionArea .option-select"));


    const requiredSelects = selects.filter(function (select) {

        return select.dataset.required === "1";

    });


    const optionalSelects = selects.filter(function (select) {

        return select.dataset.required === "0";

    });


    /*
     * 필수 옵션 전부 선택됐는지 확인
     */

    const allRequiredSelected = requiredSelects.every(function (select) {

        return select.value !== "";

    });


    if (!allRequiredSelected) {
        return;
    }


    /*
     * 필수 옵션 값
     */

    const requiredIds = requiredSelects.map(function (select) {

        return select.value;

    });


    /*
     * 추가 옵션은 선택된 것만
     */

    const selectedOptional = optionalSelects
        .filter(function (select) {

            return select.value !== "";

        })
        .map(function (select) {

            return select.value;

        });


    /*
     * 최종 option_value_ids
     */

    const optionValueIds = requiredIds.concat(selectedOptional);


    /*
     * 상품 옵션 조회
     */

    fetch("productOption.htm?product_id=" + encodeURIComponent(productId) + "&option_value_ids=" + encodeURIComponent(optionValueIds.join(",")))
        .then(function (response) {

            if (!response.ok) {

                throw new Error("HTTP " + response.status);

            }

            return response.json();

        })
        .then(function (data) {

            if (!data) {

                alert("선택한 옵션 조합이 없습니다.");

                return;
            }


            /*
             * 판매 상태
             */

            if (data.status !== "ACTIVE") {

                alert("판매할 수 없는 옵션입니다.");

                return;
            }


            /*
             * 재고
             */

            if (Number(data.stock) <= 0) {

                alert("품절된 옵션입니다.");

                return;
            }
            /*
                        * 선택한 옵션 이름 만들기
                        */

            const names = selects
                .filter(function (select) {

                    return select.value !== "";

                })
                .map(function (select) {

                    return (select.dataset.group_name + " : " + select.options[select.selectedIndex].text);

                });

            /*
             * 옵션 데이터 저장
             */

            changedOptionData = {
                ...data, option_names: names
            };


            /*
             * 모달 안에 현재 선택 옵션 표시
             */

            showChangedOptionPreview(names, data);

        })
        .catch(function (error) {

            console.error("상품 옵션 AJAX 오류:", error);

            alert("옵션 정보를 가져오지 못했습니다.");

        });

}


/* =====================================================
변경될 옵션 미리보기
===================================================== */

function showChangedOptionPreview(names, data) {

    let preview = document.getElementById("changeOptionPreview");


    if (!preview) {

        preview = document.createElement("div");

        preview.id = "changeOptionPreview";

        preview.style.marginTop = "15px";

        preview.style.padding = "15px";

        preview.style.background = "#f7f8f9";

        preview.style.borderRadius = "6px";


        document
            .getElementById("changeOptionArea")
            .appendChild(preview);

    }


    preview.innerHTML = "<div style='font-size:14px; font-weight:600; margin-bottom:8px;'>" + names.join(" / ") + "</div>" +

        "<div style='font-size:14px; color:#666;'>" + Number(data.price)
            .toLocaleString("ko-KR") + "원" + "</div>";

}


/* =====================================================
변경하기
===================================================== */

document.getElementById("optionChangeConfirm")
    .addEventListener("click", function () {

        if (!currentOrderItem) {

            return;

        }


        if (!changedOptionData) {

            alert("변경할 옵션을 선택해주세요.");

            return;

        }


        applyChangedOption(changedOptionData);

    });


/* =====================================================
실제 상품에 옵션 적용
===================================================== */

function applyChangedOption(data) {

    /*
     * 기존 수량 → 1로 초기화
     */

    const quantityElement = currentOrderItem.querySelector(".quantity-number");

    quantityElement.textContent = "1";


    /*
     * 새로운 옵션 정보
     */

    currentOrderItem.dataset.productOptionId = data.product_option_id;

    currentOrderItem.dataset.price = data.price;

    currentOrderItem.dataset.sku = data.sku;


    /*
     * 화면의 옵션 변경
     */

    const optionElement = currentOrderItem.querySelector(".product-option");

    optionElement.textContent = data.option_names.join(" / ");


    /*
     * 가격 변경
     */

    const priceElement = currentOrderItem.querySelector(".item-price");

    priceElement.textContent = Number(data.price)
        .toLocaleString("ko-KR") + "원";


    /*
     * 모달 닫기
     */

    closeOptionModal();


    /*
     * 총액 계산
     */

    updateTotalPrice();
}


/* =====================================================
모달 닫기
===================================================== */

document.getElementById("optionModalClose")
    .addEventListener("click", function () {

        closeOptionModal();

    });


function closeOptionModal() {

    document.getElementById("optionModal")
        .classList.remove("active");


    currentOrderItem = null;

    changedOptionData = null;


    document.getElementById("changeOptionArea").innerHTML = "";

}


/* =====================================================
모달 바깥 클릭
===================================================== */

document.getElementById("optionModal")
    .addEventListener("click", function (event) {

        if (event.target === this) {

            closeOptionModal();

        }

    });


/* =====================================================
총 상품금액 갱신
===================================================== */

function updateTotalPrice() {
    let productTotal = 0;

    document.querySelectorAll(".order-item").forEach(function (item) {
        const priceElement = item.querySelector(".item-price");

        const price = Number(
            priceElement.textContent.replace(/[^0-9]/g, "")
        );

        productTotal += price;
    });

    const deliveryFee = 3000;

    // 선택된 쿠폰
    const couponSelect = document.getElementById("couponSelect");
    const selectedCoupon = couponSelect
        ? couponSelect.options[couponSelect.selectedIndex]
        : null;

    let couponDiscount = 0;

    if (selectedCoupon && selectedCoupon.value !== "") {
        const discountType = selectedCoupon.dataset.type;
        const discountValue = Number(selectedCoupon.dataset.value) || 0;
        const maxDiscount = Number(selectedCoupon.dataset.max) || 0;
        const minOrderPrice = Number(selectedCoupon.dataset.min) || 0;

        // 최소 주문금액 조건
        if (productTotal >= minOrderPrice) {

            if (discountType === "RATE") {
                // 퍼센트 할인
                couponDiscount = Math.floor(
                    productTotal * discountValue / 100
                );

                // 최대 할인금액 제한
                if (maxDiscount > 0) {
                    couponDiscount = Math.min(
                        couponDiscount,
                        maxDiscount
                    );
                }

            } else if (discountType === "AMOUNT") {
                // 정액 할인
                couponDiscount = discountValue;
            }
        }
    }

    const pointDiscount = 0;

    const finalPrice = Math.max(
        0,
        productTotal
        + deliveryFee
        - couponDiscount
        - pointDiscount
    );

    document.getElementById("productTotal").textContent =
        productTotal.toLocaleString("ko-KR") + "원";

    document.getElementById("deliveryFee").textContent =
        deliveryFee.toLocaleString("ko-KR") + "원";

    document.getElementById("couponDiscount").textContent =
        "-" + couponDiscount.toLocaleString("ko-KR") + "원";

    document.getElementById("pointDiscount").textContent =
        "-" + pointDiscount.toLocaleString("ko-KR") + "원";

    document.getElementById("finalPrice").textContent =
        finalPrice.toLocaleString("ko-KR") + "원";
}


/* =====================================================
결제
===================================================== */

function payment() {

    const agreement = document.querySelector("#agreement");


    if (!agreement.checked) {

        alert("주문 내용 확인 및 결제 동의가 필요합니다.");

        agreement.focus();

        return;

    }


    alert("결제 페이지로 이동합니다.");

}
