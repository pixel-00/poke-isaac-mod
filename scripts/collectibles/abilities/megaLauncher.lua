local megaLauncher = Isaac.GetItemIdByName("Mega Launcher")

function mod:ApplyDamage(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local damageMultiplier = 1.16^player:GetCollectibleNum(megaLauncher)
        player.Damage = player.Damage * damageMultiplier
    end
end

function mod:TearSize(tear)
	local player = tear.SpawnerEntity
	if player and player:ToPlayer() and player:ToPlayer():HasCollectible(megaLauncher) then
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_PIERCING
		tear.Scale = math.min(3 * tear.Scale, math.max(3, tear.Scale)) -- triple it. if it goes above 3, then set it to 3 unless it's already above 3, in which case leave it
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.TearSize)