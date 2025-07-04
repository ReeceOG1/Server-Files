var config = {
  'title': '',
  'welcomeMessage':'GMT British RP',
  // Add images for the loading screen background.
  images: [
    'https://gmtforums.com/images/fivem/bg1.jpg', 'https://gmtforums.com/images/fivem/bg2.jpg', 'https://gmtforums.com/images/fivem/bg3.jpg',
  ],

  /*enableMusic: false,
  // Music list. (Youtube video IDs). Last one should not have a comma at the end.
  music: [
    'vraG1S_SPAc', 'dBb060OPegg', 'VXUlwPSS-SQ', 'tgIqecROs5M'
  ],
  // Change music volume 0-100.
  musicVolume: 05,*/

  // Change Discord settings and link.
  'discord': {
    'show': true,
    'discordLink': 'https://discord.gg/gmt',
  },
  // Change which key you have set in guidehud/client/client.lua
  'menuHotkey': 'F1',
  // Turn on/off rule tabs. true/false
  'rules': {
    'gettingstarted':true,
    'generalrules': true,
    'fivemcharacterrules': true,
    'factionrules': true,
    'roleplay': true,
    'gangs': true,
    'zones': true,
    'thebansystem': true,
  },
}

// Home page annountments.
var announcements = [
	'Welcome to the #1 FiveM British Community.',
  'While we load you in, we advise that you grab a cup of tea, some biscuits and switch off.',
]

// Add/Modify rules below.
var gettingstarted = [
  'Welcome to GMT',
  'The world of GMT is pretty huge so it can be a little overwhelming at first! Here\'s a couple things you can do to get started and work you way up in the world:',
  '',
  '1. Make sure you take the tutorial, where you first spawn in you need to follow a yellow marker down into the underground that\'ll take you to the Job Centre and introduce the jobs you can take.',
  '',
  '2. Get a Job: A great starter job is Royal Mail Deliveries, Trucking or Bus Driving. To get started head to the Job Centre and select the job you wish to start. Next, open up your map and look for the Royal Mail/Bus/Trucking start point and drive there using your taxi that you recieved when doing the tutorial.',
  '',
  '3. Buy your first car at Simeons, look on the map if you don\'t know where Simeons Dealership is. Once you purchase the vehicle, you\'ll be able to take it out from any garage across the map free of charge.',
  '',
  '4. Try out the life of crime, there are many benefits the criminal life offers, you may start/join a gang(F5), rob people, rob shops, banks and even do illegal drug runs.',
  '',
  '5. As you progress through the server, you will need to buy licenses to access certain jobs & garages, see the License centre at the Job centre',
  '6. Try the many fun activies you can take part in the server! From skateboarding, paintball to parachuting!',
  '7. Go explore our world, create endless RP opportunities and create friendships that\'ll last forever :)',
]

// Modify hotkeys below.
var generalhotkeys = [
  'Press <kbd>T</kbd> then type to use Twitter.',
  'Press <kbd>T</kbd> then type <code>/ooc [msg]</code>to use OOC chat.',
  'Press <kbd>Page Up</kbd> to switch voice distance.',
  'Press <kbd>Home</kbd> to view player list.',
  'Press <kbd>L</kbd> to open your personal inventory.',
  'Press <kbd>E</kbd> while looking at a player to open the player menu.',
  'Press <kbd>F5</kbd> to open the GMT Gang Menu',
  'Press <kbd>F6</kbd> to view your licenses',
  'Press <kbd>F10</kbd> to view your warning log',
  'Press <kbd>INSERT</kbd> to use the livery menu.',
  'Use <code>/voteweather</code> to start a weather vote',
]

var rphotkeys = [
  'Use <code>/k</code> in to get on your knees',
  'Use <code>/carry</code> to carry someone',
  'Use <code>/piggyback</code> to piggyback someone',
  'Press <kbd>X</kbd> to put your hands up.',
  'Press <kbd>K</kbd> to bring up your phone.',
  'Press <kbd>F3</kbd> to bring up the animation menu.',
  'Press <kbd>B</kbd> to point.',
  'Use <code>/dance1-99</code> for 100 different dance emotes',
]

var vehiclehotkeys = [
  'Press <kbd>,</kbd> to lock/unlock your vehicle.',
  'Press <kbd>E</kbd> while looking at your vehicle to open your vehicle menu.',
  'Press <kbd>M</kbd> to open the vehicle control menu.',
  'Use <code>/flipcar</code> to flip an overturned vehicle.'
]

var characterhotkeys = [
  'Hold <kbd>SHIFT</kbd> to push a nearby broken vehicle',
  'Press <kbd>ALT</kbd>+<kbd>G</kbd> to knockout a player with your gun',
  'Press <kbd>ALT</kbd>+<kbd>W</kbd> to whistle and wave hand',
  'Press <kbd>ALT</kbd>+<kbd>B</kbd> to place a headbag on the nearest player',
  'Press <kbd>SHIFT</kbd>+<kbd>G</kbd> to tackle the nearest player (police)',
  'Press <kbd>ALT</kbd>+<kbd>F</kbd> to make the nearest player exit their vehicle (police)',
  'Press <kbd>ALT</kbd>+<kbd>D</kbd> to drag the nearest player in cuffs (police)',
  'Press <kbd>ALT</kbd>+<kbd>G</kbd> to pull the nearest player out their vehicle (police)',
]