local trafficCone = Isaac.GetItemIdByName("Traffic Cone")

function mod:GiveStats(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_LUCK) == CacheFlag.CACHE_LUCK then
        local itemCount = player:GetCollectibleNum(trafficCone)
        player.Luck = player.Luck + (itemCount * 2)
    end
end

function mod:BlockFallingProjectiles(projectile, collider, _)
    if collider.Type == EntityType.ENTITY_PLAYER and collider:ToPlayer():HasCollectible(trafficCone) then
        if projectile.Variant == ProjectileVariant.PROJECTILE_GRID or projectile.Variant == ProjectileVariant.PROJECTILE_ROCK or projectile.Variant == ProjectileVariant.PROJECTILE_BONE then
            return false
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveStats)
mod:AddCallback(ModCallbacks.MC_PRE_PROJECTILE_COLLISION, mod.BlockFallingProjectiles)