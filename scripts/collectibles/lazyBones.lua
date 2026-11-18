local lazyBones = Isaac.GetItemIdByName("Lazy Bones")

function mod:ApplyStats(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(lazyBones)

    if itemCount > 0 then
        local numBoneHearts = player:GetBoneHearts()

        if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
            local lazyBonesMultiplier = 1 + (0.15 * numBoneHearts * itemCount)

            player.Damage = player.Damage * lazyBonesMultiplier
        end

        if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
            local lazyBonesSpeedDown = 0

            if numBoneHearts <= 2 then
                lazyBonesSpeedDown = 0.1 * numBoneHearts * math.min(itemCount, 1)
            else
                lazyBonesSpeedDown = 0.05 * numBoneHearts * math.min(itemCount, 1) + 0.1
            end

            player.MoveSpeed = player.MoveSpeed - lazyBonesSpeedDown
        end
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
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
        data.numLazyBones = nil
    end
end

function mod:CheckStats(entity, amount, damageFlags, source, countdownFrames)
    local player = entity:ToPlayer()

    if player and player:HasCollectible(lazyBones) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.GiveBoneHeart)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.CheckStats)