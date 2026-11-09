local stall = Isaac.GetItemIdByName("Stall")

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(stall)
    if itemCount > 0 and ((cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED) then
        local toggle = player:GetData().StallAbilityActive and 1 or 0
        local speedToAdd = toggle * ((0.1 - player.MoveSpeed)^itemCount)
        player.MoveSpeed = player.MoveSpeed + speedToAdd
    end
end

function mod:RemoveDebuff()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(stall) then
        player:GetData().StallAbilityActive = false
    end
end

function mod:ApplyDebuff()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(stall) and not Game():GetLevel():GetCurrentRoom():IsClear() then
        player:GetData().StallAbilityActive = true
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ApplyDebuff)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.RemoveDebuff)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)