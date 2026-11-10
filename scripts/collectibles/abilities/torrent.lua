local torrent = Isaac.GetItemIdByName("Torrent")

function mod:CheckHealth(player)
    if player:HasCollectible(torrent) then
        local oldHealth = player:GetData().AbilityHealth
        local oldMaxHealth = player:GetData().AbilityMaxHealth
        if oldHealth and oldMaxHealth and not (oldHealth == (player:GetHearts() + player:GetRottenHearts()) and oldMaxHealth == player:GetEffectiveMaxHearts()) then
            print("torrent health changed")
            player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            player:EvaluateItems()
        end
        player:GetData().AbilityHealth = player:GetHearts() + player:GetRottenHearts()
        player:GetData().AbilityMaxHealth = player:GetEffectiveMaxHearts()
    end
end

function mod:ApplyBoost(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(torrent)
    if (itemCount > 0) and (player:GetHearts() <= (1/3 * player:GetEffectiveMaxHearts())) then
        local multiplier = (4/3)^itemCount
        if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
	        local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	        tearsPerSecond = multiplier * tearsPerSecond
	        player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
        end
	end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CheckHealth)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyBoost)