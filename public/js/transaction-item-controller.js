var TransactionItemController = function(){
    return {
        init: function(){
            const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);
    const month = urlParams.get('month');
    document.getElementById("monthEl").innerHTML = month;

    let thatMonth = month.split('-');

    let monthName = thatMonth[0];

    let date = new Date(monthName + "01, " + thatMonth[1] + " 00:00:00");

    let firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
    let lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);


    if (!Date.prototype.toISODate) {
        Date.prototype.toISODate = function() {
            return this.getFullYear() + '-' +
                ('0'+ (this.getMonth()+1)).slice(-2) + '-' +
                ('0'+ this.getDate()).slice(-2);
        }
    }

    firstDay = firstDay.toISODate();
    lastDay = lastDay.toISODate();


    $(document).ready(function () {
        let currency = Intl.NumberFormat('en-EN');

        $.ajax({
            "url": globalPath + "/api/product-statistic?start=" + firstDay + "&end=" + lastDay,
            "type": "POST",
            "data":JSON.stringify({}),
            "datatype": 'json',
            "success": function (data) {
                // console.log(data);
                var table = $("#table").DataTable({
                    dom: 'Bfrtip',
                    buttons: [
                        'print','excel', 
                    ],
                    data : data,
                    columns: [
                        { data: 'sku' },
                        { data: 'name' },
                        { data: 'total' },
                        { data: 'uom' },
                        { data: 'price' },
                        { data: 'price' }
                    ],
                        columnDefs: [
                    {
                        render: function (data, type, row) {
                            return currency.format(data);
                        },
                        targets: 2,
                    },
                    {
                        render: function (data, type, row) {
                            return currency.format(data);
                        },
                        targets: 4,
                    },
                    {
                        render: function (data, type, row) {
                            var total = row.total * row.price;
                            return currency.format(total);
                        },
                        targets: 5,
                    }
                    ],
                    pageLength: -1,
                    lengthMenu: [
                        [10, 25, 50, -1],
                        [10, 25, 50, "All"]
                    ],
                    drawCallback: function () {
                        var api = this.api();
                        // Remove the formatting to get integer data for summation
                        var intVal = function ( i ) {
                            return typeof i === 'string' ?
                                // (i.replace(/[\$,]/g, ''))*1 :
                                0:
                                typeof i === 'number' ?
                                    i : 0;
                        };
                        // Total over all pages
                        // var sum = api
                        //     .column( 5 )
                        //     .data()
                        //     .reduce( function (a, b) {
                        //         // console.log(`A : ${a}`)
                        //         // console.log(`B : ${intVal(b)}`)
                        //         return intVal(a) + intVal(b);
                        //     }, 0 );
                        var quantity = $('#table').DataTable().column(2).data();
                        var price = $('#table').DataTable().column(4).data();
                        let grandTotal = 0;
                        for(var i = 0; i<quantity.length; i++ ){
                            grandTotal = grandTotal + (quantity[i] * price[i]);
                        }
                        document.getElementById("grandTotal").innerHTML = "Rp " + currency.format(grandTotal);

                        // console.log(
                        //     grandTotal
                        // );
                    }
                });
                // console.log(table.column(6).data().sum());
            },
            "error": function (xhr, ajaxOptions, thrownError) {
                alert(xhr.status);
                console.log(xhr);
                console.log(thrownError);
            }
        });

        // $.ajax({
        //     "url": url + "/api/transaction/" + transId,
        //     "type": "GET",
        //     "datatype": 'json',
        //     "success": function (data) {
                
        //     }
        // });
      });

      function capitalizeFirstLetter(string) {
          return string.charAt(0).toUpperCase() + string.slice(1);
        }
        }, 
    }
}();
TransactionItemController.init();