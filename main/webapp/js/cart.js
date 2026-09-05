let currentCartBrand = null;
let currentCartProduct = null;
let changedCartItems = [];
let changedOptionData = null;
let originalCartItemIds = [];


$(function () {
    updatePrice();
    updateCheckAll();
});

/* =========================
   전체 금액
========================= */

function updatePrice() {
    let totalProductPrice = 0;

    $(".cart-product").each(function () {
        let productTotal = 0;

        $(this).find(".cart-item").each(function () {
            const price = Number(this.dataset.price) || 0;
            const quantity = Number($(this).find(".quantity-input").val()) || 0;

            productTotal += price * quantity;
        });

        $(this)
            .find(".product-total-price")
            .text(productTotal.toLocaleString("ko-KR") + "원");

        totalProductPrice += productTotal;
    });

    $("#totalProductPrice").text(totalProductPrice.toLocaleString("ko-KR") + "원");
    // 결제금액 영역
    $("#productPrice").text(totalProductPrice.toLocaleString("ko-KR") + "원");

    const discountPrice = 0;
    const deliveryPrice = 0;
    const totalPrice = totalProductPrice - discountPrice + deliveryPrice;

    $("#discountPrice").text("-" + discountPrice.toLocaleString("ko-KR") + "원");

    $("#deliveryPrice").text(deliveryPrice.toLocaleString("ko-KR") + "원");

    $("#totalPrice").text(totalPrice.toLocaleString("ko-KR") + "원");
}

/* =========================
   체크박스
========================= */

$("#checkAll").on("change", function () {
    const checked = $(this).prop("checked");

    $(".cart-product-header .item-check-box")
        .prop("checked", checked);

    updatePrice();
});

$(document).on("change", ".cart-product-header .item-check-box", function () {
    updateCheckAll();
    updatePrice();
});

function updateCheckAll() {
    const total = $(".cart-product-header .item-check-box").length;

    const checked = $(".cart-product-header .item-check-box:checked").length;

    $("#checkAll").prop("checked", total > 0 && total === checked);
}

/* =========================
   수량 변경
========================= */

$(document).on("click", ".plus, .minus", async function () {

    const cartItem = $(this).closest(".cart-item")[0];

    if (!cartItem) return;

    const input = cartItem.querySelector(".quantity-input");

    const oldQuantity = Number(input.value);

    let quantity = oldQuantity;

    if ($(this).hasClass("plus")) {
        quantity++;
    } else {
        quantity--;

        if (quantity < 1) {
            quantity = 1;
        }
    }

    input.value = quantity;

    try {
        await updateQuantity(cartItem, quantity);

        input.defaultValue = quantity;

        updateCartItemPrice(cartItem);

        const product = cartItem.closest(".cart-product");

        updateProductTotal(product);
        updatePrice();

    } catch (error) {

        input.value = oldQuantity;

        console.error("수량 변경 오류:", error);

        alert("수량 변경에 실패했습니다.");
    }
});

$(document).on("change", ".quantity-input", async function () {

    const input = this;

    const cartItem = $(input).closest(".cart-item")[0];

    if (!cartItem) return;

    const oldQuantity = Number(input.defaultValue || input.value);

    let quantity = Number(input.value);

    if (!Number.isInteger(quantity) || quantity < 1) {
        quantity = 1;
    }

    input.value = quantity;

    try {
        await updateQuantity(cartItem, quantity);

        input.defaultValue = quantity;

        updateCartItemPrice(cartItem);

        const product = cartItem.closest(".cart-product");

        updateProductTotal(product);
        updatePrice();

    } catch (error) {

        input.value = oldQuantity;

        console.error("수량 변경 오류:", error);

        alert("수량 변경에 실패했습니다.");
    }
});

async function updateQuantity(cartItem, quantity) {
    const cartItemsId = Number(cartItem.dataset.cartItemsId);

    const response = await fetch("/cart/cartQuantityEdit.htm", {
        method: "POST", headers: {
            "Content-Type": "application/json"
        }, body: JSON.stringify({
            cart_items_id: cartItemsId, quantity: quantity
        })
    });

    if (!response.ok) {
        throw new Error("수량 변경 실패");
    }
}

