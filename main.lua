local mod = RegisterMod("My Mod", 1)
local lifeOrb = Isaac.GetItemIdByName("Life Orb")
local lifeOrbMultiplier = 1.3
local mustTakeLifeOrbDamage = false


function mod:EvaluateCache(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(lifeOrb)
        local multiplierToAdd = lifeOrbMultiplier^itemCount
        player.Damage = player.Damage * multiplierToAdd
    end
end

function mod:PostUpdate()
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(lifeOrb)
    if itemCount > 0 and mustTakeLifeOrbDamage then
        player:TakeDamage(itemCount, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS, EntityRef(player), 0)
        mustTakeLifeOrbDamage = false
    end
end

function mod:PostNewLevel()
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(lifeOrb)
    if itemCount > 0 then
        mustTakeLifeOrbDamage = true
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.PostNewLevel)