local stall = Isaac.GetItemIdByName("Stall")

local STALL_STATUS = {}

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(stall)
    local index = mod:GetPlayerIndex(player)

    if itemCount > 0 and STALL_STATUS[index] and ((cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED) then
        player.MoveSpeed = 0.1^itemCount
    end
end

function mod:RemoveDebuff()
    local function f(player)
        if player:HasCollectible(stall) then
            local index = mod:GetPlayerIndex(player)

            STALL_STATUS[index] = false
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:ApplyDebuff()
    local function f(player)
        if player:HasCollectible(stall) and not Game():GetLevel():GetCurrentRoom():IsClear() then
            local index = mod:GetPlayerIndex(player)

            STALL_STATUS[index] = true
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end

    mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ApplyDebuff)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.RemoveDebuff)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)