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
                        { data: 'category' }
                        ],
                        columnDefs: [
                        {
                            render: function (data, type, row) {
                                return "<a href='" + globalPath + "/product/" + data + "' >" + data + "</a>";
                            },
                            targets: 0,
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

ProductController.init();