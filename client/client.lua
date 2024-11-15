local RSGCore = exports['rsg-core']:GetCoreObject()

local ObjectList = {}

RegisterNetEvent('storagebox:Client:SpawnAmbulanceBag', function(objectId, type, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(PlayerPedId())
    local x, y, z = table.unpack(coords + forward * 1.5)
    local spawnedObj = CreateObject(Config.Bag.AmbulanceBag[type].model, x, y, coords.z-1, true, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    FreezeEntityPosition(spawnedObj, Config.Bag.AmbulanceBag[type].freeze)
    ObjectList[objectId] = {
        id = objectId,
        object = spawnedObj,
        coords = vector3(x, y, z - 0.3),
    }
    TriggerServerEvent("storagebox:Server:RemoveItem","storagebox",1)
end)

RegisterNetEvent('storagebox:Client:spawnbag', function()
    local playerPed = PlayerPedId()

    
    TaskStartScenarioInPlace(playerPed, GetHashKey("WORLD_HUMAN_CROUCH_INSPECT"), -1, true)

   
    lib.progressBar({
        duration = 2500,  
        label = 'Putting the box down...',  
        useWhileDead = false,  
        canCancel = true,  
        disable = { move = true, car = true }  
    })

    
    ClearPedTasksImmediately(playerPed)

    
    TriggerServerEvent("storagebox:Server:SpawnAmbulanceBag", "storagebox")
end)


RegisterNetEvent('storagebox:Client:GuardarAmbulanceBag', function()
    local playerPed = PlayerPedId()

   
    TaskStartScenarioInPlace(playerPed, GetHashKey("WORLD_HUMAN_CROUCH_INSPECT"), -1, true)

    
    lib.progressBar({
        duration = 2500,  
        label = 'Taking back the box...',  
        useWhileDead = false,  
        canCancel = true, 
        disable = { move = true, car = true }  
    })

    
    ClearPedTasksImmediately(playerPed)
    
    local playerPedPos = GetEntityCoords(playerPed, true)

    
    local AmbulanceBag = GetClosestObjectOfType(playerPedPos, 10.0, GetHashKey("p_ammoboxlancaster01x"), false, false, false)

    
    if AmbulanceBag then
        
        SetEntityAsMissionEntity(AmbulanceBag, true, true)

        
        DeleteObject(AmbulanceBag)

        
    else
        -- If no object was found, notify the player
        --RSGCore.Functions.Notify('No box found to pick up', 'error')
    end

    
    TriggerServerEvent("storagebox:Server:AddItem", "storagebox", 1)
end)


local citizenid = nil
AddEventHandler("storagebox:Client:StorageAmbulanceBag", function()
    local charinfo = RSGCore.Functions.GetPlayerData().charinfo
    citizenid = RSGCore.Functions.GetPlayerData().citizenid
    TriggerEvent("inventory:client:SetCurrentStash", "storagebox",citizenid)
    TriggerServerEvent("inventory:server:Inventory", "stash", "storagebox",citizenid, {
        maxweight = 40000,
        slots = 48,
    })
end)


RegisterNetEvent('storagebox:Client:MenuAmbulanceBag', function()
    local playerPed = PlayerPedId()
    if IsEntityDead(playerPed) then 
        RSGCore.Functions.Notify('You cannot Open Box while dead', 'error')
        return 
    end
    if IsPedSwimming(playerPed) then 
        RSGCore.Functions.Notify('You cannot Open Box in the water', 'error')
        return 
    end
    if IsPedSittingInAnyVehicle(playerPed) then 
        RSGCore.Functions.Notify('You cannot Open Box inside a vehicle', 'error')
        return 
    end
    
    local job = RSGCore.Functions.GetPlayerData().job.name
    if Config.Bag.NeedJob then
        if job ~= Config.Bag.Job then
            RSGCore.Functions.Notify('You don’t have permission to Open the Box', 'error')
            return
        end
    end

    local citizenid = RSGCore.Functions.GetPlayerData().citizenid
    TriggerServerEvent('storagebox:server:openStorageBoxInventory', 'storagebox_' .. citizenid, 40000, 48)
end)


local AmbulanceBags = {
    `p_ammoboxlancaster01x`,
}

exports['rsg-target']:AddTargetModel(AmbulanceBags, {
    options = {{event   = "storagebox:Client:MenuAmbulanceBag",icon    = "fa-solid fa-box",label   = "storage"},
    {event   = "storagebox:Client:GuardarAmbulanceBag",icon    = "fa-solid fa-box",label   = "Take Back Box"},},distance = 2.0 })
