include("scripts.utilities")

local luckyStar = Isaac.GetItemIdByName("Lucky Star")
local canRoll = true

function mod:LuckyRoll(oldCollectibleID, itemPoolType, decrease, seed)
    local player = Isaac.GetPlayer()
    if player:HasCollectible(luckyStar) and canRoll then
        print("--- Spawning a new item ---")
        local numRolls = math.floor(player.Luck / 10) + ((math.random() < (player.Luck % 10) / 10) and 1 or 0)
        print("You have " .. numRolls .. " rolls")
        local oldCollectible = Isaac.GetItemConfig():GetCollectible(oldCollectibleID)
        local oldQuality = oldCollectible.Quality
        print("Original item: " .. oldCollectible.Name .. ", quality: " .. oldQuality)
        while numRolls > 0 do
            canRoll = false
            local newSeed = RandomPositive()
            local newCollectibleID = Game():GetItemPool():GetCollectible(itemPoolType, false, newSeed, CollectibleType.COLLECTIBLE_NULL, ItemPoolType.POOL_TREASURE)
            local newCollectible = Isaac.GetItemConfig():GetCollectible(newCollectibleID)
            canRoll = true
            print("rolled: " .. newCollectible.Name .. ", quality: " .. newCollectible.Quality)
            if newCollectible.Quality > oldQuality then
                print("Replacing " .. oldCollectible.Name .. " with " .. newCollectible.Name)
                canRoll = false
                Game():GetItemPool():GetCollectible(itemPoolType, true, newSeed, newCollectibleID, ItemPoolType.POOL_TREASURE)
                canRoll = true
                return newCollectibleID
            end
            numRolls = numRolls - 1
        end
        print("Keeping old item")
        --return oldCollectibleID
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, mod.LuckyRoll)