local overgrow = Isaac.GetItemIdByName("Overgrow")
local blaze = Isaac.GetItemIdByName("Blaze")
local torrent = Isaac.GetItemIdByName("Torrent")

local TRACKED_HEALTH = {}
local TRACKED_MAX_HEALTH = {}

function mod:CheckHealth(player)
    if player:HasCollectible(overgrow) or player:HasCollectible(blaze) or player:HasCollectible(torrent) then
        local index = mod:GetPlayerIndex(player)
        local oldHealth = TRACKED_HEALTH[index]
        local oldMaxHealth = TRACKED_MAX_HEALTH[index]

        if oldHealth and oldMaxHealth and not (oldHealth == (player:GetHearts() + player:GetRottenHearts()) and oldMaxHealth == player:GetEffectiveMaxHearts()) then
            if player:HasCollectible(overgrow) then
                player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
            end
            if player:HasCollectible(blaze) then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            end
            if player:HasCollectible(torrent) then
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            end
            player:EvaluateItems()
        end

        TRACKED_HEALTH[index] = player:GetHearts() + player:GetRottenHearts()
        TRACKED_MAX_HEALTH[index] = player:GetEffectiveMaxHearts()
    end
end

function mod:ApplyBoost(player, cacheFlags)
    if player:GetHearts() <= (1/3 * player:GetEffectiveMaxHearts()) then
        local overgrowCount = player:GetCollectibleNum(overgrow)
        local blazeCount = player:GetCollectibleNum(blaze)
        local torrentCount = player:GetCollectibleNum(torrent)

        if overgrowCount > 0 then
            local multiplier = (4/3)^overgrowCount

            if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
                player.MoveSpeed = multiplier * player.MoveSpeed
            end

            if (cacheFlags & CacheFlag.CACHE_RANGE) == CacheFlag.CACHE_RANGE then
                player.TearRange = multiplier * player.TearRange
            end
        end

        if blazeCount > 0 then
            local multiplier = (4/3)^blazeCount

            if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
                player.Damage = multiplier * player.Damage
            end
        end

        if torrentCount > 0 then
            local multiplier = (4/3)^torrentCount

            if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
	            local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	            tearsPerSecond = multiplier * tearsPerSecond
	            player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CheckHealth)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoost)