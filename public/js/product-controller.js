var ProductController = function(){
    return {
        init: function(){
            $.ajax({
                "url": globalPath + "/api/product",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    $("#outTable").DataTable({
                        "order": [[ 1, 'desc' ]],
                        data:data,
                        columns: [
                        { data: 'sku' },
                        { data: 'barcode' },
                        { data: 'name' },
                        { data: 'stock' },
                        { data: 'uom' },
                        { data: 'price' },
                        { data: 'price' },
                        { data: 'category' }
                        ],
                        columnDefs: [
                            {
                                render: function (data, type, row) {
                                    return "<a href='" + globalPath + "/product/" + data + "' >" + data + "</a>";
                                },
                                targets: 0,
                            },
                            {
                                render: function (data, type, row) {
                                    return (row.price).toLocaleString('id-ID');
                                },
                                targets: 5,
                            },
                            {
                                render: function (data, type, row) {
                                    return (row.stock * row.price).toLocaleString('id-ID');
                                },
                                targets: 6,
                            },
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

ProductController.init();