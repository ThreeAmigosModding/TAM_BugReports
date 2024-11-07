--[[------------------------------------------------------
----        For Support - discord.gg/YzC4Du7WYm       ----
----       Docs - https://docs.threeamigos.shop       ----
---- Do not edit if you do not know what you're doing ----
--]]------------------------------------------------------
assert(lib ~= nil, "ox_lib is either missing or outdated, please ensure you have the latest version installed! \n https://github.com/overextended/ox_lib/releases/latest")
assert(lib.checkDependency("ox_lib", '3.20.0') ~= nil, "ox_lib is outdated! Please ensure you upgrade to the latest version! \n https://github.com/overextended/ox_lib/releases/latest")

_ENV.LoadedResource = true

local function loadConfig()
    Config = require 'data.configuration'

    if not Config then
        return false
    end
    return true
end

local function printConsoleMsg(fail, reason)
    lib.print.info("-----------------------------------------------")
    lib.print.info("Loading TAM_BugReports")

    if fail then
        lib.print.error(reason)
        lib.print.error("Resource loading aborted")
        _ENV.LoadedResource = false
    elseif not fail then
        lib.locale()
        lib.print.info("Successfully loaded TAM_BugReports!")
        lib.print.info("Thanks for your download!")
    end

    lib.print.info("Discord - discord.gg/YzC4Du7WYm")
    lib.print.info("Documenation - docs.threeamigos.shop")
    lib.print.info("Tebex - threeamigos.shop")
    lib.print.info("-----------------------------------------------")
end

if GetCurrentResourceName() ~= "TAM_BugReports" then
    printConsoleMsg(true, "Resource must be named TAM_Fuel to function properly! Aborting loadup.")
elseif not GetResourceMetadata("TAM_BugReports", "author", 0) == "ThreeAmigosModding" then
    printConsoleMsg(true, "Error loading fxmanifest! Aborting loadup.")
elseif not loadConfig() then
    printConsoleMsg(true, "Error loading Configuration. Please be sure that the config file exists and there aren't any syntax errors! Aborting loadup.")
elseif not LoadResourceFile('TAM_BugReports', 'locales/en.json') then
    printConsoleMsg(true, "Error loading locales directory. Please be sure the en.json file exists! Aborting loadup.")
elseif not LoadResourceFile('TAM_BugReports', 'web/build/index.html') then
    printConsoleMsg(true, "Error loading UI! UI Not built! Aborting Loadup.")
end

if _ENV.LoadedResource then
    printConsoleMsg(false)
end

if lib.context == "SERVER" then lib.versionCheck('threeamigosmodding/TAM_BugReports') end