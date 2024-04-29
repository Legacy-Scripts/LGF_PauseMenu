
local Bridge <const> = require 'modules.bridge'
local Functions = require 'modules.function'
local State = LocalPlayer.state

State.PauseMenu = false

local DiscordInvite <const> = GetConvar("pausemenu:discordInvite", "https://discord.gg/wd5PszPA2p")
local ServerName <const> = GetConvar("pausemenu:serverName", "Legacy Framework")
local Debug <const> = GetConvar("pausemenu:debug", true)

local function loop()
    repeat DisableControlAction(1, 200, true) Wait(0) until not State.PauseMenu
end

function Functions:OpenPauseMenu()
    SetPauseMenuActive(false)
    CreateThread(loop)

    local Player <const> = Bridge:GetPlayerData()

    -- https://overextended.dev/ox_lib/Modules/Print/Shared
    lib.print.debug(json.encode(Player, {indent=true}))
    
    SendNUIMessage({ DataPlayer = Player, nameServer = ServerName, discordInvite = DiscordInvite })
    SetNuiFocus(true, true)

    State.PauseMenu = true
    Functions:OpenCam()
end

function Functions:ClosePauseMenu()
    SetNuiFocus(false, false)
    State.PauseMenu = false
    SetPauseMenuActive(true)
end

local function canOpen()
    return not State.invOpen
    and not IsPedInAnyVehicle(cache.ped, false)
    and not IsPauseMenuActive()
end

lib.addKeybind({
    name = 'pausemenu',
    description = 'Open pause menu',
    defaultKey = 'ESCAPE',
    onPressed = function()
        if canOpen() then
            Functions:OpenPauseMenu()
        end
    end,
})

require "modules.callbacks"