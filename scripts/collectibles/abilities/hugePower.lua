local hugePower = Isaac.GetItemIdByName("Huge Power")

function mod:ApplyDamage(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local damageMultiplier = 2^player:GetCollectibleNum(hugePower)
        player.Damage = player.Damage * damageMultiplier
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)