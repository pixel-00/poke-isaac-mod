local coconutWater = Isaac.GetItemIdByName("Coconut Water")

function mod:EvaluateCache(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(coconutWater)
    if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + (0.2 * itemCount)
    end
    if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
	    local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	    tearsPerSecond = tearsPerSecond + (0.5 * itemCount)
	    player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)