local flashFire = Isaac.GetItemIdByName("Flash Fire")

local FLASH_FIRE_TIME = 9

function mod:PreventFireDamage(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(flashFire) then
        if (flags & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE) or (flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION) then
            if player:GetData().FlashFireAvailable then
                player:GetData().flashFireCountdown = FLASH_FIRE_TIME
                player:GetData().FlashFireAvailable = false
            end
            return false
        end
    end
end

function mod:ResetFlashFire()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(flashFire) then
        player:GetData().FlashFireAvailable = true
    end
end

function mod:UpdateFlashFire(player)
    local t = player:GetData().flashFireCountdown
    if t > 0 then
        player:GetData().flashFireCountdown = math.max(t - (1/30), 0)
        player:EvaluateItems()
    end
end

function mod:GiveDamage(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(flashFire)
    local t = player:GetData().flashFireCountdown
    if itemCount > 0 and t and (cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE) then
        local damageMultiplier = (100 - (7 * t))/(100 - (10 * t))^math.min(itemCount, 1)
        player.Damage = player.Damage * damageMultiplier
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.PreventFireDamage)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ResetFlashFire)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateFlashFire)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveDamage)