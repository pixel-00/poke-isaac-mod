local weakArmor = Isaac.GetItemIdByName("Weak Armor")

function mod:ActivateWeakArmor(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(weakArmor) then
        if not entity:GetData().weakArmorActive then
            entity:GetData().weakArmorActive = true
        else
            amount = amount + 1
        end
    end
end

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(weakArmor)
    if itemCount > 0 and ((cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED) and player:GetData().weakArmorActive then
        local speedToAdd = 0.3 * itemCount
        player.MoveSpeed = player.MoveSpeed + speedToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.ActivateWeakArmor)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)