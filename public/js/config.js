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
		},
		quote : [
			"Hal yang paling penting adalah menikmati hidupmu, menjadi bahagia, apapun yang terjadi.",
			"Hidup itu sederhana, kita yang membuatnya sulit.",
			"Hidup itu bukan soal menemukan diri Anda sendiri, hidup itu membuat diri Anda sendiri.",
			"Hidup adalah mimpi bagi mereka yang bijaksana, permainan bagi mereka yang bodoh, komedi bagi mereka yang kaya, dan tragedi bagi mereka yang miskin.",
			"Kenyataannya, ada tidak tahu apa yang akan terjadi besok. Hidup adalah pengendaraan yang gila dan tidak ada yang menjaminnya.",
			"Tujuan hidup kita adalah menjadi bahagia.",
			"Hidup yang baik adalah hidup yang diinspirasi oleh cinta dan dipandu oleh ilmu pengetahuan.",
			"Hidup adalah serangkaian perubahan yang alami dan spontan. Jangan tolak mereka karena itu hanya membuat penyesalan dan duka. Biarkan realita menjadi realita. Biarkan sesuatu mengalir dengan alami ke manapun mereka suka.",
			"Anda di sini hanya untuk persinggahan yang singkat. Jangan terburu, jangan khawatir. Yakinlah bahwa Anda menghirup wangi bunga sepanjang perjalanan.",
			"Hidup adalah cermin dan akan merefleksikan kembali kepada para pemikir mengenai apa yang mereka pikirkan.",
			"Saya memiliki filosofi yang sederhana: isi apa yang kosong, kosongkan apa yang terlalu penuh.",
			"Kehidupan adalah 10 persen apa yang terjadi pada Anda dan 90 persen adalah bagaimana Anda meresponnya",
			"Satu-satunya keterbatasan dalam hidup adalah perilaku yang buruk.",
			"Seseorang yang berani membuang satu jam waktunya tidak mengetahui nilai dari kehidupan.",
			"Apa yang kita pikirkan menentukan apa yang akan terjadi pada kita. Jadi jika kita ingin mengubah hidup kita, kita perlu sedikit mengubah pikiran kita.",
			"Ia yang mengerjakan lebih dari apa yang dibayar pada suatu saat akan dibayar lebih dari apa yang ia kerjakan",
			"Satu-satunya sumber pengetahuan adalah pengalaman",
			"Saya selalu mencoba untuk mengubah kemalangan menjadi kesempatan",
			"Perjalanan 1000 mil dimulai dengan satu langkah kaki",
			"Seseorang yang pernah melakukan kesalahan dan tidak pernah memperbaikinya berarti Ia telah melakukan satu kesalahan lagi.",
			"Beberapa orang memimpikan kesuksesannya, sementara yang lainnya bangun setiap pagi untuk mewujudkan mimpinya",
			"Tidak ada perjuangan yang dilakukan tanpa rasa sakit, namun Anda harus percaya bahwa rasa sakit itu hanya sesaat saja dan akan diganti dengan kebahagiaan",
			"Anda seringkali lupa terhadap apa saja yang sudah dimiliki, tetapi selalu mengingat apa yang dimiliki orang lain",
			"Anda tidak akan pernah belajar sabar dan berani jika di dunia ini hanya ada kebahagiaan",
			"Maafkanlah sikap Anda ketika mengalami kegagalan dalam meraih mimpi dan percayalah akan ada mimpi lain yang lebih besar dan lebih baik dari mimpi Anda yang sudah dirancang sebelumnya",
			"Masa depan adalah milik Anda yang telah menyiapkannya dari hari ini",
			"Sekecil apapun nominalnya, uang akan cukup jika digunakan untuk HIDUP. Namun, sebesar apapun nominalnya, uang tidak akan pernah cukup jika digunakan untuk memenuhi GAYA HIDUP",
			"Kesabaran adalah obat terbaik untuk segala kesulitan",
			"Kedewasaan tidak dilihat dari usia, tetapi dilihat dari sikap dan tingkah laku",
			"Percaya diri adalah rahasia nomor satu dari kesuksesan",
			"Jika kapal Anda tidak kunjung datang maka berenanglah",
			"Kemanapun Anda pergi, lakukanlah segalanya dengan segenap hati.",
			"Bertambahnya usia bukan berarti kita memahami segalanya",
			"Keraguan membunuh lebih banyak harapan daripada kegagalan",
			"Siapapun bisa jadi apapun!",
			"Kata-kata Anda menunjukkan kualitas diri Anda",
			"Hati memiliki nalarnya sendiri, tetapi nalar tidak memiliki hati",
			"Majulah tanpa menyingkirkan orang lain. Naiklah tanpa menjatuhkan orang lain",
			"Pamer adalah ide yang bodoh untuk sebuah kemenangan",
			"Jika hanya mencari kesempurnaan, maka Anda tidak akan pernah tenang",
			"Hanya Saya yang dapat mengubah hidup Saya, tidak ada orang lain yang bisa melakukannya untuk Saya",
			"Bersyukurlah atas semua hal yang dimiliki sekarang karena Anda tidak pernah tahu kapan akan kehilangannya",
			"Hidup itu bukan tentang memiliki dan mendapatkan, tetapi tentang memberi serta menjadi \"sesuatu\"",
			"Jangan takut jika Anda berjalan lambat, takutlah jika hanya berdiam",
			"Terkadang Anda diuji bukan untuk menunjukkan kelemahan yang dimiliki, tetapi diuji untuk menemukan kekuatan yang ada di dalam diri",
			"Kita sibuk mencari yang sempurna, sampai-sampai melewatkan yang siap menerima apa adanya",
			"Beri nilai dari usahanya, bukan dari hasilnya. Baru Anda bisa menilai kehidupan"
		]
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