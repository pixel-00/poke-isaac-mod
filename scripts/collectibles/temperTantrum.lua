local temperTantrum = Isaac.GetItemIdByName("Temper Tantrum")

local TEMPER_TANTRUM_STAGE = {}

function mod:SetMissFlag(tear)
    if tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer() and tear.SpawnerEntity:ToPlayer():HasCollectible(temperTantrum) then
        tear:GetData().TEMPER_TANTRUM_MISSED = true
    end
end

function mod:TearHitEnemy(tear, collider, low)
    if tear.SpawnerEntity then
        local player = tear.SpawnerEntity:ToPlayer()
        if player and player:HasCollectible(temperTantrum) and collider:IsEnemy() then
            local index = mod:GetPlayerIndex(player)

            tear:GetData().TEMPER_TANTRUM_MISSED = false
            TEMPER_TANTRUM_STAGE[index] = math.max(TEMPER_TANTRUM_STAGE[index] - 2, 0)
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
end

function mod:UpdateDamageMultiplier(tear)
    if tear:IsDead() then
        local spawner = tear.SpawnerEntity
        if spawner then
            local player = spawner:ToPlayer()
            if player and player:HasCollectible(temperTantrum) and tear:GetData().TEMPER_TANTRUM_MISSED then
                local index = mod:GetPlayerIndex(player)

                TEMPER_TANTRUM_STAGE[index] = math.min(TEMPER_TANTRUM_STAGE[index] + 1, 6)
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end
    end
end

function mod:ApplyDamage(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(temperTantrum)
    if itemCount > 0 and (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local index = mod:GetPlayerIndex(player)
        local temperTantrumMultiplier = 1 + (TEMPER_TANTRUM_STAGE[index] * itemCount / 3)
        player.Damage = player.Damage * temperTantrumMultiplier
    end
end

function mod:ResetTemperTantrum(isContinued)
    if not isContinued then
        local function f(player)
            TEMPER_TANTRUM_STAGE[index] = 0
        end

        mod:DoForAllPlayers(f)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.SetMissFlag)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.TearHitEnemy)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.UpdateDamageMultiplier)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.ResetTemperTantrum)