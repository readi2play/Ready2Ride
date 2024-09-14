local AddonName, b2h = ...
--------------------------------------------------------------------------------
-- DEFAULT SETTINGS
--------------------------------------------------------------------------------
R2R.defaults = {
  anchoring = {
    frame = "Minimap",
    button_anchor = "TOPLEFT",
    parent_anchor = "TOPRIGHT",
    position_x = -64  ,
    position_y = 10,
    button_size = 42,
    button_strata = "PARENT",
  },
  bindings = {
    indoors = 2645,
    swimming = 420,
  },
  continents = {
    ["407"] = { -- Darkmoon Island
      hasZones = false,
      useZones = false,
      mountID = 1792,
    },
    ["12"] = { -- Kalimdor
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Ashenvale
        ["63"] = { mountID = nil },
        -- Azshara
        ["76"] = { mountID = nil },
        -- Azuremyst Isle
        ["97"] = { mountID = nil },
        -- Bloodmyst Isle
        ["106"] = { mountID = nil },
        -- Darkshore
        ["62"] = { mountID = nil },
        -- Darnassus
        ["89"] = { mountID = nil },
        -- Desolace
        ["66"] = { mountID = nil },
        -- Durotar
        ["1"] = { mountID = nil },
        -- Dustwallow Marsh
        ["70"] = { mountID = nil },
        -- Echo Isles
        ["463"] = { mountID = nil },
        -- Felwood
        ["77"] = { mountID = nil },
        -- Feralas
        ["69"] = { mountID = nil },
        -- Moonglade
        ["80"] = { mountID = nil },
        -- Mount Hyjal
        ["198"] = { mountID = nil },
        -- Mulgore
        ["7"] = { mountID = nil },
        -- Northern Barrens
        ["10"] = { mountID = nil },
        -- Orgrimmar
        ["85"] = { mountID = nil },
        -- Orgrimmar Cleft of Shadow
        ["86"] = { mountID = nil },
        -- Silithus
        ["81"] = { mountID = nil },
        -- Southern Barrens
        ["199"] = { mountID = nil },
        -- Stonetalon Mountains
        ["65"] = { mountID = nil },
        -- Tanaris
        ["71"] = { mountID = nil },
        -- Teldrassil
        ["57"] = { mountID = nil },
        -- The Exodar
        ["103"] = { mountID = nil },
        -- Thunder Bluff
        ["88"] = { mountID = nil },
        -- Thousand Needles
        ["64"] = { mountID = nil },
        -- Uldum
        ["249"] = { mountID = nil },
        -- Un'Goro Crater
        ["78"] = { mountID = nil },
        -- Winterspring
        ["83"] = { mountID = nil },
      }
    },
    ["13"] = { -- Eastern Kingdoms
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Abyssal Depths
        ["204"] = { mountID = nil },
        -- Arathi Highlands
        ["14"] = { mountID = nil },
        -- Badlands
        ["15"] = { mountID = nil },
        -- Blackrock Mountain
        ["33"] = { mountID = nil },
        -- Blasted Lands
        ["17"] = { mountID = nil },
        -- Burning Steppes
        ["36"] = { mountID = nil },
        -- Cape of Strangethorn
        ["210"] = { mountID = nil },
        -- Deadwind Pass
        ["42"] = { mountID = nil },
        -- Deeprun Tram
        ["499"] = { mountID = nil },
        -- Dun Morogh
        ["29"] = { mountID = nil },
        -- Duskwood
        ["47"] = { mountID = nil },
        -- Eastern Plaguelands
        ["23"] = { mountID = nil },
        -- Elwynn Forest
        ["37"] = { mountID = nil },
        -- Eversong Woods
        ["94"] = { mountID = nil },
        -- Ghostlands
        ["95"] = { mountID = nil },
        -- Hillsbrad Foothills
        ["25"] = { mountID = nil },
        -- Ironforge
        ["87"] = { mountID = nil },
        -- Isle of Quel'Danas
        ["122"] = { mountID = nil },
        -- Kelp'thar Forest
        ["201"] = { mountID = nil },
        -- Loch Modan
        ["48"] = { mountID = nil },
        -- Northern Stranglethorn
        ["50"] = { mountID = nil },
        -- Redridge Mountains
        ["49"] = { mountID = nil },
        -- Ruins of Gilneas
        ["217"] = { mountID = nil },
        -- Searing Gorge
        ["32"] = { mountID = nil },
        -- Shimmering Expanse
        ["205"] = { mountID = nil },
        -- Silvermoon City
        ["110"] = { mountID = nil },
        -- Silverpine Forest
        ["21"] = { mountID = nil },
        -- Stormwind City
        ["84"] = { mountID = nil },
        -- Swamp of Sorrows
        ["51"] = { mountID = nil },
        -- The Hinterlands
        ["26"] = { mountID = nil },
        -- Tirisfal Glades
        ["18"] = { mountID = nil },
        -- Tol Barad
        ["245"] = { mountID = nil },
        -- Twilight Highlands
        ["241"] = { mountID = nil },
        -- Undercity
        ["90"] = { mountID = nil },
        -- Vashj"ir: Kelp'thar Forest
        ["201"] = { mountID = nil },
        -- Vashj"ir: Shimmering Expanse
        ["205"] = { mountID = nil },
        -- Vashj"ir: Abyssal Depths
        ["204"] = { mountID = nil },
        -- Western Plaguelands
        ["22"] = { mountID = nil },
        -- Westfall
        ["52"] = { mountID = nil },
        -- Wetlands
        ["56"] = { mountID = nil },
      }
    },
    ["101"] = { -- Outland
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Blades Edge Mountains
        ["105"] = { mountID = nil },
        -- Hellfire Penninsula
        ["100"] = { mountID = nil },
        -- Nagrand
        ["107"] = { mountID = nil },
        -- Netherstorm
        ["109"] = { mountID = nil },
        -- Shadowmoon Valley
        ["104"] = { mountID = nil },
        -- Terrokkar Forest
        ["108"] = { mountID = nil },
        -- Zangermarsh
        ["102"] = { mountID = nil },
        -- Shattrath
        ["111"] = { mountID = nil },
      }
    },
    ["113"] = { -- Northrend
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Borean Tundra
        ["114"] = { mountID = nil},
        -- Crystalsong Forest
        ["127"] = { mountID = nil},
        -- Dalaran
        ["125"] = { mountID = nil},
        -- Dalaran Underbelly
        ["126"] = { mountID = nil},
        -- Dragonblight
        ["115"] = { mountID = nil},
        -- Grizzly Hills
        ["116"] = { mountID = nil},
        -- Howling Fjord
        ["117"] = { mountID = nil},
        -- Icecrown
        ["118"] = { mountID = nil},
        -- Sholazar Basin
        ["119"] = { mountID = nil},
        -- The Storm Peaks
        ["120"] = { mountID = nil},
        -- Wintergrasp
        ["123"] = { mountID = nil},
        -- Zul' Drak
        ["121"] = { mountID = nil},
      }
    },
    ["947"] = { -- Azeroth (Cataclysm)
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Maelstrom
        ["948"] = { mountID = nil },
        -- Deepholm
        ["207"] = { mountID = nil },
      }
    },
    ["424"] = { -- Pandaria
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Dread Wastes
        ["422"] = { mountID = nil },
        -- Isle of Thunder
        ["504"] = { mountID = nil },
        -- Karasarang Wilds
        ["418"] = { mountID = nil },
        -- Kun-Lai Summit
        ["379"] = { mountID = nil },
        -- Shrine of the Seven Stars
        ["390"] = { mountID = nil },
        -- Shrine of Two Moons
        ["392"] = { mountID = nil },
        -- The Jade Forest
        ["371"] = { mountID = nil },
        -- The Veiled Stair
        ["433"] = { mountID = nil },
        -- Timeless Isle
        ["554"] = { mountID = nil },
        -- Townlong Steppes
        ["388"] = { mountID = nil },
        -- Vale of Eternal Blossoms
        ["390"] = { mountID = nil },
        -- Valley of the Four Winds
        ["376"] = { mountID = nil },
      }
    },
    ["572"] = { -- Draenor
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Ashran
        ["588"] = { mountID = nil},
        -- Frostfire Ridge
        ["525"] = { mountID = nil},
        -- Gorgrond
        ["543"] = { mountID = nil},
        -- Nagrand
        ["550"] = { mountID = nil},
        -- Shadowmoon Valley
        ["539"] = { mountID = nil},
        -- Spires of Arak
        ["542"] = { mountID = nil},
        -- Talador
        ["535"] = { mountID = nil},
        -- Tanaan Jungle
        ["534"] = { mountID = nil},
        -- Warspear
        ["624"] = { mountID = nil},
        -- Garrison
        ["590"] = { mountID = nil},
      }
    },
    ["619"] = { -- The Broken Isles
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Azsuna
        ["630"] = { mountID = nil },
        -- Dalaran
        ["627"] = { mountID = nil },
        -- Dalaran Underbelly
        ["628"] = { mountID = nil },
        -- Eye of Azshara
        ["790"] = { mountID = nil },
        -- Helheim
        ["649"] = { mountID = nil },
        -- Highmountain
        ["650"] = { mountID = nil },
        -- Stormheim
        ["634"] = { mountID = nil },
        -- Suramar
        ["680"] = { mountID = nil },
        -- The Broken Shore
        ["646"] = { mountID = nil },
        -- Thundertotem (indoors)
        ["652"] = { mountID = nil },
        -- Thundertotem (outdoors)
        ["750"] = { mountID = nil },
        -- Val'sharah
        ["641"] = { mountID = nil },
        -- Val'sharah Dreamgrove
        ["747"] = { mountID = nil },
        -- Val'sharah Emerald Dreamway
        ["715"] = { mountID = nil },
      }
    },
    ["905"] = { -- Argus
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Argus: Antoran Wastes
        ["885"] = { mountID = nil },
        -- Argus: Eredath
        ["882"] = { mountID = nil },
        -- Argus: Krokuun
        ["830"] = { mountID = nil },
        -- Argus: The Vindicaar
        ["831"] = { mountID = nil },
      }
    },
    ["875"] = { -- Zandalar
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Dazaralor
        ["1165"] = { mountID = nil },
        -- Dazaralor The Great Seal
        ["1163"] = { mountID = nil },
        -- Nazmir
        ["863"] = { mountID = nil },
        -- Vol'dun
        ["864"] = { mountID = nil },
        -- Zuldazar
        ["862"] = { mountID = nil },
      }
    },
    ["876"] = { -- Kul-Tiras
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Boralus
        ["1161"] = { mountID = nil },
        -- Drustvar
        ["896"] = { mountID = nil },
        -- Stormsong Valley
        ["942"] = { mountID = nil },
        -- Tiragarde Sound
        ["895"] = { mountID = nil },
      }
    },
    ["1355"] = { -- Nazjatar
      hasZones = false,
      useZones = false,
      mountID = 1792,
    },
    ["1462"] = { -- Mechagon
      hasZones = false,
      useZones = false,
      mountID = 1792,
    },
    ["1550"] = { -- Shadowlands
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Ardenweald
        ["1565"] = { mountID = nil },
        -- Bastion
        ["1533"] = { mountID = nil },
        -- Maldraxxus
        ["1536"] = { mountID = nil },
        -- Revendreth
        ["1525"] = { mountID = nil },
        -- Oribos main quest floor
        ["1670"] = { mountID = nil },
        -- Oribos FP & Portals level
        ["1671"] = { mountID = nil },
        -- Korthia
        ["1961"] = { mountID = nil },
        -- The Maw
        ["1543"] = { mountID = nil },
        -- Zereth Mortis
        ["1970"] = { mountID = nil },
      }
    },
    ["1978"] = { -- Dragon Isles
      hasZones = true,
      useZones = true,
      mountID = 1589,
      zones = {
        -- The Waking Shores
        ["2022"] = { mountID = 1589 },
        -- Ohn'ahra Plains
        ["2023"] = { mountID = 1590 },
        -- Azure Span
        ["2024"] = { mountID = 1563 },
        -- Thaldraszus
        ["2025"] = { mountID = 1591 },
        -- Valdrakken
        ["2112"] = { mountID = 1591 },
        -- Forbidden Reach
        ["2151"] = { mountID = 1589 },
        -- Zaralek Cavern
        ["2133"] = { mountID = 1589 },
        -- Emerald Dream
        ["2200"] = { mountID = 1589 },
      }
    },
    ["2274"] = { -- Khaz Algar
      hasZones = true,
      useZones = true,
      mountID = 1792,
      zones = {
         -- Dornogal
        ["2339"] = { mountID = nil },
         -- Isle of Dorn
        ["2248"] = { mountID = nil },
         -- The Ringing Deeps
        ["2214"] = { mountID = 2144 },
         -- Hallowfall
        ["2215"] = { mountID = 1051 },
         -- Azj-Kahet
        ["2255"] = { mountID = 2181 },
         -- City of Threads Umbral Bazaar
        ["2213"] = { mountID = 2181 },
      }
    }
  }
}