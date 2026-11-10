local overgrow = Isaac.GetItemIdByName("Overgrow")

function mod:CheckHealth(player)
    if player:HasCollectible(overgrow) then
        local oldHealth = player:GetData().AbilityHealth
        local oldMaxHealth = player:GetData().AbilityMaxHealth
        if oldHealth and oldMaxHealth and not (oldHealth == (player:GetHearts() + player:GetRottenHearts()) and oldMaxHealth == player:GetEffectiveMaxHearts()) then
            print("overgrow health changed")
            player:AddCacheFlags(CacheFlag.CACHE_SPEED | CacheFlag.CACHE_RANGE)
            player:EvaluateItems()
        end
        player:GetData().AbilityHealth = player:GetHearts() + player:GetRottenHearts()
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