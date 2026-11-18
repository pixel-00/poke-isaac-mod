local soulHeart = Isaac.GetItemIdByName("Soul-Heart")

local SOUL_HEART_STACK = {}

function mod:ResetFireRate()
    local function f(player)
        local index = mod:GetPlayerIndex()

        if SOUL_HEART_STACK[index] ~= 0 then
            SOUL_HEART_STACK[index] = 0
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
    end

    mod:DoForAllPlayers(f)
end

function mod:UpdateStacks(entity)
    if entity:IsActiveEnemy(true) then
        local function f(player)
            if player:HasCollectible(soulHeart) then
                local index = mod:GetPlayerIndex(player)
                local n = SOUL_HEART_STACK[index]

                if n then
                    SOUL_HEART_STACK[index] = math.min(n + 1, 10)
                else
                    SOUL_HEART_STACK[index] = 1
                end

                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
                player:EvaluateItems()
            end
        end

        mod:DoForAllPlayers(f)
    end
end

function mod:ApplyFireRate(player, cacheFlags)
    if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
        local itemCount = player:GetCollectibleNum(soulHeart)
        local index = mod:GetPlayerIndex(player)
        local n = SOUL_HEART_STACK[index]

        if itemCount > 0 and n then
	        local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	        tearsPerSecond = tearsPerSecond + ((0.5 * n)^itemCount)
	        player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
        end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.UpdateStacks)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ResetFireRate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyFireRate)