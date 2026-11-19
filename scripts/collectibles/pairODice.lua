local pairODice = Isaac.GetItemIdByName("Pair o' Dice")
local pairODiceAlt = Isaac.GetItemIdByName("Pair o' Dice​")

local itemPool = ItemPoolType.POOL_NULL

function mod:UseUnshaken(item, rng, player, useFlags, activeSlot, varData)
    local roomType = Game():GetLevel():GetCurrentRoom():GetType()

    itemPool = Game():GetItemPool():GetPoolForRoom(roomType, Game():GetSeeds():GetStartSeed())
    player:AddCollectible(pairODiceAlt, 0, false, activeSlot, varData, ItemPoolType.POOL_TREASURE)
    SFXManager():Play(SoundEffect.SOUND_PANDORAS_BOX)

    return {ShowAnim = true}
end

function mod:UseShaken(item, rng, player, useFlags, activeSlot, varData)
    local items = Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1, false, false)

    for _, v in pairs(items) do
        local newItem = Game():GetItemPool():GetCollectible(itemPool, true, rng:Next(), CollectibleType.COLLECTIBLE_NULL, ItemPoolType.POOL_TREASURE)
        v:ToPickup():Morph(EntityType.ENTITY_PICKUP, v.Variant, newItem, true, false, false)
    end

    player:AddCollectible(pairODice, 0, false, activeSlot, 0, ItemPoolType.POOL_TREASURE)
    SFXManager():Play(SoundEffect.SOUND_D6_ROLL)

    return {ShowAnim = true}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseUnshaken, pairODice)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseShaken, pairODiceAlt)