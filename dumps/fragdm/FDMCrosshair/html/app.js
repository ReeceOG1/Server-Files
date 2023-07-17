window.addEventListener("message", function(event) {
    var v = event.data
    switch (v.action) {
        case 'openMenu':
            $('.container').fadeIn(100)
        break;
        case 'Load': 
            $('.cuerpocontainer').append(`
                <div class="itemscontainer">
                <h1>${v.label}</h1>
                    <div class="alignImg">
                    <img class="${v.valor}-img" src="${v.imagenes}" alt="">
                    </div>
                    <div class="alignItems">
                    <a class="${v.valor}-click" href="#">Select Crosshair</a>
                    </div>
                </div>
            `)
            $(`.${v.valor}-click`).click(function(){
                if (v.label == "Default") {
                    $('.crosshair img').attr('src', '')
                    localStorage.setItem('FDMCrosshairImg', '')
                    CloseAll()
                } else {
                    var imagen = $(`.${v.valor}-img`)
                    var sourceimg = imagen[0].src
                    $('.crosshair img').attr('src', sourceimg)
                    localStorage.setItem('FDMCrosshairImg', sourceimg)
                    CloseAll()
                }
            })
        break;
    }
});


$(function(){
    $('.salir').click(function(){
        CloseAll()
    })
    $('.matar').click(function(){
        $('.crosshair img').attr('src', '')
        localStorage.setItem('FDMCrosshairImg', '')
        CloseAll()
    })
})


function CloseAll() {
    $('.container').fadeOut(100)
    $.post('https://FDMCrosshair/exit', JSON.stringify({}));
}

$(document).keyup((e) => {
    if (e.key === "Escape") {
        CloseAll()
    }
});

function LoadCrosshair() {
    var srcimgpe = localStorage.getItem('FDMCrosshairImg')
    $('.crosshair img').attr('src', srcimgpe || '')
}


window.addEventListener('load', () => {
    $.post('https://FDMCrosshair/loadData', JSON.stringify({}));
    LoadCrosshair()
});