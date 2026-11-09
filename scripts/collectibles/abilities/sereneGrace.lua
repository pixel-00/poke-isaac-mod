local sereneGrace = Isaac.GetItemIdByName("Serene Grace")

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(sereneGrace)
    if itemCount > 0 and ((cacheFlags & CacheFlag.CACHE_LUCK) == CacheFlag.CACHE_LUCK) then
        local luckMultiplier = 2^itemCount
        player.Luck = math.abs(player.Luck*luckMultiplier)
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyLuck)