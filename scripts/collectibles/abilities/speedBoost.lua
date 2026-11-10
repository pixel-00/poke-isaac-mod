local speedBoost = Isaac.GetItemIdByName("Speed Boost")

local json = require("json")

function mod:StackSpeedBoost()
    local player = Isaac.GetPlayer()
    if player:HasCollectible(speedBoost) then
        local n = player:GetData().SpeedBoostStacks
        if n then
            player:GetData().SpeedBoostStacks = n + 1
        else
            player:GetData().SpeedBoostStacks = 1
        end
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
end

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(speedBoost)
    local stacks = player:GetData().SpeedBoostStacks
    if stacks then
        if itemCount > 0 and ((cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED) then
            local speedToAdd = 0.1 * stacks * itemCount
            player.MoveSpeed = player.MoveSpeed + speedToAdd
        end
    end
end

function mod:ResetSpeedBoostStacks()
    local player = Isaac.GetPlayer()
    player:GetData().SpeedBoostStacks = 0
end

function mod:SaveSpeedBoost(shouldSave)
    if shouldSave then
        local saveData = {}
        if mod:HasData() then
            local loadedData = json.decode(mod:LoadData())
            if type(loadedData) == "table" then
                saveData = loadedData
            end
        end
        local player = Isaac.GetPlayer()
        saveData.SPEED_BOOST_STACKS = player:GetData().SpeedBoostStacks
        mod:SaveData(json.encode(saveData))
    end
end

function mod:LoadSpeedBoost(continued)
    if continued and mod:HasData() then
        local saveData = {}
        local loadedData = json.decode(mod:LoadData())
        if type(loadedData) == "table" then
            saveData = loadedData
        end
        local player = Isaac.GetPlayer()
        if saveData.SPEED_BOOST_STACKS then
            player:GetData().SpeedBoostStacks = saveData.SPEED_BOOST_STACKS
        else
            player:GetData().SpeedBoostStacks = 0
        end
        if player:HasCollectible(speedBoost) then
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.StackSpeedBoost)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSpeedBoostStacks)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveSpeedBoost)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadSpeedBoost)