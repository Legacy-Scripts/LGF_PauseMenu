
lib.versionCheck('ENT510/LGF_PauseMenu')

local Reason <const> = 'Sei uscito dal gioco'

RegisterServerEvent('LGF:QuitPlayer', function()
    DropPlayer(source, Reason)
end)