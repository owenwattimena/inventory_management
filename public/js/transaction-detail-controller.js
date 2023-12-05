var TransactionDetailController = function(){
    return {
        init: function(){
            let trans_id = document.getElementById("trans-id");
            let data = document.getElementById("data");
            let source = document.getElementById("source");
            let desc = document.getElementById("desc");
            let image = document.getElementById("image");

            let path = window.location.pathname;

      let arrPath = path.split('/');
      let transId = arrPath[arrPath.length - 1];
      let photo = "";

      $(document).ready(function () {

        $.ajax({
            "url": globalPath + "/api/transaction/" + transId + "?info=true",
            "type": "GET",
            "datatype": 'json',
            "success": function (data) {
                getPhoto(data.photo);
                trans_id.innerHTML = capitalizeFirstLetter(data.type) + " : " + transId;

                var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                var d = new Date(data.created_at)
                date.innerHTML = d.toLocaleDateString('id-ID', options);
                switch (data.type) {
                  case 'out':
                    source.innerHTML = data.division;
                    desc.innerHTML = data.take_in_by;
                    image.classList.remove("d-none");
                    break;
                  case 'entry':
                    source.innerHTML = data.distributor;
                    document.getElementById('table-card').classList.remove("col-md-8");
                    break;
                  case 'audit':
                    source.innerHTML = data.created_by;
                    document.getElementById('table-card').classList.remove("col-md-8");
                    break;
                  default:
                    console.log(`Wrong type`);
                }
            }
        });

        $.ajax({
            "url": globalPath + "/api/transaction/" + transId,
            "type": "GET",
            "datatype": 'json',
            "success": function (data) {
                $("#table").DataTable({
                  data : data,
                  columns: [
                    { data: 'sku' },
                    { data: 'name' },
                    { data: 'quantity' },
                    { data: 'uom' }
                    ],
                  pageLength: -1,
                  lengthMenu: [
                    [10, 25, 50, -1],
                    [10, 25, 50, "All"]
                  ]
                });
            }
        });
        function getPhoto(path)
        {
          $.ajax({
            "url" : globalPath + "/api/transaction/" + transId + "/image",
          "type" : "POST",
          "data":JSON.stringify({
            'photo_path' : path
          }),
          "dataType" : "json",
          "success" : function(data){
              var blob = "data:image/png;base64," + data;
              // console.log(blob);
              document.getElementById("photo").src = blob;
            },
            "error": function (xhr, ajaxOptions, thrownError) {
                console.log(xhr);
                console.log(thrownError);
            }
          });
        }
      });

      function capitalizeFirstLetter(string) {
          return string.charAt(0).toUpperCase() + string.slice(1);
        }
        }, 
    }
}();

TransactionDetailController.init();