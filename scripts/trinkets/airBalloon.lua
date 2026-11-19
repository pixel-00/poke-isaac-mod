local airBalloon = Isaac.GetTrinketIdByName("Air Balloon")

function mod:EvaluateCache(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_FLYING) == CacheFlag.CACHE_FLYING then
        if player:HasTrinket(airBalloon) then
            player.CanFly = true
        end
    end
end

function mod:PopAirBalloon(entity, amount, damageFlags, source, countdownFrames)
    local player = entity:ToPlayer()
    if player and player:HasTrinket(airBalloon) then
        local trinketMultiplier = player:GetTrinketMultiplier(airBalloon)

        if trinketMultiplier <= 1 then
            player:TryRemoveTrinket(airBalloon)
            SFXManager():Play(SoundEffect.SOUND_RIB_DEFLECT)
            player:AddCacheFlags(CacheFlag.CACHE_FLYING)
            player:EvaluateItems()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PopAirBalloon)