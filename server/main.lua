--[[------------------------------------------------------
----        For Support - discord.gg/YzC4Du7WYm       ----
----       Docs - https://docs.threeamigos.shop       ----
---- Do not edit if you do not know what you're doing ----
--]]------------------------------------------------------
local convars = {
    githubToken = GetConvar("tamReports:githubToken", "NO_TOKEN"),
    githubRepo = GetConvar("tamReports:githubRepo", "NO_REPO"),
    githubOrg = GetConvar("tamReports:githubOrg", "NO_ORG"),
    discordWebhook = GetConvar("tamReports:discordWebhook", "NO_WEBHOOK_URL"),
}

local config = require 'data.config'
local rateLimit = false

--- sends an issue to a specific github repository
---@param data dataProps
local function createGitHubIssue(data)
    local url = ("https://api.github.com/repos/%s/%s/issues"):format(convars.githubOrg, convars.githubRepo)

    local body = ("**Reported By**: %s | %s\n**Bug Description**: %s\n**Type**: %s\n**Severity**: %s\n**Expected Result**: %s\n**Actual Result**: %s\n**Steps to reproduce**: %s\n**Player Coords**: %s\n**Timestamp**: %s\n**In-game Time**: %s"):format(data.author, data.identifier, data.title, data.type, data.severity, data.expectedResult, data.actualResult, data.reproduce, data.coords, data.timeStamp, data.time)

    local issueData = {
        title = data.title,
        body = body,
        labels = { "Type: " .. data.type, "Severity: " .. data.severity } -- Set type and severity as labels
    }

    PerformHttpRequest(url, function(statusCode)
        if statusCode ~= 201 then
            lib.print.error(locale("failed_issue"):format(statusCode))
        end
    end, 'POST', json.encode(issueData), {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = ('token %s'):format(convars.githubToken),
    })
end

--- sends an issue to a specific github repository
---@param data dataProps
local function createDiscordMessage(data)
    local embed = {
        title = data.title,
        color = 8421504,
        fields = {
            {
                name = "**Reported By**",
                value = data.author .. " | " .. data.identifier,
                inline = true
            },
            {
                name = "**Bug Description**",
                value = data.title,
                inline = false
            },
            {
                name = "**Type**",
                value = data.type,
                inline = true
            },
            {
                name = "**Severity**",
                value = data.severity,
                inline = true
            },
            {
                name = "**Expected Result**",
                value = data.expectedResult,
                inline = false
            },
            {
                name = "**Actual Result**",
                value = data.actualResult,
                inline = false
            },
            {
                name = "**Steps to reproduce**",
                value = data.reproduce,
                inline = false
            },
            {
                name = "**Player Coords**",
                value = ("vec3(%s, %s, %s)"):format(data.coords.x, data.coords.y, data.coords.z),
                inline = true
            },
            {
                name = "**Timestamp**",
                value = data.timeStamp,
                inline = true
            },
            {
                name = "**In-game Time**",
                value = data.time,
                inline = true
            }
        },
        footer = {
            text = "TAM_BugReports by Three Amigos Modding"
        }
    }

    local payload = {
        embeds = {embed},
        username = config.embedConfig.username,
        avatar_url = config.embedConfig.logo
    }

    PerformHttpRequest(convars.discordWebhook, function(statusCode)
        if statusCode ~= 204 then
            lib.print.error(locale("failed_discord"):format(statusCode))
        end
    end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json'
    })
end

lib.callback.register("tam_bugReports:sendReport", function(source, data)
    if rateLimit then return false end

    if not data then return end

    data.identifier = GetPlayerIdentifierByType(source, config.identifier) or "Unknown"

    if config.discordEnabled then
        createDiscordMessage(data)
    end
    if config.githubEnabled then
        createGitHubIssue(data)
    end
    if config.loggerEnabled then
        lib.logger(source, 'TAM_BugReport', ("**Reported By**: %s | %s\n**Bug Description**: %s\n**Type**: %s\n**Severity**: %s\n**Expected Result**: %s\n**Actual Result**: %s\n**Steps to reproduce**: %s\n**Player Coords**: %s\n**Timestamp**: %s\n**In-game Time**: %s"):format(data.author, data.identifier, data.title, data.type, data.severity, data.expectedResult, data.actualResult, data.reproduce, data.coords, data.timeStamp, data.time))
    end
    rateLimit = true
    SetTimeout(config.cooldown, function()
        rateLimit = false
    end)

    return true
end)

lib.callback.register("tam_bugReports:getTime", function(source)
    return os.date("%m/%d/%Y %X")
end)