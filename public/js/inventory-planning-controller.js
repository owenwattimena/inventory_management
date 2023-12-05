var DivisionController = function () {
    return {
        init: function () {
            var table = $("#table").DataTable({
                fixedColumns: {
                    heightMatch: 'none'
                },
                dom: 'Bfrtip',
                buttons: [
                    'print','excel', 
                ],
                pageLength: -1,
                columns: [
                    { data: 'sku' },
                    { data: 'name' },
                    { data: 'stock' },
                    { data: 'total_transaction' },
                    { data: 'planning_stock' },
                    { data: 'twenty_percent' },
                    { data: 'planning' },
                    { data: 'uom' },
                    { data: 'price' },
                ],
            });
            getCategory();

            document.getElementById('form').addEventListener('submit', function(event) {
                event.preventDefault(); 
                setOnLoading(true);

                let categoryEl = document.getElementById('categoryEl');
                let monthPlanningEl = document.getElementById('monthPlanningEl');

                let categoryValue = categoryEl.value;
                let monthPlanningValue = monthPlanningEl.value;
                getInventoryPlanning(categoryValue, monthPlanningValue);
            });

            function setOnLoading(status)
            {
                let btnPlnningEl = document.getElementById('btn-planning');
                btnPlnningEl.disabled = status;
                if(status)
                {
                    btnPlnningEl.textContent = "Analyzing... Please wait.";
                }else{
                    btnPlnningEl.textContent = "Planning";
                }
            }

            function setCategoryToEl(data) {
                let categoryEl = document.getElementById('categoryEl');

                for (let i = 0; i < data.length; i++) {
                // Get the value and text of each option
                    const newOption = document.createElement("option");
                    newOption.value = data[i]['category'];
                    newOption.textContent = data[i]['category'];
                    categoryEl.appendChild(newOption);
                }
            }

            function getCategory() {
                $.ajax({
                    "url": globalPath + "/api/category",
                    "type": "GET",
                    "datatype": 'json',
                    "success": function (data) {
                        setCategoryToEl(data);
                    },
                    "error": function (xhr, status, error) {
                        console.log("Error:", error); // Menampilkan pesan error di konsol
                        // Lakukan penanganan kesalahan sesuai kebutuhan Anda
                    }
                });
            }

            function setTableData(data)
            {
                table.clear().draw();
                table.rows.add(data).draw();
            }

            function getInventoryPlanning(category, monthPlaning)
            {
                // clearTableData();
                $.ajax({
                    "url": globalPath + "/api/inventory-planning?category=" + encodeURIComponent(category) + "&month_planning=" + monthPlaning,
                    "type": "GET",
                    "datatype": 'json',
                    "success": function (data) {
                        console.log(data)
                        setTableData(data)
                        setOnLoading(false);
                    },
                    "error": function (xhr, status, error) {
                        console.log("Error:", error); // Menampilkan pesan error di konsol
                        // Lakukan penanganan kesalahan sesuai kebutuhan Anda
                        setOnLoading(false);
                    }
                });
            }
        },
    }
}();

DivisionController.init();