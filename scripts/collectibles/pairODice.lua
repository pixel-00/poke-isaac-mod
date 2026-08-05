local pairODice = Isaac.GetItemIdByName("Pair o' Dice")

local shaken = false
local itemPool = RoomType.ROOM_NULL

function mod:UseItem(item, rng, player, useFlags, activeSlot, varData)
    if shaken then
        local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
        for i, v in pairs(items) do
            local newItem = Game():GetItemPool():GetCollectible(itemPool, true, mod:RandomPositive(), CollectibleType.COLLECTIBLE_NULL, ItemPoolType.POOL_TREASURE)
            v:ToPickup():Morph(EntityType.ENTITY_PICKUP, v.Variant, newItem, true, false, false)
        end
        shaken = false
    else
        local roomType = Game():GetLevel():GetCurrentRoom():GetType()
        itemPool = Game():GetItemPool():GetPoolForRoom(roomType, Game():GetSeeds():GetStartSeed())
        shaken = true
    end
    return {ShowAnim = true}
end

function mod:ResetPairODice(onContinue)
    if not onContinue then
        shaken = false
        itemPool = RoomType.ROOM_NULL
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, pairODice)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.UseItem, ResetPairODice)