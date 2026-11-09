local abilityCapsule = Isaac.GetItemIdByName("Ability Capsule")

-- add nolostbr and tainted lost functionality

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

NUM_ABILITIES = 30

local function ClearAbilities(player)
    for _, ability in pairs(ABILITIES) do
        local collectible = Isaac.GetItemIdByName(ability)
        while player:HasCollectible(collectible) do
            player:RemoveCollectible(collectible)
        end
    end
end

local function GiveAbility(player, ability)
    local collectible = Isaac.GetItemIdByName(ability)
    player:AddCollectible(collectible)
end

function mod:UseItem(item, rng, player, useFlags, activeSlot, varData)
    ClearAbilities(player)
    local newAbility = ABILITIES[math.random(NUM_ABILITIES)]
    GiveAbility(player, newAbility)
    hud:ShowItemText(player, Isaac.GetItemConfig():GetCollectible(Isaac.GetItemIdByName(ability)), true)
    return {ShowAnim = true}
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.UseItem, abilityCapsule)