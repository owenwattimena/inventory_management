var TransactionController = function () {
    return {
        init: function () {
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

            let transactionItemLink = document.getElementById('transactionItemLink');
            let date = new Date();
            var month = date.getUTCMonth(); //months from 1-12
            var year = date.getUTCFullYear();
            transactionItemLink.setAttribute('href', globalPath + '/transaction-item?month=' + monthName[month] + "-" + year);
            let firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
            let lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);

            if (!Date.prototype.toISODate) {
                Date.prototype.toISODate = function () {
                    return this.getFullYear() + '-' +
                        ('0' + (this.getMonth() + 1)).slice(-2) + '-' +
                        ('0' + this.getDate()).slice(-2);
                }
            }

            firstDay = firstDay.toISODate();
            lastDay = lastDay.toISODate();

            let jsuitesCalendar = jSuites.calendar(document.getElementById("jsuites-calendar"), {
                type: "year-month-picker",
                format: "MMM-YYYY",
                value: date,
                onchange: function (instance, value) {
                    date = new Date(value);
                    if (date != 'Invalid Date') {
                        transactionItemLink.setAttribute('href', globalPath + '/transaction-item?month=' + monthName[date.getMonth()] + "-" + date.getFullYear());
                        firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
                        lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                        getOutTransaction(firstDay.toISODate(), lastDay.toISODate());
                        getEntryTransaction(firstDay.toISODate(), lastDay.toISODate());
                        getAuditTransaction(firstDay.toISODate(), lastDay.toISODate());
                    }
                }
            });

            let outTable = $("#outTable").DataTable({
                ajax: {
                    url: globalPath + "/api/transaction?type=out&start=" + firstDay + "&end=" + lastDay,
                    dataSrc: ''
                },
                "order": [[1, 'desc']],
                // data:data,
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
                    }
                ],
                pageLength: -1,
                lengthMenu: [
                    [10, 25, 50, -1],
                    [10, 25, 50, "All"]
                ]
            });

            function getOutTransaction(_firstDay, _lastDay) {

                $.ajax({
                    "url": globalPath + "/api/transaction?type=out&start=" + _firstDay + "&end=" + _lastDay,
                    "type": "GET",
                    "datatype": 'json',
                    "success": function (data) {
                        outTable.clear();
                        outTable.rows.add(data);
                        outTable.draw();
                    }
                });
            }

            let entryTable = $("#entryTable").DataTable({
                ajax: {
                    url: globalPath + "/api/transaction?type=entry&start=" + firstDay + "&end=" + lastDay,
                    dataSrc: ''
                },
                "order": [[1, 'desc']],
                columns: [
                    { data: 'created_at' },
                    { data: 'transaction_id' },
                    { data: 'distributor' }
                ],
                columnDefs: [
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
                    }
                ],
                pageLength: -1,
                lengthMenu: [
                    [10, 25, 50, -1],
                    [10, 25, 50, "All"]
                ]
            });
            function getEntryTransaction(_firstDay, _lastDay) {
                $.ajax({
                    "url": globalPath + "/api/transaction?type=entry&start=" + _firstDay + "&end=" + _lastDay,
                    "type": "GET",
                    "datatype": 'json',
                    "success": function (data) {
                        entryTable.clear();
                        entryTable.rows.add(data);
                        entryTable.draw();
                    }
                });
            }

            let auditTable = $("#auditTable").DataTable({
                ajax: {
                    url: globalPath + "/api/transaction?type=audit&start=" + firstDay + "&end=" + lastDay,
                    dataSrc: ''
                },
                "order": [[1, 'desc']],
                columns: [
                    { data: 'created_at' },
                    { data: 'transaction_id' },
                    { data: 'created_by' }
                ],
                columnDefs: [
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
                    }
                ],
                pageLength: -1,
                lengthMenu: [
                    [10, 25, 50, -1],
                    [10, 25, 50, "All"]
                ]
            });
            function getAuditTransaction(_firstDay, _lastDay) {
                $.ajax({
                    "url": globalPath + "/api/transaction?type=audit&start=" + _firstDay + "&end=" + _lastDay,
                    "type": "GET",
                    "datatype": 'json',
                    "success": function (data) {
                        auditTable.clear();
                        auditTable.rows.add(data);
                        auditTable.draw();
                    }
                });
            }
        },
    }
}();

TransactionController.init();