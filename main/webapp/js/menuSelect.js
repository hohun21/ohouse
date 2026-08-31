$(function () {

    const currentPath = window.location.pathname;

    $("a[data-menu]").each(function () {

        const href = $(this).attr("href");

        if (!href || href === "#") {
            return;
        }

        const linkPath = new URL(this.href).pathname;

        if (linkPath === currentPath) {
            $(this).addClass("active");

            // 현재 페이지가 속한 상위 메뉴도 active
            const menu = $(this).data("menu");

            $(`.header-main-nav a[data-menu="${menu}"]`)
                .addClass("active");
        }

    });

});