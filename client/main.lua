--[[------------------------------------------------------
----        For Support - discord.gg/YzC4Du7WYm       ----
----       Docs - https://docs.threeamigos.shop       ----
---- Do not edit if you do not know what you're doing ----
--]]------------------------------------------------------
---@diagnostic disable: cast-local-type
local rateLimit = false

--- Resets the NUI Focus
local function resetNuiFocus()
    SetNuiFocus(false, false)
end

---Toggles the bug report UI
---@param status boolean true/false to toggle the UI.
local function toggleBugReportUI(status)
    SetNuiFocus(status, status)
    SendNUIMessage({
        action = 'setVisible',
        data = status
    })
end

--- Returns the in-game time.
---@return string
local function getTime()
    local hour = GetClockHours()
    local minute = GetClockMinutes()

    if hour <= 9 then
        hour = "0" .. hour
    end

    if minute <= 9 then
        minute = "0" .. minute
    end

    return hour .. ":" .. minute
end

---Registers the cancel callback from NUI & handles it.
---@param _ nil Not used.
---@param cb function Not used.
RegisterNUICallback('cancel', function(_, cb)
    toggleBugReportUI(false)
    resetNuiFocus()
    cb({})
end)

--- Registers the submit callback from NUI & handles it.
---@param data dataProps the data returned from NUI.
---@param cb function Not used.
RegisterNUICallback('submit', function(data, cb)
    if not data then return end

    local data = {
        title = data.title,
        type = data.type == '' and 'Other' or data.type,
        severity = data.severity == '' and 'Low' or data.severity,
        expectedResult = data.expectedResult,
        actualResult = data.actualResult,
        reproduce = data.reproduce,
        author = GetPlayerName(cache.playerId),
        identifier = "Unknown",
        coords = GetEntityCoords(cache.ped),
        timeStamp = "01/01/1999",
        time = getTime()
    }

    toggleBugReportUI(false)
    local response = lib.callback.await("tam_bugReports:sendReport", false, data)

    if not response then return end

    rateLimit = true
    lib.notify({description = locale("notify_success_sent_report"), type = 'success', duration = 5000})
    SetTimeout(Config.cooldown, function()
        rateLimit = false
    end)
    cb({})
end)

--- Registers the NUI callback to fetch the Config data.
---@param _ nil Not used.
---@param cb function Callback function to return the data fetched from the Config.
RegisterNUICallback("getConfigData", function(_, cb)
    local retData <const> = { severity = Config.severity,  types = Config.types}
    cb(retData)
end)

---Registers the bug report command.
RegisterCommand(locale("command_name"), function()
    if rateLimit then lib.notify({description = locale('notify_error_ratelimited'), type = 'error', duration = 5000}) return end
    toggleBugReportUI(true)
end)
TriggerEvent("chat:addSuggestion", "/" .. locale("command_name"), locale("command_help"))

if Config.keybind.enabled then
    lib.addKeybind({
        name = "bugreport",
        description = locale("keybind_description"),
        defaultKey = Config.keybind.defaultKey,
        onReleased = function()
            if rateLimit then lib.notify({description = locale('notify_error_ratelimited'), type = 'error', duration = 5000}) return end
            toggleBugReportUI(true)
        end
    })
end

CreateThread(function()
    resetNuiFocus()
end)