var ProductDetailController = function () {
    return {
        init: function () {

            function formatDate(date) {
                var d = new Date(date),
                    month = '' + (d.getMonth() + 1),
                    day = '' + d.getDate(),
                    year = d.getFullYear();

                if (month.length < 2)
                    month = '0' + month;
                if (day.length < 2)
                    day = '0' + day;

                return [year, month, day].join('-');
            }

            let startDate = moment().startOf("month");
            let endDate = moment().endOf("month");

            let path = window.location.pathname;
            let arrPath = path.split('/');
            let sku = arrPath[arrPath.length - 1];
            let totalStock = 0;
            let uom = '';
            $.ajax({
                "url": globalPath + '/api/product/' + sku,
                "method": 'GET',
                "dataType": 'json',
                "success": function (data) {
                    data = data[0];
                    totalStock = data.stock;
                    uom = data.uom;
                    $('#product').text(data.sku + ' - ' + data.name);
                    $('#stock').text(data.stock + ' ' + data.uom);
                }
            });

            var monthName = new Array(
                "Jan",
                "Feb",
                "Mar",
                "Apr",
                "May",
                "Jun",
                "Jul",
                "Aug",
                "Sep",
                "Oct",
                "Nov",
                "Dec"
            );
            let labels = [];
            let dates = [];
            var d = new Date();
            d.setDate(1);
            for (i = 0; i < monthName.length; i++) {
                labels.push(monthName[d.getMonth()] + " " + d.getFullYear());
                var newDate = new Date();
                newDate.setDate(1);
                newDate.setMonth(d.getMonth());
                newDate.setFullYear(d.getFullYear());
                dates.push(newDate);
                d.setMonth(d.getMonth() - 1);
            }

            labels = labels.reverse();
            dates = dates.reverse();

            // CHART
            const data = {
                labels: labels,
                datasets: [
                    {
                        label: "OUT",
                        backgroundColor: "rgb(255, 99, 132)",
                        borderColor: "rgb(255, 99, 132)",
                        data: []
                    }
                ]
            };

            const config = {
                type: "line",
                data: data,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                }
            };
            const myChart = new Chart(document.getElementById("myChart"), config);
            let labelData = [];

            dates.forEach(date => {

                date = formatDate(date) + " 00:00:00";
                $.ajax({
                    "url": globalPath + '/api/product-chart/' + sku,
                    "method": 'POST',
                    "dataType": 'json',
                    "data": JSON.stringify({ "date": date }),
                    "success": function (data) {
                        labelData.push({
                            "date": date,
                            "data": data[0].quantity ?? 0
                        });
                    }
                });
            });

            const averageUsage = document.getElementById("average-usage");
            const estimated = document.getElementById("estimated");

            var totalData = 0;
            var countData = 0;
            var average = 0;
            var estimateMonth = 0;

            setTimeout(() => {
                labelData.sort(function (a, b) {
                    // Turn your strings into dates, and then subtract them
                    // to get a value that is either negative, positive, or zero.
                    return new Date(a.date) - new Date(b.date);
                });
                labelData.forEach(data => {
                    if (data.data > 0) {
                        totalData += data.data;
                        ++countData;
                    }
                    myChart.data.datasets[0].data.push(data.data);
                    myChart.update();
                });

                average = totalData / countData;
                estimateMonth = totalStock / average;
                estimateDay = estimateMonth * 30;
                var date = moment().add(estimateDay, 'days').format('MMMM YYYY');

                if (isNaN(average)) {
                    average = 0;
                    estimateMonth = 0;
                }

                averageUsage.innerHTML = average + " " + uom;
                estimated.innerHTML = Math.floor(estimateMonth) + " Months from Now (± " + date + ")";

            }, 3000);


            let table = $("#table").DataTable({
                ajax: {
                    url: globalPath + "/api/product-transaction/" + sku + "?start=" + startDate.format('YYYY-MM-DD hh:mm') + "&end=" + endDate.format('YYYY-MM-DD hh:mm'),
                    dataSrc: ''
                },
                columns: [
                    { data: 'created_at' },
                    { data: 'type' },
                    { data: 'transaction_id' },
                    { data: 'division' },
                    { data: 'take_in_by' },
                    { data: 'quantity' },
                    { data: 'stock' },
                ],
                columnDefs: [
                    {
                        render: function (data, type, row) {
                            switch (row.type) {
                                case "audit":
                                    return "Audit";
                                    break;
                                case "entry":
                                    return "Entry";
                                    break;

                                default:
                                    return data;
                                    break;
                            }
                        },
                        targets: 3,
                    },
                    {
                        render: function (data, type, row) {
                            return "<a href='" + globalPath + "/transaction/" + data + "'>" + data + "</a>";
                        },
                        targets: 2,
                    },
                    {
                        render: function (data, type, row) {
                            switch (row.type) {
                                case "audit":
                                    return row.created_by;
                                    break;
                                case "entry":
                                    return row.distributor;
                                    break;

                                default:
                                    return data;
                                    break;
                            }
                        },
                        targets: 4,
                    },
                    {
                        render: function (data, type, row) {
                            var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                            var d = new Date(data)
                            return d.toLocaleDateString('id-ID', options);
                        },
                        targets: 0,
                    },
                    {
                        render: function (data, type, row) {
                            switch (row.type) {
                                case "audit":
                                    return "<span class='badge bg-primary'>" + data + "</span>";
                                    break;
                                case "entry":
                                    return "<span class='badge bg-success'>" + data + "</span>";
                                    break;
                                default:
                                    return "<span class='badge bg-danger'>" + data + "</span>";
                                    break;
                            }

                        },
                        targets: 1,
                    },
                    {
                        render: function (data, type, row) {
                            switch (row.type) {
                                case "audit":
                                    // return row.last_stock;
                                    return row.last_stock;
                                    break;
                                case "entry":
                                    return "<span class='text-success'>" + data + "</span>";
                                    break;
                                default:
                                    return "<span class='text-danger'>" + data + "</span>";
                                    break;
                            }

                        },
                        targets: 5,
                    },
                    {
                        render: function (data, type, row) {
                            switch (row.type) {
                                case "audit":
                                    return "<span class='text-primary'>" + data + "</span>";
                                    break;
                                default:
                                    return data;
                                    break;
                            }

                        },
                        targets: 6,
                    },
                ],
                ordering: false,
                // "order": [[ 2, 'desc' ]],
                pageLength: -1,
                lengthMenu: [
                    [10, 25, 50, -1],
                    [10, 25, 50, "All"]
                ]
            });
            $('input[name="daterange"]').daterangepicker({
                startDate: startDate,
                endDate: endDate
            });
            $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
                $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'));
                getProductHistory(picker.startDate, picker.endDate);
            });

            function getProductHistory(start, end) {
                $.ajax({
                    "url": globalPath + "/api/product-transaction/" + sku + "?start=" + start.format('YYYY-MM-DD hh:mm') + "&end=" + end.format('YYYY-MM-DD hh:mm'),
                    "method": 'GET',
                    "dataType": 'json',
                    "success": function (data) {
                        table.clear();
                        table.rows.add(data);
                        table.draw();
                    }
                });
            }
        },
    }
}();

ProductDetailController.init();