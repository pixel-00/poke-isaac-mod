local lazyBones = Isaac.GetItemIdByName("Lazy Bones")

local BONE_HEARTS = {}
local BROKEN_BONE_HEARTS = {}

-- needs rework
function mod:CheckBones(player)
    local index = mod:GetPlayerIndex(player)
    local boneHearts = BONE_HEARTS[index]
    if boneHearts and player:GetBoneHearts() ~= boneHearts then
        local extraBrokenBoneHearts = math.max(boneHearts - player:GetBoneHearts(), 0)
        BONE_HEARTS[index] = player:GetBoneHearts()
        if player:HasCollectible(lazyBones) then
            BROKEN_BONE_HEARTS[index] = BROKEN_BONE_HEARTS[index] + extraBrokenBoneHearts
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
    end
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(lazyBones)
    local index = mod:GetPlayerIndex(player)

    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local lazyBonesMultiplier = 1 + (0.15 * BONE_HEARTS[index] * itemCount)
        player.Damage = player.Damage * lazyBonesMultiplier
    end
    if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
        local lazyBonesSpeedUp = 0.1 * BROKEN_BONE_HEARTS[index]
        local lazyBonesSpeedDown = 0.1 * BONE_HEARTS[index] * math.min(itemCount, 1)
        player.MoveSpeed = player.MoveSpeed + (lazyBonesSpeedUp - lazyBonesSpeedDown)
    end
end

function mod:ResetLazyBones(isContinued)
    if not isContinued then
        local function f(player)
            local index = mod:GetPlayerIndex(player)

            BONE_HEARTS[index] = 0
            BROKEN_BONE_HEARTS[index] = 0
        end

        mod:DoForAllPlayers(f)
    end
end

function mod:GiveBoneHeart(player)
    local queued = player.QueuedItem
    local data = player:GetData()
    if queued.Item and queued.Item:IsCollectible() and queued.Item.ID == lazyBones and not queued.Touched then
        data.numLazyBones = player:GetCollectibleNum(lazyBones)
    end
    if data.numLazyBones and data.numLazyBones < player:GetCollectibleNum(lazyBones) then
        player:AddBoneHearts(1)
        data.numLazyBones = nil
    end
end


mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CheckBones)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.ResetLazyBones)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveBoneHeart)
-- load and save