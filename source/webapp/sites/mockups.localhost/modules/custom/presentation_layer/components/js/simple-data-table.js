(function ($) {
    $(document).ready(function(){

        $('.export-link').click(function(event){

            var config = $(this).attr('config');
            var url = 'simple_data_table/export/'+config;

            $.ajax({
                url: url,
//                dataType: 'text/csv',
                success: function () {
                    window.location.assign(url);
                }
            });
            return false;

        });
    });
})(jQuery);