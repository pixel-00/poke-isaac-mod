local technicalRecord = Isaac.GetItemIdByName("Technical Record")
local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")
local looseFeathers = Isaac.GetItemIdByName("Loose Feathers")
local plantasia = Isaac.GetItemIdByName("Plantasia")

local TR_POOL = {
    CollectibleType.COLLECTIBLE_SPOON_BENDER,
    CollectibleType.COLLECTIBLE_FIRE_MIND,
    CollectibleType.COLLECTIBLE_JACOBS_LADDER,
    CollectibleType.COLLECTIBLE_URANUS,
    CollectibleType.COLLECTIBLE_TERRA,
    CollectibleType.COLLECTIBLE_PARASITOID,
    CollectibleType.COLLECTIBLE_HOLY_LIGHT,
    CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS,
    CollectibleType.COLLECTIBLE_DARK_MATTER,
    CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
    CollectibleType.COLLECTIBLE_SCORPIO,
    CollectibleType.COLLECTIBLE_8_INCH_NAILS,
    CollectibleType.COLLECTIBLE_POLYPHEMUS,
    CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    bubbleBeam,
    looseFeathers,
    plantasia
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

local function IsVanilla(ID)
    return ID == CollectibleType.COLLECTIBLE_SPOON_BENDER
        or ID == CollectibleType.COLLECTIBLE_FIRE_MIND
        or ID == CollectibleType.COLLECTIBLE_JACOBS_LADDER
        or ID == CollectibleType.COLLECTIBLE_URANUS
        or ID == CollectibleType.COLLECTIBLE_TERRA
        or ID == CollectibleType.COLLECTIBLE_PARASITOID
        or ID == CollectibleType.COLLECTIBLE_HOLY_LIGHT
        or ID == CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS
        or ID == CollectibleType.COLLECTIBLE_DARK_MATTER
        or ID == CollectibleType.COLLECTIBLE_DEATHS_TOUCH
        or ID == CollectibleType.COLLECTIBLE_SCORPIO
        or ID == CollectibleType.COLLECTIBLE_8_INCH_NAILS
        or ID == CollectibleType.COLLECTIBLE_POLYPHEMUS
        or ID == CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE
        or ID == CollectibleType.COLLECTIBLE_BRIMSTONE
end

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
        local hasCollectible = false
        if IsVanilla(collectible) then
            hasCollectible = player:HasCollectible(collectible)
        elseif collectible == bubbleBeam then
            hasCollectible = player:GetData().bubbleBeam
        elseif collectible == looseFeathers then
            hasCollectible = player:GetData().momsLashes
        elseif collectible == plantasia then
            hasCollectible = player:GetData().plantasia
        end
        if not hasCollectible then
            table.insert(trPool, collectible)
        end
    end
    if PoolSize(trPool) == 0 then
        return STACKABLE_POOL
    else
        return trPool
    end
end

function mod:UseTechnicalRecord(item, rng, player, useFlags, activeSlot, varData)
    local trPool = TRPool(player)
    local collectible = trPool[math.random(PoolSize(trPool) - 1)]
    player:AddCollectible(collectible, 0, true, 0, nil, ItemPoolType.POOL_NULL)
    return {
        Remove = true,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseTechnicalRecord, technicalRecord)