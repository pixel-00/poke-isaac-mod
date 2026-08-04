local trafficCone = Isaac.GetItemIdByName("Traffic Cone")

function mod:GiveStats(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_LUCK) == CacheFlag.CACHE_LUCK then
        local itemCount = player:GetCollectibleNum(trafficCone)
        player.Luck = player.Luck + (itemCount * 2)
    end
end

function mod:BlockFallingProjectiles(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(trafficCone) then
        if source.Type == EntityType.ENTITY_PROJECTILE and (source.Entity.Variant == ProjectileVariant.PROJECTILE_GRID or source.Entity.Variant == ProjectileVariant.PROJECTILE_ROCK or source.Entity.Variant == ProjectileVariant.PROJECTILE_BONE) then
            return false
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveStats)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.BlockFallingProjectiles)