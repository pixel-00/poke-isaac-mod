local beastBoost = Isaac.GetItemIdByName("Beast Boost")

local PLAYER_BEAST_BOOSTS = {}

local function BeastBoost(player, rng)
    local index = mod:GetPlayerIndex(player)
    if type(PLAYER_BEAST_BOOSTS[index]) ~= "table" then
        PLAYER_BEAST_BOOSTS[index] = {Damage = 0, Tears = 0, Speed = 0, Range = 0}
    end
    local boost = rng:RandomInt(4)
    if boost == 1 then
        PLAYER_BEAST_BOOSTS[index].Damage = PLAYER_BEAST_BOOSTS[index].Damage + 1
        return CacheFlag.CACHE_DAMAGE
    elseif boost == 2 then
        PLAYER_BEAST_BOOSTS[index].Tears = PLAYER_BEAST_BOOSTS[index].Tears + 1
        return CacheFlag.CACHE_FIREDELAY
    elseif boost == 3 and player.MoveSpeed < 2 then
        PLAYER_BEAST_BOOSTS[index].Speed = PLAYER_BEAST_BOOSTS[index].Speed + 1
        return CacheFlag.CACHE_SPEED
    else
        PLAYER_BEAST_BOOSTS[index].Range = PLAYER_BEAST_BOOSTS[index].Range + 1
        return CacheFlag.CACHE_RANGE
    end
end

function mod:ApplyBoosts(player, cacheFlags)
    local index = mod:GetPlayerIndex(player)
    local boosts = PLAYER_BEAST_BOOSTS[index]

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

function mod:BossReward(rng, spawnPosition)
    local roomType = Game():GetRoom():GetType()

    if roomType == RoomType.ROOM_BOSS then
        local function f(player)
            if player:HasCollectible(beastBoost) then
                local cacheFlag = BeastBoost(player, rng)
                player:AddCacheFlags(cacheFlag)
                player:EvaluateItems()
                player:AnimateHappy()
            end
        end

        mod:DoForAllPlayers(f)
    end
end

function mod:SaveBeastBoost(shouldSave)
    if shouldSave then
        local saveData = mod:GetSaveData()

        local function f(player)
            local index = mod:GetPlayerIndex(player)

            mod:AddPlayerData(player, "Beast Boost", PLAYER_BEAST_BOOSTS[index], saveData)
        end

        mod:DoForAllPlayers(f)
        mod:EncodeAndSaveData(saveData)
    end
end

function mod:LoadBeastBoost(continued)
    if continued then
        local function f(player)
            local playerData = mod:LoadPlayerData(player, "Beast Boost")

            if type(playerData) ~= "table" then
                playerData = {Damage = 0, Tears = 0, Speed = 0, Range = 0}
            end

            local index = mod:GetPlayerIndex(player)

            PLAYER_BEAST_BOOSTS[index] = playerData

            if player:HasCollectible(beastBoost) then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
                player:EvaluateItems()
            end
        end

        mod:DoForAllPlayers(f)
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoosts)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.BossReward)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveBeastBoost)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadBeastBoost)