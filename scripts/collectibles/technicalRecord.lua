local technicalRecord = Isaac.GetItemIdByName("Technical Record")
local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")
local looseFeathers = Isaac.GetItemIdByName("Loose Feathers")

local TR_POOL = {
    CollectibleType.COLLECTIBLE_SPOON_BENDER,
    CollectibleType.COLLECTIBLE_FIRE_MIND,
    CollectibleType.COLLECTIBLE_APPLE,
    CollectibleType.COLLECTIBLE_JACOBS_LADDER,
    CollectibleType.COLLECTIBLE_URANUS,
    CollectibleType.COLLECTIBLE_TERRA,
    CollectibleType.COLLECTIBLE_PARASITOID,
    CollectibleType.COLLECTIBLE_HOLY_LIGHT,
    CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS,
    CollectibleType.COLLECTIBLE_DARK_MATTER,
    CollectibleType.COLLECTIBLE_DEATHS_TOUCH,--
    CollectibleType.COLLECTIBLE_SCORPIO,
    CollectibleType.COLLECTIBLE_8_INCH_NAILS,
    CollectibleType.COLLECTIBLE_POLYPHEMUS,
    CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,--
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    bubbleBeam,
    looseFeathers,
}

local STACKABLE_POOL = {
    CollectibleType.COLLECTIBLE_DARK_MATTER,
    CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
    CollectibleType.COLLECTIBLE_8_INCH_NAILS,
    CollectibleType.COLLECTIBLE_POLYPHEMUS,
    CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    bubbleBeam,
    looseFeathers,
}

local function PoolSize(pool)
    local size = 0
    for _, i in pairs(pool) do
        size = size + 1
    end
    return size
end

local function TRPool(player)
    local trPool = {}
    for _, collectible in pairs(TR_POOL) do
        if not player:HasCollectible(collectible) and Isaac.GetItemConfig():GetCollectible(collectible):IsAvailable() then
            table.insert(trPool, collectible)
        end
    end
    if PoolSize(trPool) == 0 then
        for _, collectible in pairs(STACKABLE_POOL) do
            if Isaac.GetItemConfig():GetCollectible(collectible):IsAvailable() then
                table.insert(trPool, collectible)
            end
        end
    end
    return trPool
end

function mod:UseTechnicalRecord(item, rng, player, useFlags, activeSlot, varData)
    local hud = Game():GetHUD()
    local trPool = TRPool(player)
    local collectible = trPool[math.random(PoolSize(trPool))]
    player:AddCollectible(collectible, 0, true, 0, nil, ItemPoolType.POOL_NULL)
    hud:ShowItemText(player, Isaac.GetItemConfig():GetCollectible(collectible), true)
    return {
        Remove = true,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseTechnicalRecord, technicalRecord)