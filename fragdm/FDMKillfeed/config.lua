Config = {}

Config.showTime = 7500 -- How long a line should show in the kill feed? ( in milliseconds )
Config.maxKillLines = 8 -- Maximum number of lines the kill feed can show, after this number, new lines will force the previous ones to hide
Config.distanceUnit = "m" -- Distance Calculation Unit | "m" for meters // "ft" for feet
Config.ShowHideCommand = "killfeed" -- Command name for the player to show/hide the kill feed
Config.enableDemo = true -- Enables the test commands: /testkillfeed - /spawntestpeds - /customdeaths

-- Features Configuration --
Config.showDriveBy = true -- Whether or not to show the driveby icons
Config.showNoScope = true -- Show noscope icon when it's a No Scoped Kill
Config.showHeadshot = true -- Show Headshot icon when the kill is a headshot one
Config.showKillDist = true -- Whether to show kill distance or not ( only applicable to weapons that have the showDist set to true in Config.weapons )
Config.includeNPCs = true -- Whether to include deaths and kills involving NPCs
Config.includeAnimals = true -- Whether to include deaths and kills involving NPC Animals
Config.enableLog = true -- Whether to enable logging to discord webhook

-- NPCs Configuration --
Config.NPCText = true -- Adds a text before the NPC
Config.NPCTextLabel = "[Local] " -- The text to add before the NPC
Config.randomNPCNames = true -- Whether to use random names for NPCS ( e.g: Alfred, Sam, Mike ... ), if this is set to false, it will show the entity ID (e.g: 654768412)
Config.AnimalText = false -- -- Adds a text before the Animal NPC
Config.AnimalTextLabel = "[Animal] " -- The text to add before the NPC Animal

Config.weapons = { 
    [GetHashKey("WEAPON_MOSIN")] = { image = "WEAPON_MUSKET", HS = false },
    [GetHashKey("WEAPON_AK47")] = { image = "WEAPON_ASSAULTRIFLE", HS = false },
    [GetHashKey("WEAPON_AK74KASHNAR")] = { image = "WEAPON_ASSAULTRIFLE", HS = false },
    [GetHashKey("WEAPON_AK200")] = { image = "WEAPON_ASSAULTRIFLE", HS = false },
    [GetHashKey("WEAPON_WINCHESTER12")] = { image = "WEAPON_PUMPSHOTGUN", HS = false },
    [GetHashKey("WEAPON_M4A1")] = { image = "WEAPON_ASSAULTRIFLE", HS = false },
    [GetHashKey("WEAPON_SPAR16")] = { image = "WEAPON_ASSAULTRIFLE", HS = false },
    [GetHashKey("WEAPON_NERFMOSIN")] = { image = "WEAPON_MUSKET", HS = false },
    [GetHashKey("WEAPON_M1911")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_BLASTXPHANTOM")] = { image = "WEAPON_ASSAULTRIFLE", HS = false },
    [GetHashKey("WEAPON_TEC9")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_ROOK")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_UMP45")] = { image = "WEAPON_SMG", HS = false },
    [GetHashKey("WEAPON_CHERRYMOSIN")] = { image = "WEAPON_MUSKET", HS = false },
    [GetHashKey("WEAPON_VTSGLOW")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_M4A1WHITENOISE")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_M4A4FIRE")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_PISTOL")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_SPAR17")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_REMINGTON700")] = { image = "WEAPON_SNIPERRIFLE", HS = false },
    [GetHashKey("WEAPON_AKKAL")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_ACWR")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_MCX2")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_PDHK416")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_r5")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_G36")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_P416")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_ADVANCEDRIFLE")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_STAC")] = { image = "WEAPON_SNIPERRIFLE", HS = false },
    [GetHashKey("WEAPON_spaz")] = { image = "WEAPON_PUMPSHOTGUN", HS = false },
    [GetHashKey("WEAPON_CHAINSAW")] = { image = "WEAPON_KNIFE", HS = false },
    [GetHashKey("WEAPON_MINTYAXE")] = { image = "WEAPON_KNIFE", HS = false },
    [GetHashKey("WEAPON_MP40")] = { image = "WEAPON_SMG", HS = false },
    [GetHashKey("WEAPON_HONEYBADGER")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_PQ15")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_HKKZ")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_SIGMPX")] = { image = "WEAPON_SMG", HS = false },
    [GetHashKey("WEAPON_KILO")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_USP45")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_GOLDENDEAGLE2")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_MWR")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_BARRETM98")] = { image = "WEAPON_SNIPERRIFLE", HS = false },
    [GetHashKey("WEAPON_SCAR")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_L115A1")] = { image = "WEAPON_SNIPERRIFLE", HS = false },
    [GetHashKey("WEAPON_pp19")] = { image = "WEAPON_SMG", HS = false },
    [GetHashKey("WEAPON_pdw")] = { image = "WEAPON_SMG", HS = false },
    [GetHashKey("WEAPON_VSS")] = { image = "WEAPON_PISTOL", HS = false },
    [GetHashKey("WEAPON_M12")] = { image = "WEAPON_SMG", HS = false },
    [GetHashKey("WEAPON_RE6KZ")] = { image = "WEAPON_SNIPERRIFLE", HS = false },
    [GetHashKey("WEAPON_LVGUN")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_DARKMATTERVANDAL")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_ODIN")] = { image = "WEAPON_COMBATMG", HS = false },
    [GetHashKey("WEAPON_M249PLAYMAKER")] = { image = "WEAPON_COMBATMG", HS = false },
    [GetHashKey("WEAPON_DEVASTATORSSNIPER")] = { image = "WEAPON_SNIPERRIFLE", HS = false },
    [GetHashKey("WEAPON_AN94")] = { image = "WEAPON_CARBINERIFLE", HS = false },
    [GetHashKey("WEAPON_galilkz")] = { image = "WEAPON_CARBINERIFLE", HS = false },
}

