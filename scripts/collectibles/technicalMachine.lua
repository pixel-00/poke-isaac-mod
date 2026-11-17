local technicalMachine = Isaac.GetItemIdByName("Technical Machine")
local bubbleBeam = Isaac.GetItemIdByName("Bubble Beam")
local looseFeathers = Isaac.GetItemIdByName("Loose Feathers")

local TM_POOL = {
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
    CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
    CollectibleType.COLLECTIBLE_SCORPIO,
    CollectibleType.COLLECTIBLE_8_INCH_NAILS,
    CollectibleType.COLLECTIBLE_POLYPHEMUS,
    CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    bubbleBeam,
    looseFeathers,
}

local function GetTMItem(tmPool, rng)
    if #tmPool == 0 then
        return nil
    else
        return tmPool[rng:RandomInt(#tmPool) + 1]
    end
end

-- Creates pool of item effects for items which the player does not already have
local function TMPool(player)
    local tmPool = {}

    for _, collectible in ipairs(TM_POOL) do
        if not player:HasCollectible(collectible) then
            table.insert(tmPool, collectible)
        end
    end
    return tmPool
end

function mod:UseTechnicalMachine(item, rng, player, useFlags, activeSlot, varData)
    local hud = Game():GetHUD()
    local effectToGive = GetTMItem(TMPool(player), rng)

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
        local function f(player)
            mod:SavePlayerData(player, "Technical Machine", hiddenItemManager:GetSaveData())
        end

        mod:DoForAllPlayers(f)
    end
end

function mod:LoadHiddenWisps(continued)
    if continued then
        local function f(player)
            local loadedData = mod:LoadPlayerData(player, "Technical Machine")
            hiddenItemManager:LoadData(loadedData)
        end

        mod:DoForAllPlayers(f)
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseTechnicalMachine, technicalMachine)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.SaveHiddenWisps)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.LoadHiddenWisps)