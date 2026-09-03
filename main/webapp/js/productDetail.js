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
        const response = await fetch("/cartAdd.htm", {
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

        location.href = "/cart.htm";

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

        location.href = "/order.htm";

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