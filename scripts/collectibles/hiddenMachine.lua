local hiddenMachine = Isaac.GetItemIdByName("Hidden Machine")

function mod:EvaluateCache(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_FLYING) == CacheFlag.CACHE_FLYING then
        if player:HasCollectible(hiddenMachine) then
            player.CanFly = true
        end
    end
end

function mod:UseItem(item, rng, player, useFlags, activeSlot, varData)
    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_LEO, false, 1)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, hiddenMachine)