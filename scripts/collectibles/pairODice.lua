local pairODice = Isaac.GetItemIdByName("Pair o' Dice")
local pairODiceAlt = Isaac.GetItemIdByName("Pair o' Dice​")

function mod:UseUnshaken(item, rng, player, useFlags, activeSlot, varData)
    local roomType = Game():GetLevel():GetCurrentRoom():GetType()

    varData = Game():GetItemPool():GetPoolForRoom(roomType, Game():GetSeeds():GetStartSeed())
    player:AddCollectible(pairODiceAlt, 0, false, activeSlot, varData, ItemPoolType.POOL_TREASURE)
    print(varData)
    return {ShowAnim = true}
end

function mod:UseShaken(item, rng, player, useFlags, activeSlot, varData)
    local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)
    local itemDesc = player:GetActiveItemDesc(activeSlot)
    local itemPool = itemDesc.VarData
    print(itemPool)

    for _, v in pairs(items) do
        local newItem = Game():GetItemPool():GetCollectible(itemPool, true, rng:Next(), CollectibleType.COLLECTIBLE_NULL, ItemPoolType.POOL_TREASURE)
        v:ToPickup():Morph(EntityType.ENTITY_PICKUP, v.Variant, newItem, true, false, false)
    end

    player:AddCollectible(pairODice, 0, false, activeSlot, 0, ItemPoolType.POOL_TREASURE)
    return {ShowAnim = true}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseUnshaken, pairODice)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseShaken, pairODiceAlt)