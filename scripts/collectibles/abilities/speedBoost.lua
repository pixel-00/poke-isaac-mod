local speedBoost = Isaac.GetItemIdByName("Speed Boost")

function mod:StackSpeedBoost()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(speedBoost) then
        local n = player:GetData().SpeedBoostStacks
        if n then
            player:GetData().SpeedBoostStacks = n + 1
        else
            player:GetData().SpeedBoostStacks = 1
        end
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
end

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(speedBoost)
    if itemCount > 0 and ((cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED) then
        local speedToAdd = 0.1 * player:GetData().SpeedBoostStacks * itemCount
        player.MoveSpeed = player.MoveSpeed + speedToAdd
    end
end

function mod:ResetSpeedBoostStacks()
    local player = Isaac.GetPlayer()
    player:GetData().SpeedBoostStacks = 0
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.StackSpeedBoost)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSpeedBoostStacks)