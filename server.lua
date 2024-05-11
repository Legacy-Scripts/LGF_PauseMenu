
lib.versionCheck('ENT510/LGF_PauseMenu')

local Bridge <const> = require 'modules.bridge'

local Reason <const> = GetConvar('pausemenu:logoutReason', 'Sei uscito dal gioco')

RegisterServerEvent('LGF:QuitPlayer', function()
    DropPlayer(source, Reason)
end)