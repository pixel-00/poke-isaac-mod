local slowStart = Isaac.GetItemIdByName("Slow Start")

function mod:ResetSlowStart()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(slowStart) then
        player:GetData().SlowStartAbilityRooms = 0
    end
end

function mod:CountRoomClear()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(slowStart) then
        local n = player:GetData().SlowStartAbilityRooms
        if n then
            if n < 5 then
                player:GetData().SlowStartAbilityRooms = n + 1
            end
        else
            player:GetData().SlowStartAbilityRooms = 1
        end
    end
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(slowStart)
    local n = player:GetData().SlowStartAbilityRooms
    if itemCount > 0 then
        local applyDebuff = 1
        if n then
            applyDebuff = (n < 5) and 1 or 0
        end
        local multiplier = 0.5^(itemCount * applyDebuff)
        if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed * multiplier
        end
        if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
            local damageToAdd = 2 * itemCount
            player.Damage = (player.Damage + damageToAdd) * multiplier
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSlowStart)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.CountRoomClear)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)