function updateCartItemPrice(cartItem) {
    const price = Number(cartItem.dataset.price || 0);

    const quantity = Number(cartItem
        .querySelector(".quantity-input").value || 0);

    const priceElement = cartItem.querySelector(".price");

    if (!priceElement) return;

    priceElement.textContent = (price * quantity).toLocaleString("ko-KR") + "원";
}

function updateProductTotal(product) {
    if (!product) return;

    let total = 0;

    $(product)
        .find(".cart-item")
        .each(function () {

            const price = Number(this.dataset.price || 0);

            const quantity = Number($(this)
                .find(".quantity-input")
                .val() || 0);

            total += price * quantity;
        });

    $(product)
        .find(".product-total-price")
        .text(total.toLocaleString("ko-KR") + "원");
}

/* =========================
   개별 삭제
========================= */

$(document).on("click", ".remove", async function () {

    const item = $(this).closest(".cart-item");

    const cartItemsId = Number(item.data("cart-items-id"));

    if (!confirm("상품을 삭제하시겠습니까?")) {
        return;
    }

    try {

        const response = await fetch("/cart/cartDelete.htm", {
            method: "POST", headers: {
                "Content-Type": "application/json"
            }, body: JSON.stringify({
                cart_items_id: cartItemsId
            })
        });

        if (!response.ok) {
            throw new Error("삭제 실패");
        }

        const product = item.closest(".cart-product");

        item.remove();

        if ($(product).find(".cart-item").length === 0) {
            const brand = product.closest(".brand-group");
            $(product).remove();
            if($(brand).find(".cart-product").length === 0) {
                $(brand).remove();
            }
        } else {
            updateProductTotal(product);
        }

        updateCheckAll();
        updatePrice();

    } catch (error) {

        console.error("삭제 오류:", error);

        alert("상품 삭제에 실패했습니다.");
    }
});

/* =========================
   선택 삭제
========================= */

$("#deleteSelected").on("click", async function () {

    const ids = [];

    $(".cart-product")
        .filter(function () {
            return $(this)
                .find(".item-check-box")
                .prop("checked");
        })
        .each(function () {

            $(this)
                .find(".cart-item")
                .each(function () {

                    ids.push(Number(this.dataset.cartItemsId));
                });
        });

    if (ids.length === 0) {
        alert("삭제할 상품을 선택해주세요.");
        return;
    }

    if (!confirm("선택한 상품을 삭제하시겠습니까?")) {
        return;
    }

    try {

        const response = await fetch("/cart/cartDelete.htm", {
            method: "POST", headers: {
                "Content-Type": "application/json"
            }, body: JSON.stringify(ids)
        });

        if (!response.ok) {
            throw new Error("삭제 실패");
        }

        $(".cart-product")
            .filter(function () {
                return $(this)
                    .find(".item-check-box")
                    .prop("checked");
            })
            .remove();

        updateCheckAll();
        updatePrice();

    } catch (error) {

        console.error("선택 삭제 오류:", error);

        alert("상품 삭제에 실패했습니다.");
    }
});

/* =========================
   전체 구매
========================= */

$("#buyBtn").on("click", async function () {
    const selectedItems = [];

    $(".cart-product").each(function () {
        if (!$(this).find(".item-check-box").prop("checked")) {
            return;
        }

        $(this).find(".cart-item").each(function () {
            selectedItems.push({
                cart_items_id: Number(this.dataset.cartItemsId),
                brand_id: Number(this.dataset.brandId),
                product_id: Number(this.dataset.productId),
                product_option_id: Number(this.dataset.productOptionId),
                product_name: this.dataset.productName,
                image_url: this.dataset.imageUrl,
                sku: this.dataset.sku,
                price: Number(this.dataset.price),
                quantity: Number($(this).find(".quantity-input").val()),
                options: JSON.parse(this.dataset.options || "[]")
            });
        });
    });

    if (selectedItems.length === 0) {
        alert("구매할 상품을 선택해주세요.");
        return;
    }

    try {
        const response = await fetch("/cart/cartOrder.htm", {
            method: "POST", headers: {
                "Content-Type": "application/json"
            }, body: JSON.stringify(selectedItems)
        });

        if (!response.ok) {
            throw new Error("주문 데이터 생성 실패");
        }

        location.href = "/order/order.htm?from=cart";

    } catch (error) {
        console.error("주문 이동 오류:", error);
        alert("주문 페이지로 이동할 수 없습니다.");
    }
});
/* =========================
   상품별 구매
========================= */

$(document).on("click", ".product-buy-btn", function () {

    const product = $(this).closest(".cart-product");

    const selectedItems = [];

    product
        .find(".cart-item")
        .each(function () {

            selectedItems.push({
                cart_items_id: Number(this.dataset.cartItemsId),

                quantity: Number($(this)
                    .find(".quantity-input")
                    .val())
            });
        });

    if (selectedItems.length === 0) {
        return;
    }

    sessionStorage.setItem("selectedCartItems", JSON.stringify(selectedItems));

    location.href = "/order.htm";
});

/* =========================================================
   옵션 변경
========================================================= */

$(document).on("click", ".option-change-btn", function () {

    currentCartBrand = $(this)
        .closest(".brand-group")[0];

    currentCartProduct = $(currentCartBrand)
        .find(".cart-product")
        .first()[0];

    if (!currentCartBrand || !currentCartProduct) {
        return;
    }

    changedCartItems = [];

    collectCurrentCartItems();

    originalCartItemIds = changedCartItems
        .filter(function (item) {
            return item.cartItemsId !== null;
        })
        .map(function (item) {
            return Number(item.cartItemsId);
        });

    $("#changeOptionArea").empty();

    $("#changeOptionPreview")
        .empty()
        .show();

    renderCurrentCartItems();

    const productId = $(currentCartProduct)
        .data("product-id");

    loadCartOptionSelects(productId);
});

/* =========================================================
   현재 브랜드 장바구니 항목 수집
========================================================= */

function collectCurrentCartItems() {

    changedCartItems = [];

    $(currentCartBrand)
        .find(".cart-product .cart-item")
        .each(function () {

            changedCartItems.push({
                cartItemsId: Number(this.dataset.cartItemsId),

                productOptionId: Number(this.dataset.productOptionId),

                price: Number(this.dataset.price || 0),

                quantity: Number($(this)
                    .find(".quantity-input")
                    .val() || 1),

                sku: this.dataset.sku || "",

                optionName: $(this)
                    .find(".option")
                    .text()
                    .trim(),

                isAdditional: false,

                isNew: false
            });
        });
}

/* =========================================================
   현재 브랜드 CART_ITEM 모달 표시
========================================================= */

function renderCurrentCartItems() {

    const preview = document.getElementById("changeOptionPreview");

    if (!preview) {
        return;
    }

    preview.innerHTML = "";

    changedCartItems.forEach(function (item, index) {

        const div = document.createElement("div");

        div.className = "change-option-item";

        div.dataset.index = index;

        div.dataset.cartItemsId = item.cartItemsId ?? "";

        div.dataset.productOptionId = item.productOptionId;

        const nameDiv = document.createElement("div");

        nameDiv.className = "change-option-item-name";

        const name = document.createElement("span");

        name.textContent = item.isAdditional ? "추가상품 - " + item.optionName : item.optionName;

        const removeButton = document.createElement("button");

        removeButton.type = "button";
        removeButton.className = "change-option-remove";
        removeButton.textContent = "×";

        nameDiv.appendChild(name);
        nameDiv.appendChild(removeButton);

        const bottomDiv = document.createElement("div");

        bottomDiv.className = "change-option-item-bottom";

        const quantityDiv = document.createElement("div");

        quantityDiv.className = "change-option-quantity";

        const minusButton = document.createElement("button");

        minusButton.type = "button";
        minusButton.className = "change-qty-minus";
        minusButton.textContent = "−";

        const quantityNumber = document.createElement("span");

        quantityNumber.className = "change-qty-count";

        quantityNumber.textContent = item.quantity;

        const plusButton = document.createElement("button");

        plusButton.type = "button";
        plusButton.className = "change-qty-plus";
        plusButton.textContent = "+";

        quantityDiv.appendChild(minusButton);
        quantityDiv.appendChild(quantityNumber);
        quantityDiv.appendChild(plusButton);

        const price = document.createElement("strong");

        price.className = "change-option-item-price";

        price.textContent = (Number(item.price) * Number(item.quantity)).toLocaleString("ko-KR") + "원";

        bottomDiv.appendChild(quantityDiv);
        bottomDiv.appendChild(price);

        div.appendChild(nameDiv);
        div.appendChild(bottomDiv);

        preview.appendChild(div);
    });

    updateChangeModalPrice();
}

