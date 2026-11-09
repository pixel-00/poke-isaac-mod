local stall = Isaac.GetItemIdByName("Stall")

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(stall)
    if itemCount > 0 and player:GetData().StallAbilityActive and ((cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = 0.1^itemCount
    end
end

function mod:RemoveDebuff()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(stall) then
        player:GetData().StallAbilityActive = false
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
end

function mod:ApplyDebuff()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(stall) and not Game():GetLevel():GetCurrentRoom():IsClear() then
        player:GetData().StallAbilityActive = true
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ApplyDebuff)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.RemoveDebuff)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)