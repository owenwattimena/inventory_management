var MainController = function(){
    return {
        init: function(){
            this.getHeader();
            this.getSidebar();
        }, 
        getHeader : function() {
            $.ajax({
                "url": globalPath + "/template/header",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    document.getElementById("header").innerHTML = data;
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        getSidebar : function() {
            $.ajax({
                "url": globalPath + "/template/sidebar",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    document.getElementById("sidebarMenu").innerHTML = data;
                    feather.replace({ 'aria-hidden': 'true' })
                    MainController.setSidebarLink();
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        setSidebarLink: function(){
            document.getElementById('dashboard-link').href = globalPath;
            document.getElementById('transaction-link').href = globalPath + "/transaction";
            document.getElementById('product-link').href = globalPath + "/product";
            document.getElementById('division-link').href = globalPath + "/division";
            document.getElementById('stock-plan-link').href = globalPath + "/inventory-planning";

            MainController.setActiveLink();
        },
        setActiveLink: function(){
            switch (onextConf.pathName()) {
                case "":
                    document.getElementById('dashboard-link').classList.add('active');
                    break;
                case "transaction":
                case "transaction-item":
                    document.getElementById('transaction-link').classList.add('active');
                    break;
                case "product":
                    document.getElementById('product-link').classList.add('active');
                    break;
                case "division":
                case "division-history":
                    document.getElementById('division-link').classList.add('active');
                    break;
                case "inventory-planning":
                    document.getElementById('stock-plan-link').classList.add('active');
                    break;
            
                default:
                    break;
            }(onextConf.pathName())
        }

    }
}();

MainController.init();