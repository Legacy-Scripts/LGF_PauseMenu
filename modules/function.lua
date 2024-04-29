
local Functions = {}
local camera

function Functions:OpenCam()
    TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_SMOKING_POT', 0, true)

    local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0, 1.6, 0)

    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1250, 1, 0)
    SetCamCoord(camera, coords.x, coords.y, coords.z + 0.65)
    SetCamFov(camera, 38.0)
    SetCamRot(camera, 0.0, 0.0, GetEntityHeading(cache.ped) + 180)
    PointCamAtPedBone(camera, cache.ped, 31086, 0.0 - 0.4, 0.0, 0.03, 1)
    
    local coords = GetCamCoord(camera)
    TaskLookAtCoord(cache.ped, coords.x, coords.y, coords.z, 5000, 1, 1)
    SetCamUseShallowDofMode(camera, true)
    SetCamNearDof(camera, 1.2)
    SetCamFarDof(camera, 12.0)
    SetCamDofStrength(camera, 1.0)
    SetCamDofMaxNearInFocusDistance(camera, 1.0)

    repeat SetUseHiDof() Wait(0) until not DoesCamExist(camera)
end

function Functions:CloseCam()
    RenderScriptCams(false, true, 1250, 1, 0)
    DestroyCam(camera, false)
    ClearPedTasks(cache.ped)
    camera = nil
end

AddEventHandler("onResourceStop", function(resource)
    if cache.resource == resource and DoesCamExist(camera) then 
        Functions:CloseCam()
    end
end)

function Functions:GetLocale()
    local Language = GetConvar("pausemenu:language", "en")
    local File = LoadResourceFile(cache.resource, ("locales/%s.json"):format(Language))

    if not File then 
        print("[^4WARNING^7] Defined Language does not exist in locales/lang.json please inform server owner.")
        File = LoadResourceFile(cache.resource, "locales/en.json")
    end
    
    return json.decode(File)
end

return Functions