local slowStart = Isaac.GetItemIdByName("Slow Start")

local json = require("json")

local SLOW_START_ROOMS = {}

function mod:ResetSlowStart()
    local function f(player)
        if player:HasCollectible(slowStart) then
            local index = mod:GetPlayerIndex(player)
            SLOW_START_ROOMS[index] = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:CountRoomClear()
    local function f(player)
        if player:HasCollectible(slowStart) then
            local index = mod:GetPlayerIndex(player)
            local n = SLOW_START_ROOMS[index]
            if n then
                SLOW_START_ROOMS[index] = n + 1
                if n >= 4 then
                    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
                    player:EvaluateItems()
                end
            else
                SLOW_START_ROOMS[index] = 1
            end
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(slowStart)
    local index = mod:GetPlayerIndex(player)
    local n = SLOW_START_ROOMS[index]
    if itemCount > 0 then
        local applyDebuff = 1
        if n then
            applyDebuff = (n < 5) and 1 or 0
        end
        local multiplier = 0.5^(itemCount * applyDebuff)
        if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed * multiplier
        end
        if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
            local damageToAdd = 2 * itemCount
            player.Damage = (player.Damage + damageToAdd) * multiplier
        end
    end
end

function mod:SaveSlowStart(shouldSave)
    if shouldSave then
        local function f(player)
            local index = mod:GetPlayerIndex(player)

            mod:SavePlayerData(player, "Slow Start", SLOW_START_ROOMS[index])
        end

        mod:DoForAllPlayers(f)
    end
end

function mod:LoadSlowStart(continued)
    if continued then
        local function f(player)
            local playerData = mod:LoadPlayerData(player, "Slow Start")

            if not playerData then
                playerData = 0
            end

            local index = mod:GetPlayerIndex(player)

            SLOW_START_ROOMS[index] = playerData

            if player:HasCollectible(slowStart) then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
                player:EvaluateItems()
            end
        end

        mod:DoForAllPlayers(f)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSlowStart)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.CountRoomClear)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveSlowStart)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadSlowStart)