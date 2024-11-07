--[[------------------------------------------------------
----                   Configuration                  ----
----        For Support - discord.gg/YzC4Du7WY        ----
----       Docs - https://docs.threeamigos.shop       ----
--]]------------------------------------------------------
local config = {}

-- Be sure to read the documentation in order to setup the github & discord integration!

config.cooldown = 300000 -- Cooldown time in miliseconds. This is set to 300000 (15 minutes) by default.

config.identifier = 'license' -- The identifier to link to the player. Will be formated like:  Username | Identifier. Available options are: https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/GetPlayerIdentifiers/#license-types

config.loggerEnabled = false -- Should we use ox_libs logger functionality?

config.githubEnabled = false -- Should we create a github issue when a user submits a bug report?

config.discordEnabled = true -- Should we send a Discord embed via webhook when a user submits a bug report?

config.embedConfig = {
    username = "TAM_BugReports", -- The bots username
    logo = "https://raw.githubusercontent.com/ThreeAmigosModding/ThreeAmigosModding/refs/heads/main/img/tam_logo_1k.png" -- Direct image link to the bots profile picture.
}

config.keybind = {
    enabled = true, -- Should there be a keybind setup to open the UI?
    defaultKey = "F10"
}

config.severity = { -- List of available severity options
    "Minor",
    "Major",
    "Critical"
}

config.types = { -- List of available bug report types.
    "Other",
    "Graphics",
    "UI",
    "Performance",
    "Audio",
    "NPCs",
    "Animation",
    "Interaction",
    "Terrain/Map",
    "Vehicle",
    "PVP"
}

return config