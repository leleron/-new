function setTab(name, cursel, n){
	for(i=1; i<=n; i++){
		//var menu = document.getElementById(name + i);
		//menu.className = (i === cursel ? "current" : ""); 	
		var con = document.getElementById("con_" + name + "_" + i);
		con.style.display = (i === cursel ? "block" : "none");
	}
}