Config.NPCNames = {
    human = {
        male = {
            "James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph", "Thomas", "Charles", "Christopher", "Daniel", "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven", 
            "Andrew", "Kenneth", "Joshua", "Kevin", "Brian", "George", "Edward", "Ronald", "Timothy", "Jason", "Jeffrey", "Ryan", "Jacob", "Gary", "Nicholas", "Eric", "Jonathan", "Stephen", 
            "Larry", "Justin", "Scott", "Brandon", "Benjamin", "Samuel", "Frank", "Gregory", "Raymond", "Alexander", "Patrick", "Jack", "Dennis", "Jerry", "Tyler", "Aaron", "Henry", "Adam", 
            "Douglas", "Nathan", "Peter", "Zachary", "Kyle","Walter", "Harold", "Jeremy", "Ethan", "Carl", "Keith", "Roger", "Gerald", "Christian", "Terry", "Sean", "Arthur", "Austin", "Noah", 
            "Lawrence", "Jesse", "Joe", "Bryan", "Billy","Jordan", "Albert", "Dylan", "Bruce", "Willie", "Gabriel", "Alan", "Juan", "Logan", "Wayne", "Ralph", "Roy", "Randy", "Vincent", 
            "Russell", "Louis", "Philip", "Bobby", "Johnny", "Bradley", "Leon", "Lucas"
        },
        female = {
            "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan", "Jessica", "Sarah", "Karen", "Nancy", "Lisa", "Margaret", "Betty", "Sandra", "Ashley", "Dorothy", "Kimberly", "Emily",
            "Donna", "Michelle", "Carol", "Amanda", "Melissa", "Deborah", "Stephanie", "Rebecca", "Laura", "Sharon", "Cynthia", "Kathleen", "Amy", "Shirley", "Angela", "Helen", "Anna", "Brenda", "Pamela", 
            "Nicole", "Samantha", "Katherine", "Emma", "Ruth", "Christine", "Catherine", "Debra", "Rachel", "Carolyn", "Janet", "Virginia", "Maria", "Heather", "Diane", "Julie", "Joyce", "Victoria", "Kelly", 
            "Christina", "Lauren", "Joan", "Evelyn", "Olivia", "Judith", "Megan", "Cheryl", "Martha", "Andrea", "Frances", "Hannah", "Jacqueline", "Ann", "Gloria", "Jean", "Kathryn", "Alice", "Teresa", "Sara", 
            "Janice", "Doris", "Madison", "Julia", "Grace", "Judy", "Abigail", "Marie", "Denise", "Beverly", "Amber", "Theresa", "Marilyn", "Danielle", "Diana", "Brittany", "Natalie", "Sophia", "Rose", 
            "Isabella", "Alexis", "Kayla", "Charlotte"
        }
    },
    animal = {
        cat = {
            "Luna", "Milo", "Oliver", "Leo", "Loki", "Bella", "Charlie", "Willow", "Lucy", "Simba",
            "Lily", "Nala", "Kitty", "Max", "Jack", "Ollie", "Jasper", "Chadwick", "Taylor", "Tom"
        },
        cormorant = {
            "Pterodactylus", "Greenie", "Chaffie", "Lolly", "Chiffy", "Goldie", "Shortie", "Buzzy", "Reggie", "Eider"
        },
        cow = {
            "Bessie", "Brownie", "Buttercup", "Clarabelle", "Dottie", "Guinness", "Magic", "Nellie", "Penelope", "Penny", 
            "Rosie", "Snowflake", "Sprinkles", "Sugar", "Annabelle", "Bella", "Betty", "Betsie", "Bossy", "Daisy"
        },
        coyote = {
            "Jerry", "Jamul", "Yoda", "Tembi", "Ivory", "Apollo", "Cunawabi", "Billy", "Bobby", "Emma",
            "Iris", "Onyx", "Buddy", "Tilly", "Rex", "Suri", "Tequila", "Tokyo", "Noah", "Nova"
        },
        crow = {
            "Jon Snow", "Ravenclaw", "Darth Vader", "Watchman", "Crow Foot", "Russel Crowe", "Marty McFly", "Tweety", "Chick Jagger", "Chandler Wing",
            "Flappers", "Cheep", "Wing Crosby", "Paulie", "Feather Fawcett", "Luna", "Flight", "Stephen", "Charlotte", "Ruppet"
        },
        dog = {
            "Luna", "Milo", "Oliver", "Bear", "Loki", "Bella", "Charlie", "Cooper", "Lucy", "Max",
            "Lily", "Nala", "Kitty", "Max", "Jack", "Ollie", "Jasper", "Jax", "Penny", "Winston"
        },
        deer = { 
            "Abie", "Bambi", "Beauty", "Blessed", "Bucky", "Buttercup", "Cainy", "Faith", "Freckles", "Gabriella", 
            "Goodeness", "Goodiva", "Goody", "Gracie", "Hope", "Hurricane", "Isabella", "Ivan", "Stormy", "Wendy"
        },
        dolphin = {
            "Star", "Chirp", "Clicker", "Fin", "Cuddly", "Happy", "Lazy", "Bubbles", "Kisser", "Jumper", 
            "Jumpy", "Trickster", "Hops", "Hopster", "Agape", "Flipper", "Snorky", "Alpha", "Beta", "Snowflake"
        },
        fish = {
            "Magikarp", "Sushi", "Nemo", "Delta", "Bait", "Neptune", "Atlantis", "Captain Jack", "Pacific", "Speedy",
            "Bob", "Fin", "Flounder", "Walleye", "Finn", "Oswald", "Ollie", "Flash", "Rex", "Salty"
        },
        hawk = {
            "Dudley", "Icarus", "Ristretto", "Maloney", "Chicory", "Timor", "Marlon", "Skyler", "Griffin", "Adelaide", 
            "Lucy", "Cob", "Molly", "Mischief", "Zippo", "Tasha", "Dusty", "Sal", "Lou", "Tattoo"
        },
        hen = {
            "Albert Eggstein", "Big Bird", "Big Red", "Peri-Peri", "Eggs Benny", "Marshmallow", "Fluffy", "Molly", "Miss Daisy", "Snowball",
            "Bradley Coop-er", "Hen Solo", "Cluck Vader", "Princess Lay-a", "Jaba", "Hilary Fluff", "Meggatron", "Fowler", "Beaker", "Henny Penny"
        },
        humpback = {
            "Alpha", "Gamma", "Gunther", "Bruce", "Sergeant", "Gatsby", "Orlando", "Razor", "Lord", "Draco",
            "Zero", "Ralph", "King", "Zoro", "Silver", "Dragon", "Indigo", "Carlos", "Jackson", "Thaddeus"
        },
        killerwhale = {
            "Luna", "Springer", "Tilikum", "Ikaiki", "Ulises", "Tahlequah", "Granny", "Keiko", "Old Tom", "Lolita", 
            "Moby Dhick", "Willy", "Namu", "Roxanne", "Tilly", "Winter", "Samson", "Iceberg", "Papa Whale", "Ariel"
        },
        mtlion = { 
            "King", "Slim", "Fluffy", "Pudge", "Blimpy", "Butterball", "Achilles", "Chunk", "Chubbles", "Big Foot", 
            "Giant", "Thumbelina", "Tundra", "Quarterback", "Chubby", "Fatma", "President", "Lord", "Fridge", "Speck"
        },
        panther = {
            "Darth", "Alfie", "Hunter", "Zara", "Salem", "Amy", "Halloween", "Phantom", "Annie", "Mr. Black", 
            "Maya", "Damian", "Andy", "Freda", "Dante", "Kuro", "Hades", "Inky", "Mystery", "Yuka"
        },
        pig = {
            "Ace", "Aero", "Alexander", "Amy Swinehouse", "Anastacia", "Apollo", "Arabella", "Archie", "Arlo", "Atlas",
            "Babe", "Bacon", "Bartholomew", "Bella", "Benjamina", "Bloedworst", "Boerewors", "Bratwurst", "Bristle", "Buddy"
        },
        pigeon = {
            "Fred", "Chirpie", "Candy", "Florence", "Polly", "Sunny", "Auzzie", "Chip", "Jazzy", "Jonas", 
            "Frankie", "Cherry", "Orlando", "Plato", "Odin", "Peachy", "Roxy", "Isabelle", "Wilbur", "Stella"
        },
        rabbit = {
            "Thumper", "Oreo", "Bun", "Bunn", "Coco", "Cocoa", "Daisy", "Bunny", "Cinnabun", "Snowball",
            "Buggs", "Marshmallow", "Midnight", "Thunderbunny", "Peppy Hare", "Oswald", "Jupiter", "Mars", "Neptune", "Artemis"
        },
        rat = {
            "Piper", "Reggie", "Flint", "Churro", "Wasabi", "Sushi", "Cheddar", "Benny", "Einstein", "Pascale", 
            "Hugs", "Scarlet", "Dove", "Bella", "Hazel", "Chutney", "Mina", "Autumn", "Pip", "Fawn"
        },
        rhesus = {
            "Chucky", "George", "Bing", "Charlie", "Congo", "Leo", "Cedric", "Bear", "Milo", "Monty", 
            "Jared", "Hunky", "Caesar", "Max", "Albert", "Steve", "Chester", "Hector", "Banana", "Bubbles"
        },
        seagull = {
            "Aqua", "Prickles", "Spring", "Jerry", "Munchkin", "Sue", "Gail", "Ivory", "Pickle", "Apricot", 
            "Sasha", "Cupcake", "Josh", "Maddie", "Peachy", "Quirky", "Katie", "Bill", "Vanilla", "Tiny", "Nimble"
        },
        shark = {
            "Fuzzy", "Sugar", "Hairless", "Greyskin", "Sandy", "Tommy", "Ashleigh", "Umber", "Lawrence", "Fishy", 
            "Hutch", "Werner", "Macy", "Peri", "Starsky", "Anakin", "Marge", "Cindy", "Jimbo", "Pamela"
        },
        stingray = {
            "Stripe", "Manta Ray", "Manta", "Batfish", "Ray", "Shark Ray", "Devilfish", "Sting Ray", "Parting",  "Parsnip", 
            "Whipray", "Skat", "Skate", "Ramp", "Stingaree", "Gail", "Spring", "Wasabi", "Sushi", "Flint"
        }
    }
}

