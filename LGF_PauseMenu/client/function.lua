local ScenarioType = 'WORLD_HUMAN_SMOKING_POT'
local camera

DebugPrint = function (...)
    if not Config.Debug then return end
    local args = {...}
    local formatedArgs = {}

    for i, arg in ipairs(args) do
        if type(arg) == "table" then
            formatedArgs[i] = json.encode(arg)
        else
            formatedArgs[i] = arg
        end
    end

    print(table.unpack(formatedArgs))
end

OpenCam = function(ped)
    TaskStartScenarioInPlace(ped, ScenarioType, 0, true)
    local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 1.6, 0)
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1250, 1, 0)
    SetCamCoord(camera, coords.x, coords.y, coords.z + 0.65)
    SetCamFov(camera, 38.0)
    SetCamRot(camera, 0.0, 0.0, GetEntityHeading(ped) + 180)
    -- DisplayRadar(false)
    PointCamAtPedBone(camera, ped, 31086, 0.0 - 0.4, 0.0, 0.03, 1)
    local camCoords = GetCamCoord(camera)
    TaskLookAtCoord(ped, camCoords.x, camCoords.y, camCoords.z, 5000, 1, 1)
    SetCamUseShallowDofMode(camera, true)
    SetCamNearDof(camera, 1.2)
    SetCamFarDof(camera, 12.0)
    SetCamDofStrength(camera, 1.0)
    SetCamDofMaxNearInFocusDistance(camera, 1.0)
    Citizen.CreateThread(function()
        while DoesCamExist(camera) do
            SetUseHiDof()
            Wait(0)
        end
    end)
end

CloseCam = function()
    RenderScriptCams(false, true, 1250, 1, 0)
    DestroyCam(camera, false)
    ClearPedTasks(PlayerPedId())
    -- DisplayRadar(true)
end



