local plus = Isaac.GetItemIdByName("Plus")
local minus = Isaac.GetItemIdByName("Minus")

function mod:ExtraCharge(rng, spawnPosition)
    local function f(player)
        if player:HasCollectible(plus) or player:HasCollectible(minus) then
            local x = rng:RandomInt(6)

            if x == 0 then
                for _, slot in pairs(ActiveSlot) do
                    if player:GetActiveItem(slot) > 0 then
                        local currentCharge = player:GetActiveCharge(slot) + player:GetBatteryCharge(slot)
                        local maxCharges = Isaac.GetItemConfig():GetCollectible(player:GetActiveItem(slot)).MaxCharges

                        if maxCharges <= currentCharge and currentCharge < 2 * maxCharges then
                            player:SetActiveCharge(currentCharge + 1)
                        end
                    end
                end
            end
        end
    end

    mod:DoForAllPlayers(f)
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

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.ExtraCharge)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ApplyStats)