local redMap = Isaac.GetItemIdByName("Red Map")

local needToDisplayUltraSecret = true

function mod:redMap()
    local function f(player)
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

    mod:DoForAllPlayers(f)
end

function mod:newLevel()
    needToDisplayUltraSecret = true
end

function mod:SpawnCrackedKey(rng, spawnPosition)
    local function f(player)
        if player:HasCollectible(redMap) then
            local x = rng:RandomFloat()

            if x < 0.05 then
                local spawnPosition = Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())

                Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, spawnPosition, Vector(0,0), pickup, Card.CARD_CRACKED_KEY, mod:RandomPositive())
            end
        end
    end

    mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.redMap)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.newLevel)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.SpawnCrackedKey)