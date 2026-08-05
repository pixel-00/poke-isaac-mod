local temperTantrum = Isaac.GetItemIdByName("Temper Tantrum")

local temperTantrumStage = 0

function mod:SetMissFlag(tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if player then
        tear:GetData().missed = true
    end
end

function mod:TearHitEnemy(tear, collider, low)
    local player = tear.SpawnerEntity:ToPlayer()
    if player and collider:IsEnemy() then
        tear:GetData().missed = false
        temperTantrumStage = math.max(temperTantrumStage - 2, 0)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

function mod:UpdateDamageMultiplier(tear)
    local player = tear.SpawnerEntity:ToPlayer()
    if player and tear:IsDead() and tear:GetData().missed then
        temperTantrumStage = math.min(temperTantrumStage + 1, 6)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end
end

function mod:ApplyDamage(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(temperTantrum)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local temperTantrumMultiplier = 1 + (temperTantrumStage * itemCount / 2)
        player.Damage = player.Damage * temperTantrumMultiplier
    end
end

function mod:ResetTemperTantrum(isContinued)
    if not isContinued then
        temperTantrumStage = 0
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, mod.SetMissFlag)
mod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, mod.TearHitEnemy)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.UpdateDamageMultiplier)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyDamage)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.ResetTemperTantrum)