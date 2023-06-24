const audio = [
    { name: "headshot", file: "headshot.ogg", volume: 1.00 },
    { name: "bodyshot", file: "bodyshot.ogg", volume: 1.00 },
    { name: "zipper", file: "zipper.ogg", volume: 0.30 },
    { name: "herewegoagain", file: "herewegoagain.ogg", volume: 0.50 },
    { name: "newplayer", file: "newplayer.ogg", volume: 0.75 },
    { name: "license", file: "license.ogg", volume: 0.75 },
    { name: "newcar", file: "newcar.ogg", volume: 0.75 },
    { name: "newhouse", file: "newhouse.ogg", volume: 0.75 },
    { name: "repairready", file: "repairready.ogg", volume: 0.75 },
    { name: "purchaselicense", file: "purchaselicense.ogg", volume: 0.75 },
    { name: "plopsound", file: "plopsound.ogg", volume: 0.25 },
    { name: "apple", file: "apple.ogg", volume: 0.20 },
    { name: "handcuff", file: "handcuff.ogg", volume: 0.20 },
    { name: "money", file: "money.ogg", volume: 0.20 },
    { name: "dead", file: "dead.ogg", volume: 0.20 },
    { name: "casino_win", file: "casino_win.ogg", volume: 0.40 },
    { name: "casino_lose", file: "casino_lose.ogg", volume: 0.40 },
    { name: "iphone_ping", file: "iphone_ping.ogg", volume: 0.20 },
    { name: "hangup", file: "hangup.ogg", volume: 0.20 },
    { name: "ringtone", file: "ringtone.ogg", volume: 0.20 },
    { name: "radioon", file: "radioon.ogg", volume: 0.20 },
    { name: "radiooff", file: "radiooff.ogg", volume: 0.20 },
    { name: "purge", file: "purge.ogg", volume: 0.20 },
    { name: "gtaloadin", file: "gtaloadin.ogg", volume: 0.20 },
    { name: "drill", file: "drill.ogg", volume: 0.20 },
    { name: "alarm", file: "alarm.ogg", volume: 0.40 },
    { name: "starter", file: "NOVAStarter.ogg", volume: 0.40 },
    { name: "supplydrop", file: "supplydrop.ogg", volume: 0.05 },
    {name:"askShowMeQuestion", file:"askShowMeQuestion.ogg", volume: 0.50},
    {name:"closeCall", file:"closeCall.ogg", volume: 0.50},
    {name:"completePaperwork", file:"completePaperwork.ogg", volume: 0.50},
    {name:"controlledStop", file:"controlledStop.ogg", volume: 0.50},
    {name:"driveToTopFloor", file:"driveToTopFloor.ogg", volume: 0.50},
    {name:"emergencyStopIntroduction", file:"emergencyStopIntroduction.ogg", volume: 0.50},
    {name:"initialMoveOff", file:"initialMoveOff.ogg", volume: 0.50},
    {name:"leavingMotorwayTurningRight", file:"leavingMotorwayTurningRight.ogg", volume: 0.50},
    {name:"minorFaults", file:"minorFaults.ogg", volume: 0.50},
    {name:"motorwayExplained", file:"motorwayExplained.ogg", volume: 0.50},
    {name:"moveOffWhenReady", file:"moveOffWhenReady.ogg", volume: 0.50},
    {name:"newDestinationSet", file:"newDestinationSet.ogg", volume: 0.50},
    {name:"nowReversePark", file:"nowReversePark.ogg", volume: 0.50},
    {name:"operateHorn", file:"operateHorn.ogg", volume: 0.50},
    {name:"operateMainBeamHeadlights", file:"operateMainBeamHeadlights.ogg", volume: 0.50},
    {name:"parkUpAtWaypoint", file:"parkUpAtWaypoint.ogg", volume: 0.50},
    {name:"policePursuitContinue", file:"policePursuitContinue.ogg", volume: 0.50},
    {name:"reverseParkComplete", file:"reverseParkComplete.ogg", volume: 0.50},
    {name:"seriousFaults", file:"seriousFaults.ogg", volume: 0.50},
    {name:"slowDownOrTermination", file:"slowDownOrTermination.ogg", volume: 0.50},
    {name:"stopNowMessage", file:"stopNowMessage.ogg", volume: 0.50},
    {name:"stopSign", file:"stopSign.ogg", volume: 0.50},
    {name:"straightOver", file:"straightOver.ogg", volume: 0.50},
    {name:"textExplained", file:"textExplained.ogg", volume: 0.50},
    {name:"testFailed", file:"testFailed.ogg", volume: 0.50},
    {name:"testFailesGoodbye", file:"testFailesGoodbye.ogg", volume: 0.50},
    {name:"testPassed", file:"testPassed.ogg", volume: 0.50},
    {name:"testPassedGoodbye", file:"testPassedGoodbye.ogg", volume: 0.50},
    {name:"turningRightJunction", file:"turningRightJunction.ogg", volume: 0.50},
    {name:"welcome", file:"welcome.ogg", volume: 0.50},
    {name:"continueToFollow", file:"continueToFollow.ogg", volume: 0.50},
    {name:"testExplained", file:"testExplained.ogg", volume: 0.50},
    {name:"fan", file:"fan.ogg", volume: 0.20},
    {name:"spreader", file:"spreader.ogg", volume: 0.10},
    {name:"br-gas", file:"br-gas.ogg", volume: 0.3},
    {name:"whatawonderfulworld", file:"whatawonderfulworld.webm", volume: 0.3},
    {name:"fortnite_death", file:"fortnite_death.webm", volume: 0.3},
    {name:"roblox_death", file:"roblox_death.webm", volume: 0.3},
    {name:"minecraft_death", file:"minecraft_death.webm", volume: 0.3},
    {name:"pacman_death", file:"pacman_death.webm", volume: 0.3},
    {name:"mario_death", file:"mario_death.webm", volume: 0.3},
    {name:"csgo_death", file:"csgo_death.webm", volume: 0.3},
    {name:"MPCT_AKAA_01", file:"MPCT_AKAA_01.webm", volume: 0.3}, //Johnny on the spot!
    {name:"MPCT_AKAA_02", file:"MPCT_AKAA_02.webm", volume: 0.3},
    {name:"MPCT_AKAA_03", file:"MPCT_AKAA_03.webm", volume: 0.3},
    {name:"MPCT_AKAA_04", file:"MPCT_AKAA_04.webm", volume: 0.3},
    {name:"MPCT_AKAA_05", file:"MPCT_AKAA_05.webm", volume: 0.3},
    {name:"MPCT_ALAA_01", file:"MPCT_ALAA_01.webm", volume: 0.3}, //Cant bring car
    {name:"MPCT_ALAA_02", file:"MPCT_ALAA_02.webm", volume: 0.3},
    {name:"MPCT_ALAA_03", file:"MPCT_ALAA_03.webm", volume: 0.3},
    {name:"MPCT_ALAA_04", file:"MPCT_ALAA_04.webm", volume: 0.3},
    {name:"MPCT_ALAA_05", file:"MPCT_ALAA_05.webm", volume: 0.3},
    {name:"shave", file:"shave.webm", volume: 1.0},
]

var audioPlayer = null;
  
window.addEventListener('message', function (event) {
    if (findAudioToPlay(event.data.transactionType)) {
      let audio = findAudioToPlay(event.data.transactionType)
      if (audioPlayer != null) {
        audioPlayer.pause();
      }
      audioPlayer = new Audio("./sounds/" + audio.file);
      audioPlayer.volume = audio.volume;
      audioPlayer.play();
    }
});
  
function findAudioToPlay(name) {
    for (a of audio) {
      if (a.name == name) {
        return a
      }
    }
    return false
}