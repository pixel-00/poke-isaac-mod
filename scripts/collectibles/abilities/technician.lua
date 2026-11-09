local technician = Isaac.GetItemIdByName("Technician")

function mod:TechnicianDamage(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(technician)
    if itemCount > 0 and (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        player.Damage = math.min(itemCount, 1) * math.max(player.Damage, 5)
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.TechnicianDamage)