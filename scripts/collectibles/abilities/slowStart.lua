local slowStart = Isaac.GetItemIdByName("Slow Start")

local json = require("json")

local saveData = {}

function mod:ResetSlowStart()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(slowStart) then
        player:GetData().SlowStartAbilityRooms = 0
    end
end

function mod:CountRoomClear()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(slowStart) then
        local n = player:GetData().SlowStartAbilityRooms
        if n then
            player:GetData().SlowStartAbilityRooms = n + 1
            if n >= 4 then
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:EvaluateItems()
            end
        else
            player:GetData().SlowStartAbilityRooms = 1
        end
    end
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(slowStart)
    local n = player:GetData().SlowStartAbilityRooms
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

function mod:SaveClearCount(shouldSave)
    if shouldSave then
        if mod:HasData() then
            saveData = json.decode(mod:LoadData())
        end
        local player = Isaac.GetPlayer()
        saveData.SLOW_START_COUNT = player:GetData().SlowStartAbilityRooms
        mod:SaveData(json.encode(saveData))
    end
end

function mod:LoadClearCount(continued)
    if continued and mod:HasData() then
        local loadedData = json.decode(mod:LoadData())
        if type(loadedData) == "table" then
            saveData = loadedData
        else
            savedata = {}
        end
        local player = Isaac.GetPlayer()
        if saveData.SLOW_START_COUNT then
            player:GetData().SlowStartAbilityRooms = saveData.SLOW_START_COUNT
        else
            player:GetData().SlowStartAbilityRooms = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSlowStart)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.CountRoomClear)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveClearCount)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadHiddenWisps)