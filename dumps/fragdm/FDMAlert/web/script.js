var isPointsDisplaying = false;
var currentPoints = false; 
$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var i = event.data
        switch(i.action) {
            case 'alert':
                addPoints(i.points)
                addAlert(i.reason, i.killed, i.id)
            break;
            case 'hideAlert':
                $("#" + i.num).fadeOut(250)
                .delay(250)
                $("#" + i.num).remove();
            break;
            case 'hidePoints':
                $(".points").fadeOut(250)
                isPointsDisplaying = false; 
                currentPoints = 0
            break;
        }
    });
});



function addPoints(points) {
    $(".points").fadeIn(0)
    if (isPointsDisplaying == true) {
        isPointsDisplaying = true;
        currentPoints = currentPoints + points;
        $("#pointsText").text("+" + currentPoints)
    } else {
        isPointsDisplaying = true;
        currentPoints = points;
        $("#pointsText").text("+" + points)
    }
}

function addAlert(reason, person, id) {
    if (reason == "killed") {
        $('.main-cont').append(`<div id=${id} class="Alert"><span>Killed</span><span id="green">${person}</span></div>`)
    } else {
        if (reason == "killedby") {
            $('.main-cont').append(`<div id=${id} class="Alert"><span>Killed by</span><span id="red">${person}</span></div>`)
        }
    }
}
