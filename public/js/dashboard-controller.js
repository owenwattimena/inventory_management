var DashboardController = function(){
    return {
        init: function(){
            DashboardController.setQuote();
            DashboardController.getTotalProduct();
            DashboardController.getTotalDivision();
            DashboardController.getInventoryValue();
        }, 
        getTotalProduct: function(){
            $.ajax({
                "url": globalPath + "/api/product-total",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    DashboardController.setTotalProduct(data.total);
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        getTotalDivision: function(){
            $.ajax({
                "url": globalPath + "/api/division-total",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    DashboardController.setTotalDivision(data.total);
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        getInventoryValue: function(){
            $.ajax({
                "url": globalPath + "/api/inventory-value",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    DashboardController.setInventoryValue(data.total);
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        setTotalProduct : function(value){
            document.getElementById('total-product').textContent = value;
        },
        setTotalDivision : function(value){
            document.getElementById('total-division').textContent = value;
        },
        setInventoryValue : function(value){
            document.getElementById('inventory-value').textContent = value.toLocaleString('id-ID');
        },
        setQuote: function()
        {
            document.getElementById('quote').textContent = onextConf.quote[Math.floor(Math.random() * (onextConf.quote.length - 0 + 1)) + 0];
        }

    }
}();

DashboardController.init();