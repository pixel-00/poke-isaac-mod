local flashFire = Isaac.GetItemIdByName("Flash Fire")

local FLASH_FIRE_TIME = 9

local function IsFire(flags, entityRef)
    return (entityRef.Variant == ProjectileVariant.PROJECTILE_FIRE)
    or (entityRef.Variant == ProjectileVariant.PROJECTILE_LAVA)
    or (entityRef.SpawnerType == EntityType.ENTITY_FIREPLACE)
    or (flags & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE)
    or (flags & DamageFlag.DAMAGE_EXPLOSION == DamageFlag.DAMAGE_EXPLOSION)
end

function mod:PreventFireDamage(entity, amount, flags, source)
    if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(flashFire) then
        if IsFire(flags, source) then
            player:GetData().flashFireCountdown = FLASH_FIRE_TIME
            return false
        end
    end
end

function mod:UpdateFlashFire(player)
    local t = player:GetData().flashFireCountdown
    if t and t > 0 then
        local tNormal = t / FLASH_FIRE_TIME
        local R = 1
        local G = math.min(1, 0.3 + 0.7 * 4 * (1 - tNormal))
        local B = math.min(1, 4 * (1 - tNormal))
        player:SetColor(Color(R, G, B), 1, 1, false, false)
        player:GetData().flashFireCountdown = math.max(t - (1/30), 0)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateFlashFire)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveDamage)