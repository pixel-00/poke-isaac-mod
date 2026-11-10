local weakArmor = Isaac.GetItemIdByName("Weak Armor")

local preventInfiniteLoop = false

function mod:ActivateWeakArmor(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER then
        local player = entity:ToPlayer()
        if player:HasCollectible(weakArmor) then
            if not player:GetData().weakArmorActive then
                player:GetData().weakArmorActive = true
            elseif not preventInfiniteLoop then
                preventInfiniteLoop = true
                player:TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 0)
                preventInfiniteLoop = false
            end
            player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
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