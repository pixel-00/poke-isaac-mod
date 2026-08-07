local lazyBones = Isaac.GetItemIdByName("Lazy Bones")

local boneHearts = 0
local brokenBoneHearts = 0
local lazyBonesSpeedUp = 0.1 * brokenBoneHearts

function mod:CheckBones(player)
    if player:HasCollectible(lazyBones) and player:GetBoneHearts() ~= boneHearts then
        brokenBoneHearts = brokenBoneHearts + math.max(boneHearts - player:GetBoneHearts(), 0)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
    boneHearts = player:GetBoneHearts()
end

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(lazyBones)
    if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
        local lazyBonesMultiplier = 1 + (0.15 * boneHearts * itemCount)
        player.Damage = player.Damage * lazyBonesMultiplier
    end
    if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
        lazyBonesSpeedUp = 0.1 * brokenBoneHearts
        local lazyBonesSpeedDown = 0.1 * boneHearts * math.min(itemCount, 1)
        player.MoveSpeed = player.MoveSpeed + (lazyBonesSpeedUp - lazyBonesSpeedDown)
    end
end

function mod:ResetLazyBones(isContinued)
    if not isContinued then
        boneHearts = 0
        brokenBoneHearts = 0
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CheckBones)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.ResetLazyBones)