local lifeOrb = Isaac.GetItemIdByName("Life Orb")

local lifeOrbMultiplier = 1.3

local MUST_TAKE_DAMAGE = {}

function mod:EvaluateCache(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(lifeOrb)
        local multiplierToAdd = lifeOrbMultiplier^itemCount

        player.Damage = player.Damage * (multiplierToAdd)
    end
end

function mod:PostUpdate()
    local function f(player)
        local itemCount = player:GetCollectibleNum(lifeOrb)
        local index = mod:GetPlayerIndex(player)

        if itemCount > 0 and MUST_TAKE_DAMAGE[index] then
            for _ = 1, itemCount - 1 do
                player:TakeDamage(0, DamageFlag.DAMAGE_FAKE, EntityRef(player), 0)
            end

            player:TakeDamage(itemCount, DamageFlag.DAMAGE_NO_PENALTIES | DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_INVINCIBLE, EntityRef(player), 0)
            MUST_TAKE_DAMAGE[index] = false
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:PostNewLevel()
    local function f(player)
        local playerType = player:GetPlayerType()
        local itemCount = player:GetCollectibleNum(lifeOrb)
        if itemCount > 0 and (playerType ~= PlayerType.PLAYER_THELOST and playerType ~= PlayerType.PLAYER_THELOST_B) then
            local index = mod:GetPlayerIndex(player)

            MUST_TAKE_DAMAGE[index] = true
        end
    end

    mod:DoForAllPlayers(f)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PostUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.PostNewLevel)