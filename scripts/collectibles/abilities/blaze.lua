local blaze = Isaac.GetItemIdByName("Blaze")

function mod:ApplyBoost(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(blaze)
        if (itemCount > 0) and (player:GetHearts() <= (1/3 * player:GetEffectiveMaxHearts())) then
            local multiplier = (4/3)^itemCount
            player.Damage = multiplier * player.Damage
        end
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoost)