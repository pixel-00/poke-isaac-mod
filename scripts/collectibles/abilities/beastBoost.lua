local beastBoost = Isaac.GetItemIdByName("Beast Boost")

-- 1 = damage, 2 = fire rate, 3 = speed, 4 = range
-- if at speed cap, 3 = range
local function BeastBoost(player)
    if not player:GetData().BeastBoostTable then
        player:GetData().BeastBoostTable = {Damage = 0, Tears = 0, Speed = 0, Range = 0}
    end
    local playerBoosts = player:GetData().BeastBoostTable
    local boost = math.random(4)
    if boost == 1 then
        playerBoosts.Damage = playerBoosts.Damage + 1
        return CacheFlag.CACHE_DAMAGE
    elseif boost == 2 then
        playerBoosts.Tears = playerBoosts.Tears + 1
        return CacheFlag.CACHE_FIREDELAY
    elseif boost == 3 and player.MoveSpeed < 2 then
        playerBoosts.Speed = playerBoosts.Speed + 1
        return CacheFlag.CACHE_SPEED
    else
        playerBoosts.Range = playerBoosts.Range + 1
        return CacheFlag.CACHE_RANGE
    end
end

function mod:ApplyBoosts(player, cacheFlags)
    local boosts = player:GetData().BeastBoostTable
    if boosts then
        if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
            local damageToAdd = boosts.Damage
            player.Damage = player.Damage + damageToAdd
        end
        if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
            local tearsToAdd = 0.5 * boosts.Tears
	        local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	        tearsPerSecond = tearsPerSecond + tearsToAdd
	        player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
        end
        if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
            local speedToAdd = 0.2 * boosts.Speed
            player.MoveSpeed = player.MoveSpeed + speedToAdd
        end
        if (cacheFlags & CacheFlag.CACHE_RANGE) == CacheFlag.CACHE_RANGE then
            local rangeToAdd = 40 * 2.5 * boosts.Range
            player.TearRange = player.TearRange + rangeToAdd
        end
    end
end

function mod:BossReward()
    local player = Isaac.GetPlayer(0)
    local roomType = Game():GetRoom():GetType()
    if roomType == RoomType.ROOM_BOSS and player:HasCollectible(beastBoost) then
        local cacheFlag = BeastBoost(player)
        player:AddCacheFlags(cacheFlag)
        player:EvaluateItems()
        player:AnimateHappy()
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoosts)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.BossReward)