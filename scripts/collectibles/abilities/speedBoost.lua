local speedBoost = Isaac.GetItemIdByName("Speed Boost")

local SPEED_BOOST_STACKS = {}

function mod:StackSpeedBoost()
    local function f(player)
        if player:HasCollectible(speedBoost) then
            local index = mod:GetPlayerIndex(player)
            local stacks = SPEED_BOOST_STACKS[index]

            SPEED_BOOST_STACKS[index] = (stacks or 0) + 1
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:ApplySpeed(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(speedBoost)
    local index = mod:GetPlayerIndex(player)
    local stacks = SPEED_BOOST_STACKS[index]

    if stacks then
        if itemCount > 0 and ((cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED) then
            local speedToAdd = 0.1 * stacks * itemCount
            player.MoveSpeed = player.MoveSpeed + speedToAdd
        end
    end
end

function mod:ResetSpeedBoostStacks()
    local function f(player)
        if player:HasCollectible(speedBoost) then
            local index = mod:GetPlayerIndex(player)
            SPEED_BOOST_STACKS[index] = 0
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:SaveSpeedBoost(shouldSave)
    if shouldSave then
        local function f(player)
            local index = mod:GetPlayerIndex(player)

            mod:SavePlayerData(player, "Speed Boost", SPEED_BOOST_STACKS[index])
        end

        mod:DoForAllPlayers(f)
    end
end

function mod:LoadSpeedBoost(continued)
    if continued then
        local function f(player)
            local playerData = mod:LoadPlayerData(player, "Speed Boost")

            if not playerData then
                playerData = 0
            end

            local index = mod:GetPlayerIndex(player)

            SPEED_BOOST_STACKS[index] = playerData

            if player:HasCollectible(speedBoost) then
                player:AddCacheFlags(CacheFlag.CACHE_SPEED)
                player:EvaluateItems()
            end
        end

        mod:DoForAllPlayers(f)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.StackSpeedBoost)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplySpeed)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ResetSpeedBoostStacks)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveSpeedBoost)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadSpeedBoost)