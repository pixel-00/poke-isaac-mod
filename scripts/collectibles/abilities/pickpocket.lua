local pickpocket = Isaac.GetItemIdByName("Pickpocket")

local trinketsThisFloor = 0

function mod:SpawnTrinket(entity)
    local player = Isaac.GetPlayer()
    if player:HasCollectible(pickpocket) and entity:IsActiveEnemy(false) then
        local luck = player.Luck
        if math.random() <  (0.25 + 0.03 * math.min(luck, 20)) / (trinketsThisFloor + 1) then
            local spawnPosition = Game():GetLevel():GetCurrentRoom():FindFreePickupSpawnPosition(entity.Position)
            Game():Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, spawnPosition, Vector(0,0), entity, 0, mod:RandomPositive())
            trinketsThisFloor = trinketsThisFloor + 1
        end
    end
end

function mod:ResetCounter()
    trinketsThisFloor = 0
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.SpawnTrinket)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetCounter)