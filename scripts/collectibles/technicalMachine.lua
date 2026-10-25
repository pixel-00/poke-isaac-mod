local technicalMachine = Isaac.GetItemIdByName("Technical Machine")
local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")
local momsLashes = Isaac.GetItemIdByName("Mom's Lashes")
local plantasia = Isaac.GetItemIdByName("Plantasia")

local TM_POOL = {
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
    momsLashes,
    plantasia
}

local currentFloorItems = {}
local currentPool = {}
local currentStage = nil

local function GetTMItem()
    if currentPool.Size == 0 then
        return false
    else
        return currentPool[math.random(currentPool.Size - 1)]
    end
end

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

local function GiveEffect(effect, player)
    if IsVanilla(effect) then
        player:GetEffects():AddCollectibleEffect(effect, true, 1)
    elseif effect == bubbleBeam then
        player:GetData().bubbleBeam = true
    elseif effect == momsLashes then
        player:GetData().momsLashes = true
    elseif effect == plantasia then
        player:GetData().bulletSeed = true
    end
end

local function UpdateTMPool(player)
    currentPool = {}
    for _, collectible in pairs(TM_POOL) do
        local hasCollectible = false
        if IsVanilla(collectible) then
            hasCollectible = not player:GetEffects():HasCollectibleEffect(collectible)
        elseif collectible == bubbleBeam then
            hasCollectible = player:GetData().bubbleBeam
        elseif collectible == momsLashes then
            hasCollectible = player:GetData().momsLashes
        elseif collectible == plantasia then
            hasCollectible = player:GetData().bulletSeed
        end
        if not hasCollectible then
            table.insert(currentPool, collectible)
        end
    end
end

function mod:UseTechnicalMachine(item, rng, player, useFlags, activeSlot, varData)
    UpdateTMPool(player)
    local effectToGive = GetTMItem()
    if effectToGive then
        GiveEffect(effectToGive, player)
        table.insert(currentFloorItems, effectToGive)
        print(Isaac.GetItemConfig(effectToGive).Name)
    end
    return {ShowAnim = true}
end

function mod:GiveTMEffects()
    local player = Isaac.GetPlayer()
    if currentStage == Game():GetLevel():GetStage() then
        for _, effect in pairs(currentFloorItems) do
            GiveEffect(effect, player)
        end
    end
end

function mod:ClearTMs()
    currentFloorItems = {}
    currentStage = Game():GetLevel():GetStage()
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseTechnicalMachine, technicalMachine)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.GiveTMEffects)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ClearTMs)