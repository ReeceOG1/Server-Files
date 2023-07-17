const updateHudPosition = (Minimap) => {
	document.querySelector("#HUI").style.width = Minimap.width * window.innerWidth + "px";
	document.querySelector("#AUI").style.width = Minimap.width * window.innerWidth + "px";
	document.querySelector(".mapOutline").style.width = Minimap.width * window.innerWidth - 4 + "px";
	const xCalc = Minimap.right_x * window.innerWidth;
	document.querySelector(".playerPoints").style.left = xCalc + 15 + "px";
	document.querySelector("#playerKills").style.left = xCalc + 15 + "px";
}


window.addEventListener("load", () => {
	window.addEventListener("message", (e) => {
		switch (e.data.action) {
			case "updateResolution":
				updateHudPosition(e.data.position);
			break;
			case "updateHud":
				document.getElementById("health").style.width = `${e.data.health}%`;
				document.getElementById("shield").style.width = `${e.data.shield}%`;
				document.getElementById("Points").textContent = `${e.data.Points}`;
			break;
			case "loading" :
				document.getElementById("loadingWheel").style.display = 'block';
			break;
			case "hideKills":
				document.getElementById("playerKills").style.display = 'none';
			break;
			case "showKills":
				document.getElementById("playerKills").style.display = 'block';
			break;
			case "setKills" :
				document.getElementById("kills").textContent = `${e.data.kills}`;
			break;
			case "stop-loading" :
				document.getElementById("loadingWheel").style.display = 'none';
		}
	});
});