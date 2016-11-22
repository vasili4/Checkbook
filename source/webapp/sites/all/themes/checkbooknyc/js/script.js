(function ($) {


    $(document).ready(function () {

        $(".recommended-search__button, .recommended-search__close").click(function (e) {
            $(".recommended-search__button").toggleClass("active");
            $(".recommended-search").toggleClass("active");

            e.stopPropagation();
        });

        $(".domains-img, .domain-select-close").click(function (e) {
            $(".domain-select").toggleClass("active");
            $(".domains-img").toggleClass("active");
            $(".domain-select-overlay").toggleClass("active");

            e.stopPropagation();
        });

        $(".nav-dropdown").click(function (e) {
            $(this).toggleClass("active");
            $(".nav-domains").toggleClass("active");

            e.stopPropagation();
        });

        $(".chart-bar").click(function() {
            if (!$("#chart1").hasClass("active")) {
                $("#chart1, .chart-bar").addClass("active");
                $("#chart2, .chart-line").removeClass("active");
            }
        });

        $(".chart-line").click(function() {
            if (!$("#chart2").hasClass("active")) {
                $("#chart2, .chart-line").addClass("active");
                $("#chart1, .chart-bar").removeClass("active");
            }
        });

        //removes active class from all elements
        //hides modal elements on click on window
        //need to update to remove modal elements
        //on click on window outside of modal elements
        // $(window).click(function() {
        //   $('*').removeClass('active');
        // });


        var chart;
        var fiscalYear = ["2011", "2012", "2013", "2014", "2015", "2016", "2017"];
        var dollarFormat = function(d) {
            return '$' + d3.format(',.01f')(d) + "M";
        };
        //stacked bargraph////////////////////////////////////////////////////////////

        nv.addGraph(function() {
            chart = nv.models.multiBarChart()
                .duration(1000)
                .margin({
                    bottom: 100,
                    left: 70
                })
                .rotateLabels(0)
                .groupSpacing(0.1)
                .reduceXTicks(true)
                .staggerLabels(false)
                .stacked(true);
            chart.xAxis
                .showMaxMin(false)
                .tickValues([0, 1, 2, 3, 4, 5, 6])
                .tickFormat(function(d) {
                    return fiscalYear[d];
                });
            chart.yAxis
                .tickFormat(dollarFormat);
            chart.dispatch.on('renderEnd', function() {
                nv.log('Render Complete');
            });

            d3.select('#chart1 svg')
                .datum(mock)
                .call(chart);

            nv.utils.windowResize(chart.update);
            chart.dispatch.on('stateChange', function(e) {
                nv.log('New State:', JSON.stringify(e));
            });
            chart.state.dispatch.on('change', function(state) {
                nv.log('state', JSON.stringify(state));
            });
            return chart;
        });


        //line graph//////////////////////////////////////////////////////////////////
        nv.addGraph(function() {
            chart = nv.models.lineChart()
                .options({
                    duration: 1000,
                    useInteractiveGuideline: true
                })
                .height(450);
            // chart sub-models (ie. xAxis, yAxis, etc) when accessed directly, return themselves, not the parent chart, so need to chain separately
            chart.xAxis
                .tickValues([0, 1, 2, 3, 4, 5, 6])
                .tickFormat(function(d) {
                    return fiscalYear[d];
                });;
            chart.yAxis
                .tickFormat(dollarFormat);
            chart.
                data = sinAndCos();
            d3.select('#chart2 svg')
                .datum(mock)
                .call(chart);
            nv.utils.windowResize(chart.update);
            return chart;
        });

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
            return [{
                area: true,
                values: sin,
                key: "Sine Wave",
                color: "#ff7f0e",
                strokeWidth: 4,
                classed: 'dashed'
            }, {
                values: cos,
                key: "Cosine Wave",
                color: "#2ca02c"
            }, {
                values: rand,
                key: "Random Points",
                color: "#2222ff"
            }, {
                values: rand2,
                key: "Random Cosine",
                color: "#667711",
                strokeWidth: 3.5
            }, {
                area: true,
                values: sin2,
                key: "Fill opacity",
                color: "#EF9CFB",
                fillOpacity: .1
            }];
        }
    })

})(jQuery);

var mock = [
    {
        key: "Asian American",
        values: [
            {
                key: "Asian American",
                x: 0,
                y: 198.8
            },
            {
                key: "Asian American",
                series: 0,
                x: 1,
                y: 240.1
            },
            {
                key: "Asian American",
                series: 0,
                x: 2,
                y: 292.9
            },
            {
                key: "Asian American",
                series: 0,
                x: 3,
                y: 393.3
            },
            {
                key: "Asian American",
                series: 0,
                x: 4,
                y: 374.0
            },
            {
                key: "Asian American",
                series: 0,
                x: 5,
                y: 481.1
            },
            {
                key: "Asian American",
                series: 0,
                x: 6,
                y: 215.0
            }
        ]
    },
    {
        key: "Black American",
        values: [
            {
                key: "Black American",
                series: 0,
                x: 0,
                y: 32.3
            },
            {
                key: "Black American",
                series: 0,
                x: 1,
                y: 31.3
            },
            {
                key: "Black American",
                series: 0,
                x: 2,
                y: 31.9
            },
            {
                key: "Black American",
                series: 0,
                x: 3,
                y: 39.4
            },
            {
                key: "Black American",
                series: 0,
                x: 4,
                y: 41.7
            },
            {
                key: "Black American",
                series: 0,
                x: 5,
                y: 54.6
            },
            {
                key: "Black American",
                series: 0,
                x: 6,
                y: 21.2
            }
        ]
    },
    {
        key: "Hispanic American",
        values: [
            {
                key: "Hispanic American",
                series: 0,
                x: 0,
                y: 67.5
            },
            {
                key: "Hispanic American",
                series: 0,
                x: 1,
                y: 83.5
            },
            {
                key: "Hispanic American",
                series: 0,
                x: 2,
                y: 78.8
            },
            {
                key: "Hispanic American",
                series: 0,
                x: 3,
                y: 67.6
            },
            {
                key: "Hispanic American",
                series: 0,
                x: 4,
                y: 90.2
            },
            {
                key: "Hispanic American",
                series: 0,
                x: 5,
                y: 104.4
            },
            {
                key: "Hispanic American",
                series: 0,
                x: 6,
                y: 44.6
            }
        ]
    },
    {
        key: "Women",
        values: [
            {
                key: "Women",
                series: 0,
                x: 0,
                y: 165.2
            },
            {
                key: "Women",
                series: 0,
                x: 1,
                y: 168.2
            },
            {
                key: "Women",
                series: 0,
                x: 2,
                y: 158.4
            },
            {
                key: "Women",
                series: 0,
                x: 3,
                y: 217.2
            },
            {
                key: "Women",
                series: 0,
                x: 4,
                y: 245.4
            },
            {
                key: "Women",
                series: 0,
                x: 5,
                y: 306.9
            },
            {
                key: "Women",
                series: 0,
                x: 6,
                y: 139.4
            }
        ]
    }
];