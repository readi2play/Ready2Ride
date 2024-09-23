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
    indoors = "",
    swimming = {
      mount = 420,
      ability = ""
    },
  },
  continents = {
    { -- Darkmoon Island
      zoneID = 407,
      hasZones = false,
      useZones = false,
      mountID = 1792,
    },
    { -- Kalimdor
      zoneID = 12,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Ashenvale
        {
          zoneID = 63,
          mountID = ""
        },
        -- Azshara
        {
          zoneID = 76,
          mountID = ""
        },
        -- Azuremyst Isle
        {
          zoneID = 97,
          mountID = ""
        },
        -- Bloodmyst Isle
        {
          zoneID = 106,
          mountID = ""
        },
        -- Darkshore
        {
          zoneID = 62,
          mountID = ""
        },
        -- Darnassus
        {
          zoneID = 89,
          mountID = ""
        },
        -- Desolace
        {
          zoneID = 66,
          mountID = ""
        },
        -- Durotar
        {
          zoneID = 1,
          mountID = ""
        },
        -- Dustwallow Marsh
        {
          zoneID = 70,
          mountID = ""
        },
        -- Echo Isles
        {
          zoneID = 463,
          mountID = ""
        },
        -- Felwood
        {
          zoneID = 77,
          mountID = ""
        },
        -- Feralas
        {
          zoneID = 69,
          mountID = ""
        },
        -- Moonglade
        {
          zoneID = 80,
          mountID = ""
        },
        -- Mount Hyjal
        {
          zoneID = 198,
          mountID = ""
        },
        -- Mulgore
        {
          zoneID = 7,
          mountID = ""
        },
        -- Northern Barrens
        {
          zoneID = 10,
          mountID = ""
        },
        -- Orgrimmar
        {
          zoneID = 85,
          mountID = ""
        },
        -- Orgrimmar Cleft of Shadow
        {
          zoneID = 86,
          mountID = ""
        },
        -- Silithus
        {
          zoneID = 81,
          mountID = ""
        },
        -- Southern Barrens
        {
          zoneID = 199,
          mountID = ""
        },
        -- Stonetalon Mountains
        {
          zoneID = 65,
          mountID = ""
        },
        -- Tanaris
        {
          zoneID = 71,
          mountID = ""
        },
        -- Teldrassil
        {
          zoneID = 57,
          mountID = ""
        },
        -- The Exodar
        {
          zoneID = 103,
          mountID = ""
        },
        -- Thunder Bluff
        {
          zoneID = 88,
          mountID = ""
        },
        -- Thousand Needles
        {
          zoneID = 64,
          mountID = ""
        },
        -- Uldum
        {
          zoneID = 249,
          mountID = ""
        },
        -- Un'Goro Crater
        {
          zoneID = 78,
          mountID = ""
        },
        -- Winterspring
        {
          zoneID = 83,
          mountID = ""
        },
      }
    },
    { -- Eastern Kingdoms
      zoneID = 13,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Abyssal Depths
        {
          zoneID = 204,
          mountID = ""
        },
        -- Arathi Highlands
        {
          zoneID = 14,
          mountID = ""
        },
        -- Badlands
        {
          zoneID = 15,
          mountID = ""
        },
        -- Blackrock Mountain
        {
          zoneID = 33,
          mountID = ""
        },
        -- Blasted Lands
        {
          zoneID = 17,
          mountID = ""
        },
        -- Burning Steppes
        {
          zoneID = 36,
          mountID = ""
        },
        -- Cape of Strangethorn
        {
          zoneID = 210,
          mountID = ""
        },
        -- Deadwind Pass
        {
          zoneID = 42,
          mountID = ""
        },
        -- Deeprun Tram
        {
          zoneID = 499,
          mountID = ""
        },
        -- Dun Morogh
        {
          zoneID = 29,
          mountID = ""
        },
        -- Duskwood
        {
          zoneID = 47,
          mountID = ""
        },
        -- Eastern Plaguelands
        {
          zoneID = 23,
          mountID = ""
        },
        -- Elwynn Forest
        {
          zoneID = 37,
          mountID = ""
        },
        -- Eversong Woods
        {
          zoneID = 94,
          mountID = ""
        },
        -- Ghostlands
        {
          zoneID = 95,
          mountID = ""
        },
        -- Hillsbrad Foothills
        {
          zoneID = 25,
          mountID = ""
        },
        -- Ironforge
        {
          zoneID = 87,
          mountID = ""
        },
        -- Isle of Quel'Danas
        {
          zoneID = 122,
          mountID = ""
        },
        -- Kelp'thar Forest
        {
          zoneID = 201,
          mountID = ""
        },
        -- Loch Modan
        {
          zoneID = 48,
          mountID = ""
        },
        -- Northern Stranglethorn
        {
          zoneID = 50,
          mountID = ""
        },
        -- Redridge Mountains
        {
          zoneID = 49,
          mountID = ""
        },
        -- Ruins of Gilneas
        {
          zoneID = 217,
          mountID = ""
        },
        -- Searing Gorge
        {
          zoneID = 32,
          mountID = ""
        },
        -- Shimmering Expanse
        {
          zoneID = 205,
          mountID = ""
        },
        -- Silvermoon City
        {
          zoneID = 110,
          mountID = ""
        },
        -- Silverpine Forest
        {
          zoneID = 21,
          mountID = ""
        },
        -- Stormwind City
        {
          zoneID = 84,
          mountID = ""
        },
        -- Swamp of Sorrows
        {
          zoneID = 51,
          mountID = ""
        },
        -- The Hinterlands
        {
          zoneID = 26,
          mountID = ""
        },
        -- Tirisfal Glades
        {
          zoneID = 18,
          mountID = ""
        },
        -- Tol Barad
        {
          zoneID = 245,
          mountID = ""
        },
        -- Twilight Highlands
        {
          zoneID = 241,
          mountID = ""
        },
        -- Undercity
        {
          zoneID = 90,
          mountID = ""
        },
        -- Vashj"ir: Kelp'thar Forest
        {
          zoneID = 201,
          mountID = ""
        },
        -- Vashj"ir: Shimmering Expanse
        {
          zoneID = 205,
          mountID = ""
        },
        -- Vashj"ir: Abyssal Depths
        {
          zoneID = 204,
          mountID = ""
        },
        -- Western Plaguelands
        {
          zoneID = 22,
          mountID = ""
        },
        -- Westfall
        {
          zoneID = 52,
          mountID = ""
        },
        -- Wetlands
        {
          zoneID = 56,
          mountID = ""
        },
      }
    },
    { -- Outland
      zoneID = 101,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Blades Edge Mountains
        {
          zoneID = 105,
          mountID = ""
        },
        -- Hellfire Penninsula
        {
          zoneID = 100,
          mountID = ""
        },
        -- Nagrand
        {
          zoneID = 107,
          mountID = ""
        },
        -- Netherstorm
        {
          zoneID = 109,
          mountID = ""
        },
        -- Shadowmoon Valley
        {
          zoneID = 104,
          mountID = ""
        },
        -- Terrokkar Forest
        {
          zoneID = 108,
          mountID = ""
        },
        -- Zangermarsh
        {
          zoneID = 102,
          mountID = ""
        },
        -- Shattrath
        {
          zoneID = 111,
          mountID = ""
        },
      }
    },
    { -- Northrend
      zoneID = 113,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Borean Tundra
        {
          zoneID = 114,
          mountID = ""
        },
        -- Crystalsong Forest
        {
          zoneID = 127,
          mountID = ""
        },
        -- Dalaran
        {
          zoneID = 125,
          mountID = ""
        },
        -- Dalaran Underbelly
        {
          zoneID = 126,
          mountID = ""
        },
        -- Dragonblight
        {
          zoneID = 115,
          mountID = ""
        },
        -- Grizzly Hills
        {
          zoneID = 116,
          mountID = ""
        },
        -- Howling Fjord
        {
          zoneID = 117,
          mountID = ""
        },
        -- Icecrown
        {
          zoneID = 118,
          mountID = ""
        },
        -- Sholazar Basin
        {
          zoneID = 119,
          mountID = ""
        },
        -- The Storm Peaks
        {
          zoneID = 120,
          mountID = ""
        },
        -- Wintergrasp
        {
          zoneID = 123,
          mountID = ""
        },
        -- Zul' Drak
        {
          zoneID = 121,
          mountID = ""
        },
      }
    },
    { -- Azeroth (Cataclysm)
      zoneID = 947,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Maelstrom
        {
          zoneID = 948,
          mountID = ""
        },
        -- Deepholm
        {
          zoneID = 207,
          mountID = ""
        },
      }
    },
    { -- Pandaria
      zoneID = 424,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Dread Wastes
        {
          zoneID = 422,
          mountID = ""
        },
        -- Isle of Thunder
        {
          zoneID = 504,
          mountID = ""
        },
        -- Karasarang Wilds
        {
          zoneID = 418,
          mountID = ""
        },
        -- Kun-Lai Summit
        {
          zoneID = 379,
          mountID = ""
        },
        -- Shrine of the Seven Stars
        {
          zoneID = 390,
          mountID = ""
        },
        -- Shrine of Two Moons
        {
          zoneID = 392,
          mountID = ""
        },
        -- The Jade Forest
        {
          zoneID = 371,
          mountID = ""
        },
        -- The Veiled Stair
        {
          zoneID = 433,
          mountID = ""
        },
        -- Timeless Isle
        {
          zoneID = 554,
          mountID = ""
        },
        -- Townlong Steppes
        {
          zoneID = 388,
          mountID = ""
        },
        -- Vale of Eternal Blossoms
        {
          zoneID = 390,
          mountID = ""
        },
        -- Valley of the Four Winds
        {
          zoneID = 376,
          mountID = ""
        },
      }
    },
    { -- Draenor
      zoneID = 572,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Ashran
        {
          zoneID = 588,
          mountID = ""
        },
        -- Frostfire Ridge
        {
          zoneID = 525,
          mountID = ""
        },
        -- Gorgrond
        {
          zoneID = 543,
          mountID = ""
        },
        -- Nagrand
        {
          zoneID = 550,
          mountID = ""
        },
        -- Shadowmoon Valley
        {
          zoneID = 539,
          mountID = ""
        },
        -- Spires of Arak
        {
          zoneID = 542,
          mountID = ""
        },
        -- Talador
        {
          zoneID = 535,
          mountID = ""
        },
        -- Tanaan Jungle
        {
          zoneID = 534,
          mountID = ""
        },
        -- Warspear
        {
          zoneID = 624,
          mountID = ""
        },
        -- Garrison
        {
          zoneID = 590,
          mountID = ""
        },
      }
    },
    { -- The Broken Isles
      zoneID = 619,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Azsuna
        {
          zoneID = 630,
          mountID = ""
        },
        -- Dalaran
        {
          zoneID = 627,
          mountID = ""
        },
        -- Dalaran Underbelly
        {
          zoneID = 628,
          mountID = ""
        },
        -- Eye of Azshara
        {
          zoneID = 790,
          mountID = ""
        },
        -- Helheim
        {
          zoneID = 649,
          mountID = ""
        },
        -- Highmountain
        {
          zoneID = 650,
          mountID = ""
        },
        -- Stormheim
        {
          zoneID = 634,
          mountID = ""
        },
        -- Suramar
        {
          zoneID = 680,
          mountID = ""
        },
        -- The Broken Shore
        {
          zoneID = 646,
          mountID = ""
        },
        -- Thundertotem (indoors)
        {
          zoneID = 652,
          mountID = ""
        },
        -- Thundertotem (outdoors)
        {
          zoneID = 750,
          mountID = ""
        },
        -- Val'sharah
        {
          zoneID = 641,
          mountID = ""
        },
        -- Val'sharah Dreamgrove
        {
          zoneID = 747,
          mountID = ""
        },
        -- Val'sharah Emerald Dreamway
        {
          zoneID = 715,
          mountID = ""
        },
      }
    },
    { -- Argus
      zoneID = 905,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Argus: Antoran Wastes
        {
          zoneID = 885,
          mountID = ""
        },
        -- Argus: Eredath
        {
          zoneID = 882,
          mountID = ""
        },
        -- Argus: Krokuun
        {
          zoneID = 830,
          mountID = ""
        },
        -- Argus: The Vindicaar
        {
          zoneID = 831,
          mountID = ""
        },
      }
    },
    { -- Zandalar
      zoneID = 875,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Dazaralor
        {
          zoneID = 1165,
          mountID = ""
        },
        -- Dazaralor The Great Seal
        {
          zoneID = 1163,
          mountID = ""
        },
        -- Nazmir
        {
          zoneID = 863,
          mountID = ""
        },
        -- Vol'dun
        {
          zoneID = 864,
          mountID = ""
        },
        -- Zuldazar
        {
          zoneID = 862,
          mountID = ""
        },
      }
    },
    { -- Kul-Tiras
      zoneID = 876,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Boralus
        {
          zoneID = 1161,
          mountID = ""
        },
        -- Drustvar
        {
          zoneID = 896,
          mountID = ""
        },
        -- Stormsong Valley
        {
          zoneID = 942,
          mountID = ""
        },
        -- Tiragarde Sound
        {
          zoneID = 895,
          mountID = ""
        },
      }
    },
    { -- Nazjatar
      zoneID = 1355,
      hasZones = false,
      useZones = false,
      mountID = 1792,
    },
    { -- Mechagon
      zoneID = 1462,
      hasZones = false,
      useZones = false,
      mountID = 1792,
    },
    { -- Shadowlands
      zoneID = 1550,
      hasZones = true,
      useZones = false,
      mountID = 1792,
      zones = {
        -- Ardenweald
        {
          zoneID = 1565,
          mountID = ""
        },
        -- Bastion
        {
          zoneID = 1533,
          mountID = ""
        },
        -- Maldraxxus
        {
          zoneID = 1536,
          mountID = ""
        },
        -- Revendreth
        {
          zoneID = 1525,
          mountID = ""
        },
        -- Oribos main quest floor
        {
          zoneID = 1670,
          mountID = ""
        },
        -- Oribos FP & Portals level
        {
          zoneID = 1671,
          mountID = ""
        },
        -- Korthia
        {
          zoneID = 1961,
          mountID = ""
        },
        -- The Maw
        {
          zoneID = 1543,
          mountID = ""
        },
        -- Zereth Mortis
        {
          zoneID = 1970,
          mountID = ""
        },
      }
    },
    { -- Dragon Isles
      zoneID = 1978,
      hasZones = true,
      useZones = true,
      mountID = 1589,
      zones = {
        -- The Waking Shores
        {
          zoneID = 2022,
          mountID = 1589
        },
        -- Ohn'ahra Plains
        {
          zoneID = 2023,
          mountID = 1590
        },
        -- Azure Span
        {
          zoneID = 2024,
          mountID = 1563
        },
        -- Thaldraszus
        {
          zoneID = 2025,
          mountID = 1591
        },
        -- Valdrakken
        {
          zoneID = 2112,
          mountID = 1591
        },
        -- Forbidden Reach
        {
          zoneID = 2151,
          mountID = 1589
        },
        -- Zaralek Cavern
        {
          zoneID = 2133,
          mountID = 1589
        },
        -- Emerald Dream
        {
          zoneID = 2200,
          mountID = 1589
        },
      }
    },
    { -- Khaz Algar
      zoneID = 2274,
      hasZones = true,
      useZones = true,
      mountID = 1792,
      zones = {
         -- Dornogal
        {
          zoneID = 2339,
          mountID = ""
        },
         -- Isle of Dorn
        {
          zoneID = 2248,
          mountID = ""
        },
         -- The Ringing Deeps
        {
          zoneID = 2214,
          mountID = 2144
        },
         -- Hallowfall
        {
          zoneID = 2215,
          mountID = 1051
        },
         -- Azj-Kahet
        {
          zoneID = 2255,
          mountID = 2181
        },
         -- Azj-Kahet Lower Levels
        {
          zoneID = 2256,
          mountID = 2181
        },
         -- City of Threads Umbral Bazaar
        {
          zoneID = 2213,
          mountID = 2181
        },
         -- City of Threads Lower Levels
        {
          zoneID = 2216,
          mountID = 2181
        },
      }
    }
  }
}