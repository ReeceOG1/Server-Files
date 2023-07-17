$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var i = event.data
        switch(i.action) {
            case 'playSound':
                const audio = new Audio("sounds/" + i.audioFile)
                audio.volume = 0.2;
                audio.play()                
            break;
        }
    })
});


