local technician = Isaac.GetItemIdByName("technician")

function mod:ApplyDamage(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(technician)
    if itemCount > 0 and (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local damageToAdd = math.max(5 - player.Damage, 0) * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)