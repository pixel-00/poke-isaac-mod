local flashFire = Isaac.GetItemIdByName("Flash Fire")

local FLASH_FIRE_TIME = 9

local FLASH_FIRE_COUNTDOWN = {}

local function IsFire(collider)
    return (collider.Type == EntityType.ENTITY_PROJECTILE and
    ((collider.Variant == ProjectileVariant.PROJECTILE_FIRE)
    or (collider.Variant == ProjectileVariant.PROJECTILE_LAVA)
    or (collider.SpawnerType == EntityType.ENTITY_FIREPLACE)))
    or collider.Type == EntityType.ENTITY_FIREPLACE
end

function mod:PreventFireDamage(player, collider, _)
    if player:HasCollectible(flashFire) then
        if IsFire(collider) then
            local index = mod:GetPlayerIndex(player)
            FLASH_FIRE_COUNTDOWN[index] = FLASH_FIRE_TIME
            return false
        end
    end
end

function mod:UpdateFlashFire(player)
    local index = mod:GetPlayerIndex(player)
    local t = FLASH_FIRE_COUNTDOWN[index]

    if t and t > 0 then
        local tNormal = t / FLASH_FIRE_TIME
        local R = 1
        local G = math.min(1, 0.3 + 0.7 * 4 * (1 - tNormal))
        local B = math.min(1, 4 * (1 - tNormal))

        player:SetColor(Color(R, G, B), 1, 1, false, false)
        FLASH_FIRE_COUNTDOWN[index] = math.max(t - (1/30), 0)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

function mod:GiveDamage(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(flashFire)
    local t = FLASH_FIRE_COUNTDOWN[index]

    if itemCount > 0 and t and (cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE) then
        local damageMultiplier = (100 - (7 * t))/(100 - (10 * t))^math.min(itemCount, 1)

        player.Damage = player.Damage * damageMultiplier
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, mod.PreventFireDamage)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.UpdateFlashFire)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.GiveDamage)