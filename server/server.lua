local RSGCore = exports['rsg-core']:GetCoreObject()

local Objects = {}

local function CreateObjectId()
    if Objects then
        local objectId = math.random(10000, 99999)
        while Objects[objectId] do
            objectId = math.random(10000, 99999)
        end
        return objectId
    else
        local objectId = math.random(10000, 99999)
        return objectId
    end
end

RSGCore.Functions.CreateUseableItem('storagebox', function(source, item)TriggerClientEvent("storagebox:Client:spawnbag", source)end)

RegisterNetEvent('storagebox:Server:SpawnAmbulanceBag', function(type)
    local src = source
    local objectId = CreateObjectId()
    Objects[objectId] = type
    TriggerClientEvent("storagebox:Client:SpawnAmbulanceBag", src, objectId, type, src)
end)

RegisterNetEvent('storagebox:Server:RemoveItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
end)

RegisterNetEvent('storagebox:Server:AddItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amount)
end)

RegisterNetEvent('storagebox:server:openStorageBoxInventory', function(storagestash, invWeight, invSlots)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Define storage box properties with label, max weight, and slot count
    local data = { label = 'Storage Box', maxweight = invWeight, slots = invSlots }
    
    -- Open the player's inventory for the specified stash
    exports['rsg-inventory']:OpenInventory('stash', storagestash, data)
end)




