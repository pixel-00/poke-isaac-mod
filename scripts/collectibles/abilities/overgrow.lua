local overgrow = Isaac.GetItemIdByName("Overgrow")

function mod:ApplyBoost(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(overgrow)
    if (itemCount > 0) and (player:GetHearts() <= (1/3 * player:GetEffectiveMaxHearts())) then
        local multiplier = (4/3)^itemCount
        if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = multiplier * player.MoveSpeed
        end
        if (cacheFlags & CacheFlag.CACHE_RANGE) == CacheFlag.CACHE_RANGE then
            player.Range = multiplier * player.Range
        end
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoost)