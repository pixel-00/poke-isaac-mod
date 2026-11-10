local weakArmor = Isaac.GetItemIdByName("Weak Armor")

function mod:ActivateWeakArmor(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(weakArmor) then
        if not entity:GetData().weakArmorActive then
            entity:GetData().weakArmorActive = true
        else
            return amount + 1
        end
        entity:ToPlayer():AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
        entity:ToPlayer():EvaluateItems()
    end
end

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(weakArmor)
    if itemCount > 0 and player:GetData().weakArmorActive then
        if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
            local speedToAdd = 0.3 * itemCount
            player.MoveSpeed = player.MoveSpeed + speedToAdd
        end
        if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
            local multiplier = (3/2)^itemCount
	        local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	        tearsPerSecond = multiplier * tearsPerSecond
	        player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ActivateWeakArmor)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)