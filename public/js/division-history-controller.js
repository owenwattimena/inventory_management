var DivisionHistoryController = function () {
    return {
        init: function () {
            const queryString = window.location.search;
            const urlParams = new URLSearchParams(queryString);
            const division = urlParams.get('division');

            let date = new Date();
            let firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
            let lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);

            let jsuitesCalendar = jSuites.calendar(document.getElementById("jsuites-calendar"), {
                type: "year-month-picker",
                format: "MMM-YYYY",
                value: date,
                onchange: function (instance, value) {
                    date = new Date(value);
                    if (date != 'Invalid Date') {
                        firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
                        lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                        getOutTransaction(firstDay, lastDay);
                        productStatistic(firstDay, lastDay, division)
                        // getEntryTransaction(firstDay, lastDay);
                    }
                }
            });

            var chart = new CanvasJS.Chart("chartContainer", {
                theme: "light2", // "light1", "light2", "dark1", "dark2"
                exportEnabled: true,
                animationEnabled: true,
                data: [
                    {
                        type: "pie",
                        startAngle: 25,
                        toolTipContent: "<b>{label}</b>: {y}%",
                        showInLegend: false,
                        legendText: "{label}",
                        indexLabelFontSize: 16,
                        indexLabel: "{label} - {y}%",
                        dataPoints: []
                    }
                ]
            });
            chart.render();
            let fullDivision = '';
            let outTable = $("#outTable").DataTable({
                "order": [[1, 'desc']],
                data: [],
                columns: [
                    { data: 'created_at' },
                    { data: 'transaction_id' },
                    { data: 'division' },
                    { data: 'take_in_by' }
                ],
                columnDefs: [
                    {
                        "targets": '_all',
                        "defaultContent": ""
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
                            return "<a href='" + globalPath + "/transaction/" + data + "' >" + data + "</a>";
                        },
                        targets: 1,
                    },
                    {
                        render: function (data, type, row) {
                            if (fullDivision == '') {
                                fullDivision = data;
                                document.getElementById('division').innerHTML = fullDivision;
                            }
                            return data;
                        },
                        targets: 2,
                    }
                ],
                pageLength: -1,
                lengthMenu: [
                    [10, 25, 50, -1],
                    [10, 25, 50, "All"]
                ]
            });
            getOutTransaction(firstDay, lastDay);
            productStatistic(firstDay, lastDay, division)


            function getOutTransaction(_firstDay, _lastDay) {
                // console.log(_lastDay.toLocaleDateString());
                if (!Date.prototype.toISODate) {
                    Date.prototype.toISODate = function () {
                        return this.getFullYear() + '-' +
                            ('0' + (this.getMonth() + 1)).slice(-2) + '-' +
                            ('0' + this.getDate()).slice(-2);
                    }
                }
                $.ajax({
                    "url": globalPath + "/api/division-history?type=out&start=" + _firstDay.toISODate() + "&end=" + _lastDay.toISODate(),
                    "type": "POST",
                    "data": JSON.stringify({ "division": division }),
                    "datatype": 'json',
                    "success": function (data) {
                        console.log("Data : " + data);
                        outTable.clear();
                        outTable.rows.add(data);
                        outTable.draw();
                    },
                    "error": function (xhr, status, error) {
                        console.log("Error:", error); // Menampilkan pesan error di konsol
                        // Lakukan penanganan kesalahan sesuai kebutuhan Anda
                    }
                });
            }

            let statTable = $("#statTable").DataTable({
                "order": [[0, 'desc']],
                data: [],
                columns: [
                    { data: 'total' },
                    { data: 'name' },
                    { data: 'category' }
                ],
                columnDefs: [
                    {
                        render: function (data, type, row, meta) {
                            return data;
                        },
                        targets: 0,
                    },
                    // {
                    //     render: function (data, type, row) {
                    //         return "<a href='" + url + "/transaction/" + data + "' >" + data + "</a>";
                    //     },
                    //     targets: 1,
                    // }
                ],
                pageLength: -1,
                lengthMenu: [
                    [10, 25, 50, -1],
                    [10, 25, 50, "All"]
                ]
            });


            productStatistic(firstDay, lastDay, division)


            function productStatistic(_firstDay, _lastDay, _division) {
                if (!Date.prototype.toISODate) {
                    Date.prototype.toISODate = function () {
                        return this.getFullYear() + '-' +
                            ('0' + (this.getMonth() + 1)).slice(-2) + '-' +
                            ('0' + this.getDate()).slice(-2);
                    }
                }
                $.ajax({
                    "url": globalPath + "/api/product-statistic?start=" + _firstDay.toISODate() + "&end=" + _lastDay.toISODate(),
                    "type": "POST",
                    "data": JSON.stringify({ "division": division }),
                    "datatype": 'json',
                    "success": function (data) {
                        console.log("Data");
                        console.log(data);
                        var _data = [];
                        var total = 0;
                        for (var i = 0; i < data.length; i++) {
                            total += data[i].total;
                        }
                        for (var i = 0; i < data.length; i++) {
                            _data.push({ y: data[i].total / total * 100, label: data[i].name });
                        }
                        chart.options.data[0].dataPoints = _data;
                        chart.render();

                        statTable.clear();
                        statTable.rows.add(data);
                        statTable.draw();
                    },
                    "error": function (xhr, status, error) {
                        console.log("Error:", error); // Menampilkan pesan error di konsol
                        // Lakukan penanganan kesalahan sesuai kebutuhan Anda
                    }
                });
            }
        }
    }
}();

DivisionHistoryController.init();