var MainController = function () {
    return {
        data: {
            element: {
                myModal: null
            }
        },
        init: function () {
            this.checkLock();
            this.getHeader();
            this.getSidebar();
        },
        isLoggedIn: function () {
            // Check if cookie exists
            const cookieValue = document.cookie.match(/loginExpiry=(.*)/);
            if (!cookieValue) {
                return false;
            }

            // Extract and parse expiry timestamp
            const expiryTimestamp = new Date(cookieValue[1]);

            // Check if expired (compare with current time)
            const now = new Date();
            return now < expiryTimestamp;
        },
        lock: function () {
            $.ajax({
                "url": globalPath + "/template/lock",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    var newElmt = document.createElement('div');
                    newElmt.innerHTML = data;
                    document.body.insertBefore(newElmt, document.body.firstChild);
                    // window.addEventListener('DOMContentLoaded', function() {
                    MainController.data.element.myModal = new bootstrap.Modal(document.getElementById('modal'));
                    MainController.data.element.myModal.show();
                    var submitPasscode = document.getElementById('passcodeSubmit');
                    submitPasscode.addEventListener('click', function (event) {
                        MainController.onPasscodeSubmit();
                    });
                    // });
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        checkLock: function () {
            $.ajax({
                "url": globalPath + "/api/passcode",
                "type": "GET",
                "datatype": 'json',
                "success": function (data) {
                    if (data == true) {
                        if(MainController.isLoggedIn()){
                            const expires = new Date(Date.now() + 30 * 1000);
                            document.cookie = `loginExpiry=${expires.toUTCString()}; path=/`;
                            return;
                        }
                        MainController.lock();
                    }
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        onPasscodeSubmit: function () {
            var inputPasscode = document.getElementById('inputPasscode');
            var passcode = inputPasscode.value;
            $.ajax({
                "url": globalPath + "/api/passcode",
                "type": "POST",
                "datatype": 'json',
                "data": JSON.stringify({ "passcode": passcode }),
                "success": function (data) {
                    if (data == true) {
                        MainController.data.element.myModal.hide();
                        const expires = new Date(Date.now() + 30 * 1000);
                        document.cookie = `loginExpiry=${expires.toUTCString()}; path=/`;
                    } else {
                        document.getElementById('errorText').innerText = 'Your passcode is incorrect';
                    }
                },
                "error": function (xhr, status, error) {
                    console.log("Error:", error); // Menampilkan pesan error di konsol
                }
            });
        },
        getHeader: function () {
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
        getSidebar: function () {
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
        setSidebarLink: function () {
            document.getElementById('dashboard-link').href = globalPath;
            document.getElementById('transaction-link').href = globalPath + "/transaction";
            document.getElementById('product-link').href = globalPath + "/product";
            document.getElementById('division-link').href = globalPath + "/division";
            document.getElementById('stock-plan-link').href = globalPath + "/inventory-planning";

            MainController.setActiveLink();
        },
        setActiveLink: function () {
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