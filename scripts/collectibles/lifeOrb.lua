local lifeOrb = Isaac.GetItemIdByName("Life Orb")
local lifeOrbMultiplier = 1.3
local mustTakeLifeOrbDamage = false

function mod:EvaluateCache(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(lifeOrb)
        local multiplierToAdd = lifeOrbMultiplier^itemCount
        player.Damage = player.Damage * (multiplierToAdd)
    end
end

function mod:PostUpdate()
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(lifeOrb)
    if itemCount > 0 and mustTakeLifeOrbDamage then
        local i = itemCount - 1
        while i > 0 do
            player:TakeDamage(0, DamageFlag.DAMAGE_FAKE, EntityRef(player), 0)
            i = i - 1
        end
        player:TakeDamage(itemCount, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 0)
        mustTakeLifeOrbDamage = false
    end
end

function mod:PostNewLevel()
    local player = Isaac.GetPlayer(0)
    local playerType = player:GetPlayerType()
    local itemCount = player:GetCollectibleNum(lifeOrb)
    if itemCount > 0 and (playerType ~= PlayerType.PLAYER_THELOST and playerType ~= PlayerType.PLAYER_THELOST_B) then
        mustTakeLifeOrbDamage = true
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.PostNewLevel)