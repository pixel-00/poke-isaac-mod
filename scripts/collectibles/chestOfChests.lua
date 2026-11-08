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
    PickupVariant.PICKUP_WOODENCHEST,
    PickupVariant.PICKUP_MEGACHEST,
    PickupVariant.PICKUP_HAUNTEDCHEST,
}

local NUM_CHESTS = 11
local NUM_CHESTS_UNTAINTED = 8

-- Tainteds must be unlocked to see wooden, mega, and haunted chests. Unfortunately, there is no easy way to check if these chest variants are actually unlocked
function mod:RandomChest()
    if Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_RED_KEY):IsAvailable() then
        return CHESTS[math.random(NUM_CHESTS)]
    else
        return CHESTS[math.random(NUM_CHESTS_UNTAINTED)]
    end
end

function mod:UseItem(item, rng, player, useFlags, activeSlot, varData)
    if player:GetNumKeys() > 0 then
        player:AddKeys(-1)
        local variant = mod:RandomChest()
        local subType = 0
        local x = math.random()
        if x < 0.01 then
            local y = math.random(3)
            if y <= 1 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LIL_CHEST):IsAvailable() then
                variant = PickupVariant.PICKUP_COLLECTIBLE
                subType = CollectibleType.COLLECTIBLE_LIL_CHEST
            elseif y <= 2 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BLUE_BOX):IsAvailable() then
                variant = PickupVariant.PICKUP_COLLECTIBLE
                subType = CollectibleType.COLLECTIBLE_BLUE_BOX
            elseif y <= 3 and Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_LIL_CHEST):IsAvailable() then
                variant = PickupVariant.PICKUP_COLLECTIBLE
                subType = CollectibleType.COLLECTIBLE_ISAACS_TOMB
            end
        end
        local room = Game():GetLevel():GetCurrentRoom()
        Game():Spawn(EntityType.ENTITY_PICKUP, variant, room:FindFreePickupSpawnPosition(player.Position), Vector(0, 0), player, subType, rng:GetSeed())
    end
    return{ShowAnim = true}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, chestOfChests)