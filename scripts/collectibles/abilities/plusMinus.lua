local plus = Isaac.GetItemIdByName("Plus")
local minus = Isaac.GetItemIdByName("Minus")

function mod:ExtraCharge(player)
    if player:HasCollectible(plus) or player:HasCollectible(minus) then
        local oldCharge = player:GetData().PlusMinusAbilityActiveCharge
        local newCharge = player:GetActiveCharge()
        local maxCharges = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem()).MaxCharges
        if oldCharge and oldCharge < maxCharges and newCharge == maxCharges then
            player:SetActiveCharge(maxCharges + 1)
        end
        player:GetData().PlusMinusAbilityActiveCharge = player:GetActiveCharge()
    end
end

function mod:ApplyStats(player, cacheFlags)
    local hasPlus = false
    local hasMinus = false
    for i = 0, Game():GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(i)
        hasPlus = hasPlus or p:HasCollectible(plus)
        hasMinus = hasMinus or p:HasCollectible(minus)
    end
    if (hasPlus and hasMinus) and (player:HasCollectible(plus) or player:HasCollectible(minus)) then
        local itemCount = math.max(player:GetCollectibleNum(plus), player:GetCollectibleNum(minus))
        if (cacheFlags & CacheFlag.CACHE_DAMAGE) == CacheFlag.CACHE_DAMAGE then
            local damageMultiplier = 1.5^itemCount
            player.Damage = player.Damage * damageMultiplier
        end
        if (cacheFlags & CacheFlag.CACHE_FIREDELAY) == CacheFlag.CACHE_FIREDELAY then
            local tearsMultiplier = 1.5^itemCount
	        local tearsPerSecond = mod:ToTearsPerSecond(player.MaxFireDelay)
	        tearsPerSecond = tearsPerSecond * tearsMultiplier
	        player.MaxFireDelay = mod:ToMaxFireDelay(tearsPerSecond)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ExtraCharge)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)