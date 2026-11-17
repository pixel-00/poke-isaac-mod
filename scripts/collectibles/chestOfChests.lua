local chestOfChests = Isaac.GetItemIdByName("Chest of Chests")

local CHESTS = {
    PickupVariant.PICKUP_CHEST,
    PickupVariant.PICKUP_LOCKEDCHEST,
    PickupVariant.PICKUP_REDCHEST,
    PickupVariant.PICKUP_BOMBCHEST,
    PickupVariant.PICKUP_ETERNALCHEST,
    PickupVariant.PICKUP_SPIKEDCHEST,
    PickupVariant.PICKUP_MIMICCHEST,
    PickupVariant.PICKUP_OLDCHEST,
    PickupVariant.PICKUP_MEGACHEST,
    PickupVariant.PICKUP_WOODENCHEST,
    PickupVariant.PICKUP_HAUNTEDCHEST,
}

local NUM_CHESTS = 11

-- unlocked with mega chests

function mod:UseItem(item, rng, player, useFlags, activeSlot, varData)
    if player:GetNumKeys() > 0 then
        local variant = CHESTS[rng:RandomInt(#CHESTS) + 1]
        local subType = 0
        local x = rng:RandomFloat()

        player:AddKeys(-1)

        if x < 0.01 then
            local y = rng:RandomInt(3)

            if y <= 0 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LIL_CHEST):IsAvailable() then
                variant = PickupVariant.PICKUP_COLLECTIBLE
                subType = CollectibleType.COLLECTIBLE_LIL_CHEST
            elseif y <= 1 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BLUE_BOX):IsAvailable() then
                variant = PickupVariant.PICKUP_COLLECTIBLE
                subType = CollectibleType.COLLECTIBLE_BLUE_BOX
            elseif y <= 2 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_ISAACS_TOMB):IsAvailable() then
                variant = PickupVariant.PICKUP_COLLECTIBLE
                subType = CollectibleType.COLLECTIBLE_ISAACS_TOMB
            end

        end

        local room = Game():GetLevel():GetCurrentRoom()

        Game():Spawn(EntityType.ENTITY_PICKUP, variant, room:FindFreePickupSpawnPosition(player.Position + RandomVector()), Vector(0, 0), player, subType, rng:GetSeed())
    end

    return{ShowAnim = true}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, chestOfChests)