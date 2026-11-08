local technicalMachine = Isaac.GetItemIdByName("Technical Machine")
local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")
local looseFeathers = Isaac.GetItemIdByName("Loose Feathers")
local plantasia = Isaac.GetItemIdByName("Plantasia")

local hiddenItemManager = require("lib.hidden_item_manager")
local json = require("json")

local saveData = {}

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
    looseFeathers,
    plantasia
}

local function PoolSize(pool)
    local size = 0
    for _, i in pairs(pool) do
        size = size + 1
    end
    return size
end

local function GetTMItem(tmPool)
    if PoolSize(tmPool) == 0 then
        return false
    else
        return tmPool[math.random(PoolSize(tmPool)) - 1]
    end
end

-- Creates pool of item effects for items which the player does not already have
local function TMPool(player)
    local tmPool = {}
    for _, collectible in pairs(TM_POOL) do
        if not player:HasCollectible(collectible) then
            table.insert(tmPool, collectible)
        end
    end
    return tmPool
end

function mod:UseTechnicalMachine(item, rng, player, useFlags, activeSlot, varData)
    local hud = Game():GetHUD()
    local effectToGive = GetTMItem(TMPool(player))
    if effectToGive then
        hiddenItemManager:AddForFloor(player, effectToGive)
        hud:ShowItemText(player, Isaac.GetItemConfig():GetCollectible(effectToGive), true)
    else
        hud:ShowItemText("Technical Machine", "Nothing left to learn")
    end
    return {ShowAnim = true}
end

function mod:SaveHiddenWisps(shouldSave)
    if shouldSave then
        saveData.HIDDEN_ITEM_DATA = hiddenItemManager:GetSaveData()
        mod:SaveData(json.encode(saveData))
    end
end

function mod:LoadHiddenWisps(continued)
    if continued then
        if mod:HasData() then
            saveData = json.decode(mod:LoadData())
            hiddenItemManager:LoadData(saveData.HIDDEN_ITEM_DATA)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseTechnicalMachine, technicalMachine)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveHiddenWisps)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadHiddenWisps)