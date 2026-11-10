local levitate = Isaac.GetItemIdByName("Levitate")

function mod:EvaluateCache(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_FLYING) == CacheFlag.CACHE_FLYING then
        if player:HasCollectible(levitate) then
            player.CanFly = true
        end
    end
end

function mod:BlockGroundDamage(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(levitate) then
        print(source.Type)
        print(source.Variant)
        if source.Type == EntityType.ENTITY_EFFECT and (source.Variant == EffectVariant.SHOCKWAVE or source.Variant == EffectVariant.SHOCKWAVE_DIRECTIONAL or source.Variant == EffectVariant.CRACKWAVE or source.Variant == EffectVariant.SHOCKWAVE_RANDOM or source.Variant == EffectVariant.BIG_CRACKWAVE or source.Variant == EffectVariant.MOTHER_SHOCKWAVE) then
            return false
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.BlockGroundDamage)