/* =========================================================
   모달 총액
========================================================= */

function updateChangeModalPrice() {

    let total = 0;

    changedCartItems.forEach(function (item) {

        total += Number(item.price || 0) * Number(item.quantity || 0);
    });

    $("#changeOptionTotal")
        .text(total.toLocaleString("ko-KR") + "원");
}

/* =========================================================
   모달 수량 +
========================================================= */

$(document).on("click", ".change-qty-plus", function () {

    const row = $(this)
        .closest(".change-option-item");

    const index = Number(row.data("index"));

    if (!changedCartItems[index]) {
        return;
    }

    changedCartItems[index].quantity++;

    renderCurrentCartItems();
});

/* =========================================================
   모달 수량 -
========================================================= */

$(document).on("click", ".change-qty-minus", function () {

    const row = $(this)
        .closest(".change-option-item");

    const index = Number(row.data("index"));

    if (!changedCartItems[index]) {
        return;
    }

    if (changedCartItems[index].quantity <= 1) {
        return;
    }

    changedCartItems[index].quantity--;

    renderCurrentCartItems();
});

/* =========================================================
   모달 항목 삭제
========================================================= */

$(document).on("click", ".change-option-remove", function () {

    const row = $(this)
        .closest(".change-option-item");

    const index = Number(row.data("index"));

    if (!changedCartItems[index]) {
        return;
    }

    changedCartItems.splice(index, 1);

    renderCurrentCartItems();
});

/* =========================================================
   상품 옵션 목록 가져오기
========================================================= */

function loadCartOptionSelects(productId) {

    const area = document.getElementById("changeOptionArea");

    if (!area) {
        return;
    }

    area.textContent = "옵션 정보를 불러오는 중입니다...";

    $("#optionModal")
        .addClass("active");

    fetch("/product/productDetail.htm?product_id=" + encodeURIComponent(productId))
        .then(function (response) {

            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }

            return response.text();
        })
        .then(function (html) {

            const parser = new DOMParser();

            const doc = parser.parseFromString(html, "text/html");

            const originalSelects = doc.querySelectorAll(".option-select");

            area.innerHTML = "";

            originalSelects.forEach(function (originalSelect) {

                const select = originalSelect.cloneNode(true);

                select.value = "";

                area.appendChild(select);
            });

            initChangeOptions();
        })
        .catch(function (error) {

            console.error("옵션 목록 가져오기 오류:", error);

            alert("상품 옵션 정보를 가져오지 못했습니다.");
        });
}

/* =========================================================
   SELECT 초기화
========================================================= */

function initChangeOptions() {

    const selects = Array.from(document.querySelectorAll("#changeOptionArea .option-select"));

    let firstRequired = true;

    selects.forEach(function (select) {

        if (select.dataset.required === "0") {

            select.disabled = false;

            return;
        }

        if (firstRequired) {

            select.disabled = false;

            firstRequired = false;

        } else {

            select.disabled = true;
        }
    });

    bindChangeOptionEvents();
}

