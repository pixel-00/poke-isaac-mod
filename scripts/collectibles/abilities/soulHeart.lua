local soulHeart = Isaac.GetItemIdByName("Soul-Heart")

function mod:UpdateRecentDamage(entity, amount, damageFlags, source)
    if entity:IsActiveEnemy() then
        entity:GetData().SoulHeartAbilityMostRecentDamageSource = source
    end
end

function mod:ResetFireRate()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(soulHeart) then
        player:GetData().SoulHeartAbilityFireRateStack = 0
        player:EvaluateItems()
    end
end

function mod:UpdateStacks(entity)
    local source = entity:GetData().SoulHeartAbilityMostRecentDamageSource
    local player
    if source then
        -- check if the source is a player or spawned by a player
        if source.Type == EntityType.ENTITY_PLAYER then
            player = source.Entity
        else
            player = source.Entity.SpawnerEntity
            if not (player and player:ToPlayer()) then
                return
            end
        end
        if player:ToPlayer():HasCollectible(soulHeart) then
            local n = player:GetData().SoulHeartAbilityFireRateStack
            if n then
                player:GetData().SoulHeartAbilityFireRateStack = math.min(n + 1, 10)
            else
                player:GetData().SoulHeartAbilityFireRateStack = 1
            end
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end
end

function mod:ApplyFireRate(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
        local itemCount = player:GetCollectibleNum(soulHeart)
        local n = player:GetData().SoulHeartAbilityFireRateStack
        if itemCount > 0 and n then
	        local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	        tearsPerSecond = tearsPerSecond + ((0.5 * n)^itemCount)
	        player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
        end
	end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.UpdateRecentDamage)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.UpdateStacks)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ResetFireRate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyFireRate)