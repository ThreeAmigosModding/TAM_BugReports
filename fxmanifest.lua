--[[------------------------------------------------------
----       For Support - discord.gg/threeamigos       ----
----       Docs - https://docs.threeamigos.shop       ----
---- Do not edit if you do not know what you're doing ----
--]]------------------------------------------------------

game "gta5"
lua54 "yes"
fx_version "cerulean"
use_experimental_fxv2_oal "yes"

name "TAM_BugReports"
author "ThreeAmigosModding"
description "Bug Report System for fivem with Discord & GitHub integration."
version "1.0.0"

files {
    "data/**",
    "web/build/index.html",
	"web/build/**/*",
}

ui_page "web/build/index.html"

dependencies {
    "/server:9000",
    "/gameBuild:2802",
    "/onesync",
    "ox_lib",
}

shared_scripts {
    "@ox_lib/init.lua"
}

client_scripts {
    "client/main.lua",
}

server_scripts {
    "server/main.lua",
}