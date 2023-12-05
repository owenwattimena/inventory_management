var DivisionController = function () {
    return {
        init: function () {
            function convertToSlug(Text) {
                return Text.toLowerCase()
                    .replace(/ /g, '-')
                    .replace(/[^\w-]+/g, '');
            }

            $.ajax({
                "url": globalPath + "/api/division",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    var no = 1;
                    $("#outTable").DataTable({
                        "order": [[ 0, 'asc' ]],
                        data:data,
                        columns: [
                        { data: null },
                        { data: 'division' },
                        ],
                        columnDefs: [
                            {
                                render: function (data, type, row) {
                                    return no++;
                                },
                                targets: 0,
                            },
                            {
                                render: function (data, type, row) {
                                    return '<a href="' + globalPath + '/division-history?division=' + btoa(data) + '">' + data + '</a>';
                                },
                                targets: 1,
                            }
                        ],
                        pageLength: 25,
                        lengthMenu: [
                        [10, 25, 50, -1],
                        [10, 25, 50, "All"]
                        ]
                    });
                }
            });
        },
    }
}();

DivisionController.init();