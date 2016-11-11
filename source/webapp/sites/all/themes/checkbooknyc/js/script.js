(function ($) {
    $(document).ready(function () {

        $(".recommended-search__button, .recommended-search__close").click(function () {
            $(".recommended-search__button").toggleClass("active");
            $(".recommended-search").toggleClass("active");
        });

        $(".domains-img, .domain-select-close").click(function () {
            $(".domain-select").toggleClass("active");
            $(".domains-img").toggleClass("active");
            $(".domain-select-overlay").toggleClass("active");
        });

        $(".nav-dropdown").click(function () {
            $(this).toggleClass("active");
            $(".nav-domains").toggleClass("active");
        });
    });
})(jQuery);

