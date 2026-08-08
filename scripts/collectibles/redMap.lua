local redMap = Isaac.GetItemIdByName("Red Map")
local keyCrusher = Isaac.GetTrinketIdByName("Key Crusher")
local needToDisplayUltraSecret = true

function mod:redMap()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(redMap) and needToDisplayUltraSecret then
        local level = Game():GetLevel()
        local rooms = level:GetRooms()
        local ultraSecretIndex = -1
        for i = 0, rooms.Size - 1 do
            if rooms:Get(i).Data.Type == RoomType.ROOM_ULTRASECRET then
                ultraSecretIndex = rooms:Get(i).GridIndex
            end
        end
        needToDisplayUltraSecret = false
        if ultraSecretIndex >= 0 then
            local ultraSecretRoom = level:GetRoomByIdx(ultraSecretIndex)
            ultraSecretRoom.DisplayFlags = (1 << 0) | (1 << 1) | (1 << 2)
            level:UpdateVisibility()
        end
    end
end

function mod:newLevel()
    needToDisplayUltraSecret = true
end

function mod:SpawnTrinket(player)
    local queued = player.QueuedItem
    local data = player:GetData()
    if queued.Item and queued.Item:IsCollectible() and queued.Item.ID == redMap and not queued.Touched then
        data.numRedMap = player:GetCollectibleNum(redMap)
    end
    if data.numRedMap and data.numRedMap < player:GetCollectibleNum(redMap) then
        local spawnPosition = Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(player.Position)
        Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, spawnPosition, Vector(0,0), player, keyCrusher, mod:RandomPositive())
        data.numRedMap = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.redMap)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.newLevel)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.SpawnTrinket)