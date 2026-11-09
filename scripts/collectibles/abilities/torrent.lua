local torrent = Isaac.GetItemIdByName("Torrent")

function mod:ApplyBoost(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
        local itemCount = player:GetCollectibleNum(torrent)
        if (itemCount > 0) and (player:GetHearts() <= (1/3 * player:GetEffectiveMaxHearts())) then
            local multiplier = (4/3)^itemCount
	        local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	        tearsPerSecond = multiplier * tearsPerSecond
	        player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
        end
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoost)