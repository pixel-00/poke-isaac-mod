local blaze = Isaac.GetItemIdByName("Blaze")

function mod:CheckHealth(player)
    if player:HasCollectible(blaze) then
        local oldHealth = player:GetData().AbilityHealth
        local oldMaxHealth = player:GetData().AbilityMaxHealth
        if oldHealth and oldMaxHealth and not (oldHealth == (player:GetHearts() + player:GetRottenHearts()) and oldMaxHealth == player:GetEffectiveMaxHearts()) then
            print("blaze health changed")
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
        player:GetData().AbilityHealth = player:GetHearts() + player:GetRottenHearts()
        player:GetData().AbilityMaxHealth = player:GetEffectiveMaxHearts()
    end
end

function mod:ApplyBoost(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(blaze)
    if (itemCount > 0) and (player:GetHearts() <= (1/3 * player:GetEffectiveMaxHearts())) then
        local multiplier = (4/3)^itemCount
        if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
            player.Damage = multiplier * player.Damage
        end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CheckHealth)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoost)