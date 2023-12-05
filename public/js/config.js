var onextConf = function(){
	return {

		baseURL: function () {
			var getUrl = window.location,
				baseUrl = getUrl .protocol + "//" + getUrl.host;
			return baseUrl;
		},
        pathName:function(){
			var getUrl = window.location;
            return getUrl.pathname.split('/')[1];
        },
		basePathUrl: function () {
			var getUrl = window.location,
				baseUrl = getUrl .protocol + "//" + getUrl.host + "/" + getUrl.pathname.split('/')[1];
			return baseUrl;
		},
		numberFormat : function(x) {
			return x.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
		}
		// handleBaseURLX: function () {
		// 	var getUrl = window.location,
		// 		baseUrl = getUrl .protocol + "//" + getUrl.host + "/apps/RegOnline/";
		// 	return baseUrl;
		// }
	}
}();
//var globalWsPath = onextConf.handleBaseURL()+'/ws';
//var globalWsPath = onextConf.handleBaseURLX()+'api';
// var globalWsPath = onextConf.handleBaseURLX()+'/api';
// var globalReportPath = onextConf.handleBaseURL()+'/cetak';
// var globalPath = onextConf.handleBaseURL()+'/public/';
const globalPath = onextConf.baseURL();