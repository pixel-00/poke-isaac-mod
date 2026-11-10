local overgrow = Isaac.GetItemIdByName("Overgrow")

function mod:CheckHealth(player)
    print("check health called")
    if player:HasCollectible(overgrow) then
        local oldHealth = player:GetData().AbilityHealth
        local maxHealth = player:GetData().AbilityMaxHealth
        print("checking health")
        if oldHealth and maxHealth and not (oldHealth == player:GetHearts() and maxHealth == player:GetEffectiveMaxHearts()) then
            print("health changed")
            player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
            player:EvaluateItems()
        end
        player:GetData().AbilityHealth = player:GetHearts()
        player:GetData().AbilityMaxHealth = player:GetEffectiveMaxHearts()
    end
end

function mod:ApplyBoost(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(overgrow)
    if (itemCount > 0) and (player:GetHearts() <= (1/3 * player:GetEffectiveMaxHearts())) then
        local multiplier = (4/3)^itemCount
        if (cacheFlags & CacheFlag.CACHE_SPEED) == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = multiplier * player.MoveSpeed
        end
        if (cacheFlags & CacheFlag.CACHE_RANGE) == CacheFlag.CACHE_RANGE then
            player.TearRange = multiplier * player.TearRange
        end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CheckHealth)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoost)