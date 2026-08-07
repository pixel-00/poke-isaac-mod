local junkFood = Isaac.GetItemIdByName("Junk Food")

function mod:GiveRottenHearts(pickup, collider, low)
    local player = collider:ToPlayer()
    if player and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
        if pickup.SubType == junkFood and not pickup.Touched then
            local heartsToAdd = player:GetEffectiveMaxHearts()
            player:AddRottenHearts(heartsToAdd)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.GiveRottenHearts)