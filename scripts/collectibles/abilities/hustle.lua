local hustle = Isaac.GetItemIdByName("Hustle")

function mod:ApplyDamage(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(hustle)
        if itemCount > 0 then
            local multiplier = (3/2)^itemCount
            player.Damage = multiplier * player.Damage
        end
	end
end

function mod:RandomizeDirection(tear)
	local player = tear.SpawnerEntity
	if player and player:ToPlayer() and player:ToPlayer():HasCollectible(hustle) then
        local luck = player:ToPlayer().Luck
        local radius = 45 * (1 - (luck / 15))^3
		tear.Velocity = tear.Velocity:Rotated(math.random(-radius, radius))
	end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.RandomizeDirection)