/* =========================================================
   SELECT 이벤트
========================================================= */

function bindChangeOptionEvents() {

    $(document)
        .off("change.cartOption", "#changeOptionArea .option-select")
        .on("change.cartOption", "#changeOptionArea .option-select", function () {

            handleChangeOption(this);
        });
}

/* =========================================================
   SELECT 변경
========================================================= */

function handleChangeOption(currentSelect) {

    const selects = Array.from(document.querySelectorAll("#changeOptionArea .option-select"));

    const requiredSelects = selects.filter(function (select) {
        return (select.dataset.required === "1");
    });

    if (currentSelect.dataset.required === "1") {

        const currentIndex = requiredSelects.indexOf(currentSelect);

        if (currentSelect.value === "") {

            for (let i = currentIndex + 1; i < requiredSelects.length; i++) {

                requiredSelects[i].value = "";
                requiredSelects[i].disabled = true;
            }

            return;
        }

        const nextRequired = requiredSelects[currentIndex + 1];

        if (nextRequired) {
            nextRequired.disabled = false;
        }

        const allRequiredSelected = requiredSelects.every(function (select) {
            return select.value !== "";
        });

        if (!allRequiredSelected) {
            return;
        }


        findChangedRequiredProductOption();

        return;
    }

    if (currentSelect.dataset.required === "0") {

        if (currentSelect.value === "") {
            return;
        }

        findChangedAdditionalProductOption(currentSelect);
    }
}

/* =========================================================
   필수 옵션 조합 조회
========================================================= */

function findChangedRequiredProductOption() {

    if (!currentCartProduct) {
        return;
    }

    const productId = Number(currentCartProduct.dataset.productId);

    const requiredSelects = Array.from(document.querySelectorAll("#changeOptionArea .option-select")).filter(function (select) {
        return (select.dataset.required === "1");
    });

    const optionValueIds = requiredSelects.map(function (select) {
        return Number(select.value);
    });

    const optionNames = requiredSelects.map(function (select) {

        const groupName = select.dataset.groupName || select.dataset.group_name || "";

        const valueName = select.options[select.selectedIndex].text;

        return (groupName + ": " + valueName);
    });

    fetch("/product/productOption.htm?product_id=" + encodeURIComponent(productId) + "&option_value_ids=" + encodeURIComponent(optionValueIds.join(",")))
        .then(function (response) {

            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }

            return response.json();
        })
        .then(function (data) {

            if (!data) {
                alert("선택한 필수 옵션 조합이 없습니다.");
                return;
            }

            if (data.status && data.status !== "ACTIVE") {
                alert("판매할 수 없는 옵션입니다.");
                return;
            }

            if (data.stock !== undefined && Number(data.stock) <= 0) {
                alert("품절된 옵션입니다.");
                return;
            }

            const productOptionId = Number(data.product_option_id);

            const existing = changedCartItems.find(function (item) {
                return (Number(item.productOptionId) === productOptionId);
            });

            if (existing) {
                alert("이미 장바구니에 담긴 옵션입니다.");
                resetChangeRequiredOptions();
                return;
            }

            changedCartItems.push({

                cartItemsId: null,

                productOptionId: productOptionId,

                price: Number(data.price || 0),

                quantity: 1,

                sku: data.sku || "",

                optionName: optionNames.join(" / "),

                isAdditional: false,

                isNew: true
            });

            renderCurrentCartItems();

            resetChangeRequiredOptions();
        })
        .catch(function (error) {

            console.error("필수 옵션 조합 조회 오류:", error);

            alert("필수 옵션 정보를 가져오지 못했습니다.");
        });
}

/* =========================================================
   추가상품 단독 조회
========================================================= */

function findChangedAdditionalProductOption(select) {

    if (!currentCartProduct) {
        return;
    }

    const productId = Number(currentCartProduct.dataset.productId);

    const optionValueId = Number(select.value);

    fetch("/product/productOption.htm?product_id=" + encodeURIComponent(productId) + "&option_value_ids=" + encodeURIComponent(optionValueId))
        .then(function (response) {

            if (!response.ok) {
                throw new Error("HTTP " + response.status);
            }

            return response.json();
        })
        .then(function (data) {

            if (!data) {
                alert("선택한 추가상품을 찾을 수 없습니다.");
                return;
            }

            if (data.status && data.status !== "ACTIVE") {
                alert("판매할 수 없는 추가상품입니다.");
                return;
            }

            if (data.stock !== undefined && Number(data.stock) <= 0) {
                alert("품절된 추가상품입니다.");
                return;
            }

            const productOptionId = Number(data.product_option_id);

            const existing = changedCartItems.find(function (item) {
                return (Number(item.productOptionId) === productOptionId);
            });

            if (existing) {
                alert("이미 장바구니에 담긴 상품입니다.");
                return;
            }

            changedCartItems.push({

                cartItemsId: null,

                productOptionId: productOptionId,

                price: Number(data.price || 0),

                quantity: 1,

                sku: data.sku || "",

                optionName: getSelectOptionText(select),

                isAdditional: true,

                isNew: true
            });

            renderCurrentCartItems();

            select.value = "";
        })
        .catch(function (error) {

            console.error("추가상품 조회 오류:", error);

            alert("추가상품 정보를 가져오지 못했습니다.");
        });
}

/* =========================================================
   필수 옵션 SELECT 초기화
========================================================= */

function resetChangeRequiredOptions() {

    const requiredSelects = Array.from(document.querySelectorAll("#changeOptionArea .option-select")).filter(function (select) {
        return (select.dataset.required === "1");
    });

    requiredSelects.forEach(function (select, index) {

        select.value = "";

        if (index === 0) {
            select.disabled = false;
        } else {
            select.disabled = true;
        }
    });
}

/* =========================================================
   SELECT 옵션명
========================================================= */

function getSelectOptionText(select) {

    const selectedOption = select.options[select.selectedIndex];

    if (!selectedOption) {
        return "추가상품";
    }

    const groupName = select.dataset.groupName || select.dataset.group_name || "추가상품";

    return (groupName + ": " + selectedOption.text);
}

/* =========================================================
   옵션 변경 확인
========================================================= */

$("#optionChangeConfirm").on("click", async function () {

    if (!currentCartBrand) {
        return;
    }

    const requestData = {

        product_id: Number(currentCartProduct.dataset.productId),

        deleted_cart_items_ids: originalCartItemIds.filter(function (cartItemsId) {
            return !changedCartItems.some(function (item) {
                return (Number(item.cartItemsId) === Number(cartItemsId));
            });
        }),

        items: changedCartItems.map(function (item) {
            return {
                cart_items_id: item.cartItemsId,

                product_option_id: Number(item.productOptionId),

                quantity: Number(item.quantity),

                _new: item.isNew === true
            };
        })
    };

    console.log("모달 최종 저장 데이터:", JSON.stringify(requestData, null, 2));

    try {

        const response = await fetch("/cart/cartOptionEdit.htm", {
            method: "POST", headers: {
                "Content-Type": "application/json"
            }, body: JSON.stringify(requestData)
        });

        const responseText = await response.text();

        console.log("모달 CRUD 응답:", response.status, responseText);

        if (!response.ok) {
            throw new Error("모달 CRUD 실패");
        }

        closeOptionModal();

        location.reload();

    } catch (error) {

        console.error("옵션 변경 오류:", error);

        alert("변경사항 저장에 실패했습니다.");
    }
});

/* =========================================================
   모달 닫기
========================================================= */

$(document).on("click", "#optionModalClose", function () {

    closeOptionModal();
});

function closeOptionModal() {

    $("#optionModal")
        .removeClass("active");

    currentCartBrand = null;
    currentCartProduct = null;
    changedCartItems = [];

    $("#changeOptionArea")
        .empty();

    $("#changeOptionPreview")
        .empty()
        .hide();
}

/* =========================================================
   공통
========================================================= */

function escapeHtml(value) {

    return String(value)
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}
