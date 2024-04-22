---@diagnostic disable: missing-parameter

local LegacyFramework = GetResourceState('LegacyFramework'):find('start') and
    exports["LegacyFramework"]:ReturnFramework() or nil
local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil
local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil


local pauseMenuActive = false
local NameServer = 'Legacy Framework'

function OpenPauseMenu()
    if LocalPlayer.state.invOpen then
        return
    end

    if LegacyFramework then
        local AllData = lib.callback.await('LegacyFramework:PlayerDataPauseMenu', false)
        local playerData = AllData[1]
        local moneyAccounts = json.decode(playerData.moneyAccounts)
        -- print(json.encode(AllData, { indent = true })) -- debug
        local id = GetPlayerServerId(PlayerId())
        local playerName = GetPlayerName(PlayerId())
        local DataPlayer = {
            name = playerData.firstName .. ' ' .. playerData.lastName,
            job = playerData.nameJob,
            cash = moneyAccounts.money,
            group = playerData.playerGroup,
            playerID = id,
            playerName = playerName,
            char = playerData.charName,
            nameServer = NameServer,
        }

        SendNUIMessage({
            DataPlayer = DataPlayer,
            action = "showPauseMenu",
            nameServer = NameServer
        })
    elseif ESX then
        local AllData = lib.callback.await('esx:PlayerDataPauseMenu', false)
        local playerData = AllData
        local moneyAccounts = AllData.moneyAccounts

        -- print(json.encode(AllData, { indent = true })) -- debug
        local id = GetPlayerServerId(PlayerId())
        local playerName = GetPlayerName(PlayerId())
        local DataPlayer = {
            name = playerData.firstName .. ' ' .. playerData.lastName,
            job = playerData.nameJob,
            cash = moneyAccounts,
            group = playerData.playerGroup,
            playerID = id,
            playerName = playerName,
            char = playerData.charName,
            nameServer = NameServer,
        }

        SendNUIMessage({
            DataPlayer = DataPlayer,
            action = "showPauseMenu",
            nameServer = NameServer
        })
    elseif QBCore then
        local group = {
            'admin',
            
        }
        local AllData = QBCore.Functions.GetPlayerData()
        local playerData = AllData
        local moneyAccounts = AllData.money
        local cash = moneyAccounts.cash
        print(json.encode(AllData, { indent = true })) -- debug
        local id = GetPlayerServerId(PlayerId())
        local playerName = GetPlayerName(PlayerId())
        local DataPlayer = {
            name = playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname,
            job = playerData.job.label,
            cash = cash,
            group = playerData.job.name,
            playerID = id,
            playerName = playerName,
            char = playerData.license,
            nameServer = NameServer,
        }

        SendNUIMessage({
            DataPlayer = DataPlayer,
            action = "showPauseMenu",
            nameServer = NameServer
        })
    end

    SetNuiFocus(true, true)
    pauseMenuActive = true
    SetPauseMenuActive(false)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        OpenCam(PlayerPedId())
    else
        return
    end
end


RegisterKeyMapping('__pauseMenu__', 'Open Pause Menu', 'keyboard', 'ESCAPE')
RegisterCommand('__pauseMenu__', function()
    if not IsPauseMenuActive() then
        OpenPauseMenu()
    end
end)

function ClosePauseMenu()
    SetNuiFocus(false, false)
    pauseMenuActive = false
    SetPauseMenuActive(true)
end

lib.addKeybind({
    name = 'pausemenu',
    description = 'Open pause menu',
    defaultKey = 'ESCAPE',
    onPressed = function(self)
        if not IsPauseMenuActive() then
            OpenPauseMenu()
        end
        while pauseMenuActive do
            Wait(0)
            DisableControlAction(1, 200, true)
        end
    end,
    onReleased = function(self)
    end

})
