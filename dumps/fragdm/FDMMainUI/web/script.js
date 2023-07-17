var Page = null;
$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var i = event.data
        switch(i.action) {
            case 'open':
				Page = "Home";
                $('#main-cont').show()
				$("#data").text(`${i.data}`)
            break;
            case 'hide':
				Page = null;
                $('#main-cont').fadeOut(500)
            break;
        }
    });
    $('#deathmatch').click(function() {
		$.post(`https://${GetParentResourceName()}/FDM:MainMenu`, JSON.stringify({action: "deathmatch"}));
    })
    $('#Quit').click(function() {
		$.post(`https://${GetParentResourceName()}/FDM:MainMenu`, JSON.stringify({action: "quit"}));
    })
    $('#settings').click(function() {
		if (Page !== "Settings") {
			Page = "Settings"
            $.post(`https://${GetParentResourceName()}/FDM:MainMenu`, JSON.stringify({action: "settings"}));
		}
    })
});

