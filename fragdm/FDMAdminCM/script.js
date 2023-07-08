var selectedTicket = undefined;
var selectedTicketID = undefined;
$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var i = event.data
        switch(i.action) {
            case 'showStaff':
                $('.staff').show()
            break;
            case 'hideStaff':
                $('.staff').hide()
            break;
            case 'show':
                $('.calls').remove()
                $(".main-cont").show();
            break;
            case 'hide':
                $('.calls').remove()
                $('.main-cont').hide();
                if (selectedTicket) {
                    $(selectedTicket).css('outline', "none");
                    selectedTicket = undefined;
                    selectedTicketID = undefined;
                }
            break;
            case 'clear':
                $('.calls').remove()
            break;
            case 'update':
                $('.calls-cont').append(`<div class="calls" id="${i.ticketID}"><h2 class="${i.type}">${i.message} ${getTimeAgo(i.time)}</h2></div>`)
            break;
        }
        $('.calls').each(function() {
            $(this).click(function() {
                if (!selectedTicket) {
                    selectedTicket = this
                    selectedTicketID = $(selectedTicket).attr('id'),
                    $(selectedTicket).css('outline', "2px solid #e50105");
                } else {
                    $(selectedTicket).css('outline', "none");
                    selectedTicket = this
                    selectedTicketID = $(selectedTicket).attr('id'),
                    $(selectedTicket).css('outline', "2px solid #e50105");
                }
            })
        });
    });
    $('.accept').click(function() {
        if (selectedTicket !== undefined) {
            $.post(`https://${GetParentResourceName()}/FDM:TakeCall`, JSON.stringify({ticketID: selectedTicketID}));
            if (selectedTicket) {
                $(selectedTicket).css('outline', "none");
                selectedTicket = undefined;
                selectedTicketID = undefined;
            }
        }
    })
    $('.decline').click(function() {
        if (selectedTicket !== undefined) {
            $.post(`https://${GetParentResourceName()}/FDM:DC`, JSON.stringify({ticketID: selectedTicketID}));
            if (selectedTicket) {
                $(selectedTicket).css('outline', "none");
                selectedTicket = undefined;
                selectedTicketID = undefined;
            }
        }
    })
});


function getTimeAgo(time) {
    const date = new Date();
    const timestamp = date.getTime();
    const seconds = Math.floor(timestamp/1000);
    const difference = seconds - time;
    if (difference < 60) {
        return output = `few seconds ago`;
    } else if (difference < 3600) {
        return output = `${Math.floor(difference / 60)} minutes ago`;
    } else if (difference < 86400) {
        return output = `${Math.floor(difference / 3600)} hours ago`;
    } else if (difference < 2620800) {
        return output = `${Math.floor(difference / 86400)} days ago`;
     } else if (difference < 31449600) {
        return output = `${Math.floor(difference / 2620800)} months ago`;
    } else {
        return output = `${Math.floor(difference / 31449600)} years ago`;
    }
}