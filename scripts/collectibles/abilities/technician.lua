local technician = Isaac.GetItemIdByName("technician")

function mod:ApplyDamage(player, cacheFlags)
    if player:HasCollectible(technician) and (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        player.Damage = math.max(player.Damage, 5)
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)