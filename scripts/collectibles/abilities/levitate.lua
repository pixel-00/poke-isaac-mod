local levitate = Isaac.GetItemIdByName("Levitate")

function mod:EvaluateCache(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_FLYING) == CacheFlag.CACHE_FLYING then
        if player:HasCollectible(levitate) then
            player.CanFly = true
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)