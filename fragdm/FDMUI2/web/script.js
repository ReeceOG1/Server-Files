$(document).ready(function(){
    window.addEventListener('message', function(event) {
        var i = event.data
        switch(i.action) {
            case 'showWeaponUI':
                $(".WeaponUI-Cont").fadeIn(500)
            break;
            case 'hideWeaponUI':
                $(".WeaponUI-Cont").fadeOut(500)
            break;
            case 'hideUI':
                $(".interactionUI").fadeOut(500)
            break;
            case 'showUI':
                $(".interactionUI").fadeIn(500)
            break;
            case 'updateWeaponUI':
                $("#clip").text(i.clipAmmo)
                $(".weaponAmmo").text("/ " + i.weaponAmmo)
                $("#GunModel").text("/ / " + i.weaponName)
            break;
            case 'updateWeaponIMG':
                $('#WeaponIMG').attr('src', i.image);
            break;
            case 'showKillLeaders':
                $('.killleaders').fadeIn(500)
                $("#first").text(i.first)
                $("#second").text(i.second)
                $("#third").text(i.third)
                $("#firstKills").text(i.firstKills)
                $("#secondKills").text(i.secondKills)
                $("#thirdKills").text(i.thirdKills)
            break;
            case 'HideKillLeaders':
                $('.killleaders').fadeOut(500)
            break;
        }
    });
});

