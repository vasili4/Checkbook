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

        //removes active class from all elements
        //hides modal elements on click on window
        //need to update to remove modal elements
        //on click on window outside of modal elements
        $(window).click(function () {
            $('*').removeClass('active');
        });


        /////////////////////////////////////////////////////////////////////////////

        /* Inspired by Lee Byron's test data generator. */
        function stream_layers(n, m, o) {
            if (arguments.length < 3) o = 0;

            function bump(a) {
                var x = 1 / (.1 + Math.random()),
                    y = 2 * Math.random() - .5,
                    z = 10 / (.1 + Math.random());
                for (var i = 0; i < m; i++) {
                    var w = (i / m - y) * z;
                    a[i] += x * Math.exp(-w * w);
                }
            }

            return d3.range(n).map(function () {
                var a = [],
                    i;
                for (i = 0; i < m; i++) a[i] = o + o * Math.random();
                for (i = 0; i < 5; i++) bump(a);
                return a.map(stream_index);
            });
        }

        /* Another layer generator using gamma distributions. */
        function stream_waves(n, m) {
            return d3.range(n).map(function (i) {
                return d3.range(m).map(function (j) {
                    var x = 20 * j / m - i / 3;
                    return 2 * x * Math.exp(-.5 * x);
                }).map(stream_index);
            });
        }

        function stream_index(d, i) {
            return {
                x: i,
                y: Math.max(0, d)
            };
        }

        var test_data = stream_layers(4, 10 + Math.random() * 100, .1).map(function (data, i) {
            return {
                key: 'Stream' + i,
                values: data
            };
        });
        // console.log('td', test_data);
        var negative_test_data = new d3.range(0, 3).map(function (d, i) {
            return {
                key: 'Stream' + i,
                values: new d3.range(0, 2).map(function (f, j) {
                    return {
                        y: 2 + Math.random() * 10 * (Math.floor(Math.random() * 100) % 2 ? 1 : -1),
                        x: j
                    }
                })
            };
        });

/////////////////////////////////////////////////////////////////////////////

//stacked bargraph
        var chart;
        nv.addGraph(function () {
            chart = nv.models.multiBarChart()
                .barColor(d3.scale.category20().range())
                .duration(300)
                .margin({
                    bottom: 100,
                    left: 70
                })
                .rotateLabels(45)
                .groupSpacing(0.1);
            chart.reduceXTicks(false).staggerLabels(true);
            chart.xAxis
                .axisLabel("Fiscal Year")
                .axisLabelDistance(35)
                .showMaxMin(false)
                .tickFormat(d3.format(',.0f'));
            chart.yAxis
                .axisLabel("Amount ($00.0M)")
                .axisLabelDistance(-5)
                .tickFormat(d3.format(',.01f'));
            chart.dispatch.on('renderEnd', function () {
                nv.log('Render Complete');
            });
            d3.select('#chart1 svg')
                .datum(mock)
                .call(chart);
            console.log(test_data);
            // console.log(mwbedata);``

            nv.utils.windowResize(chart.update);
            chart.dispatch.on('stateChange', function (e) {
                nv.log('New State:', JSON.stringify(e));
            });
            chart.state.dispatch.on('change', function (state) {
                nv.log('state', JSON.stringify(state));
            });
            return chart;
        });


/////////////////////////////////////////////////////////////////////////////

// line graph
        var data;
        var randomizeFillOpacity = function () {
            var rand = Math.random(0, 1);
            for (var i = 0; i < 100; i++) { // modify sine amplitude
                data[4].values[i].y = Math.sin(i / (5 + rand)) * .4 * rand - .25;
            }
            data[4].fillOpacity = rand;
            chart.update();
        };
        nv.addGraph(function () {
            chart = nv.models.lineChart()
                .options({
                    duration: 300,
                    useInteractiveGuideline: true
                });
            // chart sub-models (ie. xAxis, yAxis, etc) when accessed directly, return themselves, not the parent chart, so need to chain separately
            chart.xAxis
                .axisLabel("Fiscal Year")
                .tickFormat(d3.format(',.1f'))
                .axisLabelDistance(10)
                .staggerLabels(true);
            chart.yAxis
                .axisLabel('Amount ($00.0M)')
                .tickFormat(function (d) {
                    if (d == null) {
                        return 'N/A';
                    }
                    return d3.format(',.2f')(d);
                });
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
            return [
                {
                    area: true,
                    values: sin,
                    key: "Sine Wave",
                    color: "#ff7f0e",
                    strokeWidth: 4,
                    classed: 'dashed'
                },
                {
                    values: cos,
                    key: "Cosine Wave",
                    color: "#2ca02c"
                },
                {
                    values: rand,
                    key: "Random Points",
                    color: "#2222ff"
                },
                {
                    values: rand2,
                    key: "Random Cosine",
                    color: "#667711",
                    strokeWidth: 3.5
                },
                {
                    area: true,
                    values: sin2,
                    key: "Fill opacity",
                    color: "#EF9CFB",
                    fillOpacity: .1
                }
            ];
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