Config.animalTypes = {
    [1462895032] = "cat", -- a_c_cat_01
    [1457690978] = "cormorant", -- a_c_cormorant
    [-50684386] = "cow", -- a_c_cow
    [1682622302] = "coyote", -- a_c_coyote
    [402729631] = "crow", -- a_c_crow
    [351016938] = "dog", -- a_c_chop
    [-1788665315] = "dog", -- a_c_rottweiler
    [1318032802] = "dog", -- a_c_husky
    [882848737] = "dog", -- a_c_retriever
    [1126154828] = "dog", -- a_c_shepherd
    [-1384627013] = "dog", -- a_c_westy
    [1125994524] = "dog", -- a_c_poodle
    [1832265812] = "dog", -- a_c_pug
    [-664053099] = "deer", -- a_c_deer
    [-1950698411] = "dolphin", -- a_c_dolphin
    [802685111] = "fish", -- a_c_fish
    [-1430839454] = "hawk", -- a_c_chickenhawk
    [1794449327] = "hen", -- a_c_hen
    [1193010354] = "humpback", -- a_c_humpback
    [-1920284487] = "killerwhale", -- a_c_killerwhale
    [307287994] = "mtlion", -- a_c_mtlion
    [-417505688] = "panther", -- a_c_panther
    [-832573324] = "pig", -- a_c_boar
    [-1323586730] = "pig", -- a_c_pig
    [111281960] = "pigeon", -- a_c_pigeon
    [-541762431] = "rabbit", -- a_c_rabbit_01
    [-1011537562] = "rat", -- a_c_rat
    [-1026527405] = "rhesus", -- a_c_rhesus
    [-745300483] = "seagull", -- a_c_seagull
    [1015224100] = "shark", -- a_c_sharkhammer
    [113504370] = "shark", -- a_c_sharktiger
    [-1589092019] = "stingray" -- a_c_stingray
}

Config.animalLabels = {
    ['cat'] = " the Cat",
    ['cormorant'] = " the Cormorant",
    ['cow'] = " the Cow",
    ['coyote'] = " the Coyote",
    ['crow'] = " the Crow",
    ['dog'] = " the Dog",
    ['deer'] = " the Deer",
    ['dolphin'] = " the Dolphin",
    ['fish'] = " the Fish",
    ['hawk'] = " the Hawk",
    ['hen'] = " the Hen",
    ['humpback'] = " the Humpback",
    ['killerwhale'] = " the Killerwhale",
    ['mtlion'] = " the Mountain Lion",
    ['panther'] = " the Panther",
    ['pig'] = " the Pig",
    ['pigeon'] = " the Pigeon",
    ['rabbit'] = " the Rabbit",
    ['rat'] = " the Rat",
    ['rhesus'] = " the Rhesus",
    ['seagull'] = " the Seagull",
    ['shark'] = " the Shark",
    ['stingray'] = " the Stingray"
}

-- Join Discord for Support: https://discord.gg/KxdPzC5EeJ