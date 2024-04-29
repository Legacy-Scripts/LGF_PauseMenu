
local Bridge = lib.class("Bridge")
local Search = promise.new()

if GetResourceState("LegacyFramework") ~= "missing" then 
    Search:resolve({"LegacyFramework", "ReturnFramework"})
elseif GetResourceState("es_extended") ~= "missing" then 
    Search:resolve({"es_extended", "getSharedObject"})
elseif GetResourceState("qb-core") ~= "missing" then 
    Search:resolve({"qb-core", "GetCoreObject"})
else
    Search:reject("Could not find a framework!")
end

local Name, Object <const> = table.unpack(Citizen.Await(Search))
local Framework <const> = exports[Name][Object]()

if lib.context == "client" then
    function Bridge:GetPlayerData()
        local Data = {
            playerName = GetPlayerName(cache.playerId),
            playerID = cache.serverId
        }
        
        local Player
        
        if Name == "LegacyFramework" then 
            Player = LocalPlayer.state.playerData[1]
            Data.group = Player.playerGroup
            Data.job = Player.nameJob 
            Data.identifier = Player.charName
            local Accounts = json.decode(Player?.moneyAccounts)
            Data.cash = Accounts?.money
            Data.name = ("%s %s"):format(Player.firstName, Player.lastName)
        elseif Name == "es_extended" then 
            Player = Framework.PlayerData
            Data.group = Player.group
            Data.job = Player.job.label
            Data.identifier = Player.identifier
            Data.cash = Framework.GetAccount("money").money
            Data.name = ("%s %s"):format(Player.firstName, Player.lastName)
        elseif Name == "qb-core" then 
            Player = Framework.Functions.GetPlayerData()
            Data.group = Player.job.name            
            Data.job = Player.job.label
            Data.identifier = Player.license
            Data.cash = Player.money?.cash
            Data.name = ("%s %s"):format(Player.charinfo.firstname, Player.charinfo.lastname)
        end

        return Data
    end
end

return Bridge