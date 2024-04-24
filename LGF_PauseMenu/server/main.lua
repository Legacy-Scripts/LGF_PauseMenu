local LegacyFramework = GetResourceState('LegacyFramework'):find('start') and exports["LegacyFramework"]:ReturnFramework() or nil
local ESX = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil

if LegacyFramework then
    lib.callback.register('LegacyFramework:PlayerDataPauseMenu', function(source)
        local _source = source
        local playerData = LegacyFramework.SvPlayerFunctions.GetPlayerData(_source)
        return playerData
    end)
elseif ESX then
    lib.callback.register('esx:PlayerDataPauseMenu', function(source)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local playerIdentifier = xPlayer.getIdentifier()
        if not xPlayer then
            return
        end

        local playerData = {
            firstName = xPlayer.get('firstName'),
            lastName = xPlayer.get('lastName'),
            nameJob = xPlayer.getJob().label,
            moneyAccounts = xPlayer.getAccount('money').money,
            playerGroup = xPlayer.getGroup(),
            charName = playerIdentifier,
        }

        return playerData
    end)
end

local Reason = 'Sei uscito dal gioco'

RegisterNetEvent('LGF:QuitPlayer')
AddEventHandler('LGF:QuitPlayer', function()
    local PlayerDropped = source
    DropPlayer(PlayerDropped, Reason)
end)
