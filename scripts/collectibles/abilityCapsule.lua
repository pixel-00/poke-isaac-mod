local abilityCapsule = Isaac.GetItemIdByName("Ability Capsule")

local ABILITIES = {
    "Huge Power",
    "Intimidate",
    "Levitate",
    "Pickup",
    "Flash Fire",
    "Regenerator",
    "Technician",
    "Weak Armor",
    "Serene Grace",
    "Speed Boost",
    "Stall",
    "Parental Bond",
    "Effect Spore",
    "Cheek Pouch",
    "Soul-Heart",
    "Sturdy",
    "Slow Start",
    "Overgrow",
    "Blaze",
    "Torrent",
    "Hustle",
    "Emergency Exit",
    "Intrepid Sword",
    "Dauntless Shield",
    "Beast Boost",
    "Pickpocket",
    "Plus",
    "Minus",
    "Mega Launcher",
    "Stamina",
}

local LOST_BIRTHRIGHT_ABILITIES = {
    "Huge Power",
    "Intimidate",
    "Pickup",
    "Flash Fire",
    "Technician",
    "Serene Grace",
    "Speed Boost",
    "Stall",
    "Parental Bond",
    "Soul-Heart",
    "Sturdy",
    "Slow Start",
    "Overgrow",
    "Blaze",
    "Torrent",
    "Hustle",
    "Intrepid Sword",
    "Beast Boost",
    "Pickpocket",
    "Plus",
    "Minus",
    "Mega Launcher",
}

local TAINTED_LOST_ABILITIES = {
    "Huge Power",
    "Intimidate",
    "Pickup",
    "Technician",
    "Serene Grace",
    "Speed Boost",
    "Stall",
    "Parental Bond",
    "Soul-Heart",
    "Slow Start",
    "Overgrow",
    "Blaze",
    "Torrent",
    "Hustle",
    "Intrepid Sword",
    "Beast Boost",
    "Pickpocket",
    "Plus",
    "Minus",
    "Mega Launcher",
}


local function ClearAbilities(player)
    for _, ability in pairs(ABILITIES) do
        local collectible = Isaac.GetItemIdByName(ability)
        while player:HasCollectible(collectible) do
            player:RemoveCollectible(collectible)
        end
    end
end

local function GetAbility(player, rng)
    if player:GetPlayerType() == PlayerType.PLAYER_THELOST and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        return LOST_BIRTHRIGHT_ABILITIES[rng:RandomInt(#LOST_BIRTHRIGHT_ABILITIES) + 1]
    elseif player:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
        return TAINTED_LOST_ABILITIES[rng:RandomInt(#TAINTED_LOST_ABILITIES) + 1]
    else
        return ABILITIES[rng:RandomInt(#ABILITIES) + 1]
    end
end

local function GiveAbility(player, ability)
    local collectible = Isaac.GetItemIdByName(ability)
    player:AddCollectible(collectible)
end

function mod:UseItem(item, rng, player, useFlags, activeSlot, varData)
    ClearAbilities(player)
    local newAbility = GetAbility(player, rng)
    GiveAbility(player, newAbility)
    hud:ShowItemText(player, Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName(newAbility)), true)
    return {ShowAnim = true}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, abilityCapsule)