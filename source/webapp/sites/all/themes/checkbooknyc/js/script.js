(function ($) {


    $(document).ready(function () {
        $('.recommended-search__button, .recommended-search__close').click(function (e) {
            $('.recommended-search__button').toggleClass('active');
            $('.recommended-search').toggleClass('active');

            $('html').one('click', function () {
                $('*').removeClass('active');
            });

            e.stopPropagation();
        });

        $('.domains-img, .domain-select-close').click(function (e) {
            $('.domain-select').toggleClass('active');
            $('.domains-img').toggleClass('active');
            $('.domain-select-overlay').toggleClass('active');

            $('html').one('click', function () {
                $('*').removeClass('active');
            });

            e.stopPropagation();
        });

        //adds hover state for domains dropdown in header navigation
        $('.nav-dropdown.domain-select-nav').hover(function () {
            $(this).addClass('active');
            $('.nav-domains').addClass('active');
            if ($(this).hasClass('active')) {
                $('.nav-dropdown').not(this).removeClass('active');
                $('.nav-submenu').not('.nav-submenu.nav-domains').removeClass('active');
            }
        });

        //removes active class when hovering over new dropdown option
        $('.nav-domains').hover(function () {
            if ($('.nav-domains').hasClass('active')) {
                return;
            }
        }, function () {
            $('.nav-domains').removeClass('active');
            $('.nav-dropdown.domain-select-nav').removeClass('active');
        });

        //adds hover state for trends in header navigation
        $('.nav-dropdown.trends-select').hover(function () {
            $(this).addClass('active');
            $('.nav-trends').addClass('active');

            if ($(this).hasClass('active')) {
                $('.nav-dropdown').not(this).removeClass('active');
                $('.nav-submenu').not('.nav-submenu.nav-trends').removeClass('active');
            }
        });

        //removes active class when hovering over new dropdown option
        $('.nav-trends').hover(function () {
            if ($('.nav-trends').hasClass('active')) {
                return;
            }
        }, function () {
            $('.nav-trends').removeClass('active');
            $('.nav-dropdown.trends-select').removeClass('active');
        });

        //adds hover state for search tools in header navigation
        $('.nav-dropdown.search-tools-select').hover(function () {
            $(this).addClass('active');
            $('.nav-search-tools').addClass('active');

            if ($(this).hasClass('active')) {
                $('.nav-dropdown').not(this).removeClass('active');
                $('.nav-submenu').not('.nav-submenu.nav-search-tools').removeClass('active');
            }
        });

        //removes active class when hovering over new dropdown option
        $('.nav-search-tools').hover(function () {
            if ($('.nav-search-tools').hasClass('active')) {
                return;
            }
        }, function () {
            $('.nav-search-tools').removeClass('active');
            $('.nav-dropdown.search-tools-select').removeClass('active');
        });

        //adds hover state for help in header navigation
        $('.nav-dropdown.help-select').hover(function () {
            $(this).addClass('active');
            $('.nav-help').addClass('active');

            if ($(this).hasClass('active')) {
                $('.nav-dropdown').not(this).removeClass('active');
                $('.nav-submenu').not('.nav-submenu.nav-help').removeClass('active');
            }
        });

        $('.nav-bonds, .nav-home').hover(function() {
            $('.nav-submenu').removeClass('active');
            $('.nav-dropdown').removeClass('active');
        })

        //removes active class when hovering over new dropdown option
        $('.nav-help').hover(function () {
            if ($('.nav-help').hasClass('active')) {
                return;
            }
        }, function () {
            $('.nav-help').removeClass('active');
            $('.nav-dropdown.help-select').removeClass('active');
        });

        $('.chart-bar').click(function () {
            if (!$('#chart1').hasClass('active')) {
                $('#chart1').addClass('active');
            }
            $('.chart-bar').addClass('active');
            $('#chart2, .chart-line, .chart-bar-stacked').removeClass('active');
            toggleBarChart('Grouped');
        });

        $('.chart-bar-stacked').click(function () {
            if (!$('#chart1').hasClass('active')) {
                $('#chart1').addClass('active');
            }
            $('.chart-bar-stacked').addClass('active');
            $('#chart2, .chart-line, .chart-bar').removeClass('active');
            toggleBarChart('Stacked');
        });

        $('.chart-line').click(function () {
            if (!$('#chart2').hasClass('active')) {
                $('#chart2, .chart-line').addClass('active');
                $('#chart1, .chart-bar, .chart-bar-stacked').removeClass('active');
            }
        });

        function toggleBarChart(toggle) {
            switch (toggle) {
                case 'Grouped':
                    chart.stacked(false);
                    break;
                case 'Stacked':
                    chart.stacked(true);
                    break;
            }
            d3.select('#chart1 svg')
                .datum(chartData)
                .call(chart);
            d3.select('#chart1 .nv-legendWrap').attr('transform', 'translate(-430, 420)');
            nv.utils.windowResize(chart.update);
        }

        $('.mwbe-filter-button').click(function (e) {
            if ($('.mwbe-filter').hasClass('active')) {
                $('.mwbe-filter, .mwbe-filter-button').removeClass('active');
            } else {
                $('.mwbe-filter, .mwbe-filter-button').addClass('active');
            }


            e.stopPropagation();
        });

        //By default close the toggle
        $(".charts-data-table-container").slideToggle("ease-in-out");
        $(".charts-data-tables-toggle").toggleClass("close");
        $(".map-data-table-container").slideToggle("ease-in-out");
        $(".map-data-tables-toggle").toggleClass("close");

        //toggle the chart data table
        $(".charts-data-tables-toggle").click(function () {
            $(".charts-data-table-container").slideToggle("ease-in-out");
            $(".charts-data-tables-toggle").toggleClass("close");
            return false;
        });
        //toggle the map data table
        $(".map-data-tables-toggle").click(function () {
            $(".map-data-table-container").slideToggle("ease-in-out");
            $(".map-data-tables-toggle").toggleClass("close");
            return false;
        });


        $(window).scroll(function () {
            if ($(this).scrollTop() >= 200) {
                $('#return-to-top').fadeIn(200);
            } else {
                $('#return-to-top').fadeOut(0);
            }
        });
        $('#return-to-top').click(function () {
            $('body,html').animate({
                scrollTop: 0
            }, 500);
        });

        $('.mwbe-filter > div').click(function() {
          var $this = $(this);
          $('.mwbe-filter-button').text($this.html()).removeClass('active');
          $('.mwbe-filter').removeClass('active');
        })

        var chart,char2;
        var fiscalYear = ['2011', '2012', '2013', '2014', '2015', '2016', '2017'];
        var dollarFormat = function (d) {
            return '$' + d3.format(',.2f')(d) + 'M';
        }

        /* Load Chart Data */
        var chartData;
        var url = 'mwbe_spending_summary_chart_data/mwbe_spending_landing/mwbeSpendingByYears';

        $.ajax({
            url: url,
            success: function (result) {
                chartData = JSON.parse(result);
                CreateGraph();
            }
        });

        function CreateGraph() {

            /* Bar graph */
            nv.addGraph(function () {
                chart = nv.models.multiBarChart()
                    .duration(1000)
                    .margin({
                        bottom: 100,
                        left: 70
                    })
                    .rotateLabels(0)
                    .groupSpacing(0.5)
                    .reduceXTicks(true)
                    .staggerLabels(false)
                    .stacked(true)
                    .showControls(false);
                chart.xAxis
                    .showMaxMin(false)
                    .tickValues([0, 1, 2, 3, 4, 5, 6])
                    .tickFormat(function (d) {
                        return fiscalYear[d];
                    });
                chart.yAxis
                    .tickFormat(dollarFormat);
                chart.dispatch.on('renderEnd', function () {
                    nv.log('Render Complete');
                });

                d3.select('#chart1 svg')
                    .datum(chartData)
                    .call(chart);

                nv.utils.windowResize(chart.update);
                d3.select('#chart1 .nv-legendWrap').attr('transform', 'translate(-430, 420)');
                chart.dispatch.on('stateChange', function (e) {
                    nv.log('New State:', JSON.stringify(e));
                });
                chart.state.dispatch.on('change', function (state) {
                    nv.log('state', JSON.stringify(state));
                });
                return chart;
            });

            /* Line graph */
            nv.addGraph(function () {
                chart2 = nv.models.lineChart()
                    .options({
                        duration: 350,
                        useInteractiveGuideline: true
                    })
                    .height(450);
                // chart sub-models (ie. xAxis, yAxis, etc) when accessed directly, return themselves, not the parent chart, so need to chain separately
                chart2.xAxis
                    .tickValues([0, 1, 2, 3, 4, 5, 6])
                    .tickFormat(function (d) {
                        return fiscalYear[d];
                    });
                chart2.yAxis
                    .tickFormat(dollarFormat);
                chart2.interactiveLayer.tooltip.fixedTop(150);
                data = sinAndCos();
                d3.select('#chart2 svg')
                    .datum(chartData)
                    .call(chart2);
                nv.utils.windowResize(chart2.update);
                return chart2;
            });
        }

        function sinAndCos() {
            var sin = [],
                sin2 = [],
                cos = [],
                rand = [],
                rand2 = [];
            for (var i = 0; i < 100; i++) {
                sin.push({
                    x: i,
                    y: i % 10 == 5 ? null : Math.sin(i / 10)
                }); //the nulls are to show how defined works
                sin2.push({
                    x: i,
                    y: Math.sin(i / 5) * 0.4 - 0.25
                });
                cos.push({
                    x: i,
                    y: .5 * Math.cos(i / 10)
                });
                rand.push({
                    x: i,
                    y: Math.random() / 10
                });
                rand2.push({
                    x: i,
                    y: Math.cos(i / 10) + Math.random() / 10
                })
            }
            return [
                {
                    area: true,
                    values: sin,
                    key: 'Sine Wave',
                    color: '#ff7f0e',
                    strokeWidth: 4,
                    classed: 'dashed'
                },
                {
                    values: cos,
                    key: 'Cosine Wave',
                    color: '#2ca02c'
                },
                {
                    values: rand,
                    key: 'Random Points',
                    color: '#2222ff'
                },
                {
                    values: rand2,
                    key: 'Random Cosine',
                    color: '#667711',
                    strokeWidth: 3.5
                },
                {
                    area: true,
                    values: sin2,
                    key: 'Fill opacity',
                    color: '#EF9CFB',
                    fillOpacity: .1
                }
            ];
        }

    });

})(jQuery);
